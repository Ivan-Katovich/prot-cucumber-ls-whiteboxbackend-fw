import { Runner } from 'protractor/built/runner';
import { Plugins } from 'protractor/built/plugins';
import * as q from 'q';
import * as util from 'util';
import * as helper from 'protractor/built/util';
import { Logger } from 'protractor/built/logger';
import * as clientSideScripts from 'protractor/built/clientsidescripts.js';
const logger = new Logger('runner');


export function emptySpecsFix() {
  const seleniumWebdriver = require('selenium-webdriver');

  Runner.prototype.run = function() {
    let testPassed;
    const plugins = this.plugins_ = new Plugins(this.config_);
    let pluginPostTestPromises;
    let browser;
    let results;
    if (this.config_.framework !== 'explorer' && !this.config_.specs.length) {
      console.log('Spec patterns did not match any files.');

      return this.exit_(0);
    }
    if (this.config_.SELENIUM_PROMISE_MANAGER != null) {
      seleniumWebdriver.promise.USE_PROMISE_MANAGER = this.config_.SELENIUM_PROMISE_MANAGER;
    }
    if (this.config_.webDriverLogDir || this.config_.highlightDelay) {
      this.config_.useBlockingProxy = true;
    }

    return q(this.ready_)
      .then(() => {
        return this.driverprovider_.setupEnv();
      })
      .then(() => {
        browser = this.createBrowser(plugins);
        this.setupGlobals_(browser);

        return browser.ready.then(browser.getSession)
          .then((session) => {
            logger.debug(`WebDriver session successfully started with capabilities ${util.inspect(session.getCapabilities())}`);
          }, (err) => {
            logger.error('Unable to start a WebDriver session.');
            throw err;
          });
      })
      .then(() => {
        return plugins.setup();
      })
      .then(() => {
        let frameworkPath = '';
        if (this.config_.framework === 'jasmine' || this.config_.framework === 'jasmine2') {
          frameworkPath = './frameworks/jasmine.js';
        } else if (this.config_.framework === 'mocha') {
          frameworkPath = './frameworks/mocha.js';
        } else if (this.config_.framework === 'debugprint') {
          frameworkPath = './frameworks/debugprint.js';
        } else if (this.config_.framework === 'explorer') {
          frameworkPath = './frameworks/explorer.js';
        } else if (this.config_.framework === 'custom') {
          if (!this.config_.frameworkPath) {
            throw new Error('When config.framework is custom, ' +
              'config.frameworkPath is required.');
          }
          frameworkPath = this.config_.frameworkPath;
        } else {
          throw new Error(`config.framework ${this.config_.framework} is not a valid framework.`);
        }
        if (this.config_.restartBrowserBetweenTests) {
          const restartDriver = () => {
            if (!this.frameworkUsesAfterEach) {
              this.restartPromise = q(browser.restart());
            }
          };
          this.on('testPass', restartDriver);
          this.on('testFail', restartDriver);
        }
        pluginPostTestPromises = [];
        this.on('testPass', (testInfo) => {
          pluginPostTestPromises.push(plugins.postTest(true, testInfo));
        });
        this.on('testFail', (testInfo) => {
          pluginPostTestPromises.push(plugins.postTest(false, testInfo));
        });
        logger.debug(`Running with spec files ${this.config_.specs}`);

        return require(frameworkPath).run(this, this.config_.specs);
      })
      .then((testResults) => {
        results = testResults;

        return q.all(pluginPostTestPromises);
      })
      .then(() => {
        return plugins.teardown();
      })
      .then(() => {
        results = helper.joinTestLogs(results, plugins.getResults());
        this.emit('testsDone', results);
        testPassed = results.failedCount === 0;
        if (this.driverprovider_.updateJob) {
          return this.driverprovider_.updateJob({ passed: testPassed }).then(() => {
            return this.driverprovider_.teardownEnv();
          });
        } else {
          return this.driverprovider_.teardownEnv();
        }
      })
      .then(() => {
        return plugins.postResults();
      })
      .then(() => {
        const exitCode = testPassed ? 0 : 1;

        return this.exit_(exitCode);
      })
      .fin(() => {
        return this.shutdown_();
      });
  };
}

export function newWaitForAngularScript() {
  const scriptFmt = (
    `try { return (%s).apply(this, arguments); }
    catch(e) { throw (e instanceof Error) ? e : new Error(e); }`
  );

  const newWaitForAngular = `function(rootSelector, callback) {

    function getNg1Hooks(selector, injectorPlease) {
      function tryEl(el) {
        try {
          if (!injectorPlease && angular.getTestability) {
            var $$testability = angular.getTestability(el);
            if ($$testability) {
              return {$$testability: $$testability};
            }
          } else {
            var $injector = angular.element(el).injector();
            if ($injector) {
              return {$injector: $injector};
            }
          }
        } catch (err) {}
      }
      function trySelector(sel) {
        var els = document.querySelectorAll(sel);
        for (var i = 0; i < els.length; i++) {
          var elHooks = tryEl(els[i]);
          if (elHooks) {
            return elHooks;
          }
        }
      }
      if (selector) {
        return trySelector(selector);
      } else if (window.__TESTABILITY__NG1_APP_ROOT_INJECTOR__) {
        var $injector = window.__TESTABILITY__NG1_APP_ROOT_INJECTOR__;
        var $$testability = null;
        try {
          $$testability = $injector.get('$$testability');
        } catch (e) {}

        return {$injector: $injector, $$testability: $$testability};
      } else {
        return tryEl(document.body) ||
          trySelector('[ng-app]') || trySelector('[ng\\:app]') ||
          trySelector('[ng-controller]') || trySelector('[ng\\:controller]');
      }
    }

    try {
      var testCallback = callback;
      var waitForAngular2 = function() {
        if (window.getAngularTestability) {
          if (rootSelector) {
            var testability = null;
            var el = document.querySelector(rootSelector);
            try {
              testability = window.getAngularTestability(el);
            } catch (e) {}
            if (testability) {
              testability.whenStable(testCallback);
              return;
            }
          }
          var testabilities = window.getAllAngularTestabilities();
          var count = testabilities.length;
          if (count === 0) {
            testCallback();
            return;
          }
          var decrement = function() {
            count--;
            if (count <= 0) {
              testCallback();
            }
          };
          console.log('Own developed script for waiting Angular (mercury TAF) for Live API');
          testabilities.forEach(function(testability) {
            testability.whenStable(function() {
              decrement();
            }, 40000, function(arr) {
              var requests = arr.filter(req => {
                return req.source === 'XMLHttpRequest.send';
              });
              if (requests.length === 0) {
                decrement();
                return true;
              } else {
                return false;
              }
            });
          });
        } else {testCallback(); }
      };
      waitForAngular2();
    } catch (err) {
      callback(err.message);
    }
  }`;

  const newWaitForAngularPpe = `function(rootSelector, callback) {

    function getNg1Hooks(selector, injectorPlease) {
      function tryEl(el) {
        try {
          if (!injectorPlease && angular.getTestability) {
            var $$testability = angular.getTestability(el);
            if ($$testability) {
              return {$$testability: $$testability};
            }
          } else {
            var $injector = angular.element(el).injector();
            if ($injector) {
              return {$injector: $injector};
            }
          }
        } catch (err) {}
      }
      function trySelector(sel) {
        var els = document.querySelectorAll(sel);
        for (var i = 0; i < els.length; i++) {
          var elHooks = tryEl(els[i]);
          if (elHooks) {
            return elHooks;
          }
        }
      }
      if (selector) {
        return trySelector(selector);
      } else if (window.__TESTABILITY__NG1_APP_ROOT_INJECTOR__) {
        var $injector = window.__TESTABILITY__NG1_APP_ROOT_INJECTOR__;
        var $$testability = null;
        try {
          $$testability = $injector.get('$$testability');
        } catch (e) {}

        return {$injector: $injector, $$testability: $$testability};
      } else {
        return tryEl(document.body) ||
          trySelector('[ng-app]') || trySelector('[ng\\:app]') ||
          trySelector('[ng-controller]') || trySelector('[ng\\:controller]');
      }
    }

    try {
      var testCallback = callback;
      var waitForAngular2 = function() {
        if (window.getAngularTestability) {
          if (rootSelector) {
            var testability = null;
            var el = document.querySelector(rootSelector);
            try {
              testability = window.getAngularTestability(el);
            } catch (e) {}
            if (testability) {
              testability.whenStable(testCallback);
              return;
            }
          }
          var testabilities = window.getAllAngularTestabilities();
          var count = testabilities.length;
          if (count === 0) {
            testCallback();
            return;
          }
          var decrement = function() {
            count--;
            if (count <= 0) {
              testCallback();
            }
          };
          console.log('Own developed script for waiting Angular (mercury TAF) for PPE API');
          testabilities.forEach(function(testability) {
            testability.whenStable(function() {
              decrement();
            }, 40000, function(arr) {
              var requests = arr.filter(req => {
                return req.source === 'XMLHttpRequest.send';
              });
              var ppeRequests = requests.filter(req => {
                return req.data.url.indexOf('conversionratefxmarkets') === -1;
              });
              console.log(ppeRequests);
              if (ppeRequests.length === 0) {
                decrement();
                return true;
              } else {
                return false;
              }
            });
          });
        } else {testCallback(); }
      };
      waitForAngular2();
    } catch (err) {
      callback(err.message);
    }
  }`;
  // TODO: When "/tradingapi/market/conversionratefxmarkets" request will work faster separeted script for PPE should be deleted.

  const fnc = process.env.npm_config_env === 'ppe' ? newWaitForAngularPpe : newWaitForAngular;

  const waitForAngular = util.format(scriptFmt, fnc);
  const script = util.format('%s: %s', 'waitForAngular', fnc);

  clientSideScripts.waitForAngular = waitForAngular;
  clientSideScripts.installInBrowser = `${clientSideScripts.installInBrowser.replace(/};$/, '')}, ${script}};`;
}
