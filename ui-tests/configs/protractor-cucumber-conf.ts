/* process.env.https_proxy = 'http://127.0.0.1:8888';
process.env.http_proxy = 'http://127.0.0.1:8888'; */
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

import { browser } from 'protractor';
import * as reporter from 'cucumber-html-reporter';
import { environment } from './data/environment';
import { capabilities } from './data/capabilities';
import { browsersProcesses, driversProcesses } from './data/browsers-processes';
import { seleniumServers } from './data/selenium-servers';
import { ownProcess } from '../support/utils/background-processes';
import { LoginPage } from '../support/objects/pages/login-page';
import { BasePage } from '../support/objects/pages/base-page';
import { backendHelper } from '../support/utils/backend-helper';
import * as lightstreamer from '../support/utils/lightstreamer-helper';
import { userCreator } from '../support/utils/user-creator';
import { helper } from '../support/utils/helper';
import { emptySpecsFix, newWaitForAngularScript } from '../support/utils/protractor-fixes';

emptySpecsFix();
newWaitForAngularScript();

const envFullName = {
  local: 'LOCAL',
  ppe: 'PRE PRODUCTION',
  stg: 'STAGING',
  qat: 'QAT',
  live: 'LIVE',
  dev: 'DEVELOPMENT'
};

process.env.npm_config_selenium = process.env.npm_config_selenium ? process.env.npm_config_selenium : 'local';
process.env.npm_config_env = process.env.npm_config_env ? process.env.npm_config_env : 'local';
process.env.npm_config_browser = process.env.npm_config_browser ? process.env.npm_config_browser : 'chrome';
const size = {
  height: parseInt(process.env.npm_config_size.split(',')[1]),
  width: parseInt(process.env.npm_config_size.split(',')[0]),
};
const tags = process.env.npm_config_tags ? process.env.npm_config_tags.split(',') : [];
tags.push('~@ignore');
if (process.env.npm_config_env !== 'ppe') {
  tags.push('~@ppe');
}
if (process.env.npm_config_browser === 'safari') {
  tags.push('~@no-safari');
}
if (process.env.npm_config_browser === 'edge') {
  tags.push('~@no-edge');
}
if (process.env.npm_config_browser === 'ie11') {
  tags.push('~@no-ie11');
}
if (process.env.npm_config_browser.includes('chrome')) {
  tags.push('~@no-chrome');
}
if (process.env.npm_config_browser.includes('firefox')) {
  tags.push('~@no-firefox');
}
if (!process.env.npm_config_appVersion) {
  tags.push('~@no-unidentified-version');
}
const metadata = {
  'App Version': null,
  'Test Environment': envFullName[process.env.npm_config_env],
  Browser: null,
  Platform: null,
  'User Name': null,
  'Execution time': null,
  'Rerun execution time': null
};
let brows: string;
let isItRun = false;
let browserProcessesBeforeExecution;
let seleniumServerProcess;

console.log(
`  =============================================================
  environment: ${process.env.npm_config_env}
  browser: ${process.env.npm_config_browser}
  selenium: ${process.env.npm_config_selenium}
  tags: ${tags}
  rerun: ${!!process.env.npm_config_rerun}
  =============================================================`);

exports.config = {
  plugins: [
    { path: '../support/utils/protractor-extensions' }
  ],

  specs: helper.specsBuilder(),

  seleniumAddress: seleniumServers[process.env.npm_config_selenium],

  capabilities: capabilities[process.env.npm_config_browser],

  baseUrl: environment[process.env.npm_config_env].baseUrl,

  params: environment[process.env.npm_config_env],

  async beforeLaunch() {

    browserProcessesBeforeExecution = await ownProcess.getProcessPids(browsersProcesses[process.env.npm_config_browser]);
    console.log(`There are ${browserProcessesBeforeExecution.length} browser processes before test execution`);
    seleniumServerProcess = await ownProcess.getProcessPids(4444);
    console.log(`Selenium server process is ${seleniumServerProcess}`);

    const arr = [];
    if (process.env.npm_config_wd) {
      arr.push(ownProcess.webdriverManagerStart());
    }
    if (process.env.npm_config_app) {
      arr.push(ownProcess.runApp());
    }

    return Promise.all(arr);
  },

  async onPrepare() {
    const basePage = new BasePage();
    isItRun = true;
    let account = null;

    if (!process.env.npm_config_browser.includes('chrome')) {
      await browser.manage().window().setSize(size.width, size.height);
    }

    if (process.env.npm_config_newacc) {
      if (process.env.npm_config_env as string === 'ppe' && process.env.npm_config_env as string === 'qat') {
        throw new Error(`Can't create new acc for '${process.env.npm_config_env}' env`);
      }
      await userCreator.getSessionInforForAccountCreation();
      await browser.waitForAngularEnabled(false);
      await browser.get(browser.params.loginUrl);
      await browser.waitForAngularEnabled(true);
      if (process.env.npm_config_browser === 'ie11') {
        await browser.executeScript('window.localStorage.clear();');
        await browser.get(browser.params.loginUrl);
      }
      account = await userCreator.createUser()
        .catch((err) => {
          throw new Error(`Can't create new user:\n ${err}`);
        });
    } else {
      await browser.waitForAngularEnabled(false);
      await browser.get(browser.params.loginUrl);
      await browser.waitForAngularEnabled(true);
      if (process.env.npm_config_browser === 'ie11') {
        await browser.executeScript('window.localStorage.clear();');
        await browser.get(browser.params.loginUrl);
      }

      const testScopeInfo = tags.includes('@regression') ? 'regression ' : '';
      account = await userCreator.getUserFromPool(testScopeInfo);
    }
    browser.params.login = account.username;
    browser.params.password = account.password;
    environment[process.env.npm_config_env].login = account.username;
    metadata['User Name'] = account.username;
    console.log(`Log in into ${account.state} account with login:'${account.username}' and password:'${account.password}'`);

    await new LoginPage().signIn(account.username, account.password);
    await helper.alertsReset();
    await basePage.waitLoading();
    await lightstreamer.setLsUrl();
    await lightstreamer.connectLS();
    const caps = await browser.getCapabilities();

    brows = caps.get('browserName');
    switch (process.env.npm_config_browser) {
      case 'chrome':
        metadata.Browser = `${caps.get('browserName')} ${caps.get('version')}`;
        metadata.Platform = caps.get('platform');
        break;
      case 'chromeHeadless':
        metadata.Browser = `${caps.get('browserName')} ${caps.get('version')}`;
        metadata.Platform = caps.get('platform');
        break;
      case 'firefox':
        metadata.Browser = `${caps.get('browserName')} ${caps.get('browserVersion')}`;
        metadata.Platform = `${caps.get('platformName')} ${caps.get('platformVersion')}`;
        break;
      case 'firefoxHeadless':
        metadata.Browser = `${caps.get('browserName')} ${caps.get('browserVersion')}`;
        metadata.Platform = `${caps.get('platformName')} ${caps.get('platformVersion')}`;
        break;
      default:
        metadata.Browser = `${caps.get('browserName')} ${caps.get('version')}`;
        metadata.Platform = caps.get('platform');
    }

    metadata['App Version'] = await basePage.getVersion();
    await backendHelper.clearPositionsAndOrders();
    await backendHelper.resetClientPreferences();
    await backendHelper.setClientPreference('MERCURY_TUTORIAL_COMPLETED', true);
    await backendHelper.setClientPreference('HEDGE_PREFERENCE', 'off');
    await backendHelper.setClientPreference('USER_INACTIVITY', '24');
    await backendHelper.setClientPreference('TIME_ZONE', 'GMT Standard Time');
    await backendHelper.setClientPreference('MERCURY_DATE_FORMAT', 'DD/MM/YYYY');
    await backendHelper.changeUserAccountEmail('MercuryAutomation.UserZero@gaincapital.com');
  },

  async afterLaunch() {
    try {
      lightstreamer.disconnectLS();
    } catch (err) {
      console.log('Lightstreamer is not set up');
    }

    helper.smallResultsBuilder();

    metadata['Execution time'] = helper.getSmallResults('run').time;
    if (process.env.npm_config_rerun) {
      metadata['Rerun execution time'] = helper.getSmallResults('rerun').time;
    }

    const options = {
      theme: 'bootstrap',
      jsonFile: 'ui-tests/results.json',
      output: 'ui-tests/reports/cucumber-alternative/cucumber_report.html',
      reportSuiteAsScenarios: true,
      storeScreenshots: true,
      ignoreBadJsonFile: true,
      name: `Advantage Plus: ${envFullName[process.env.npm_config_env]} - ${brows}`,
      metadata: metadata
    };

    const arr = [];
    if (process.env.npm_config_wd) {
      arr.push(ownProcess.wdStop());
    }
    if (process.env.npm_config_app) {
      arr.push(ownProcess.appStop());
    }

    await Promise.all(arr);
    if (process.env.npm_config_rerun) {
      await helper.reportBuilder();
    }

    const browserProcessesAfterExecution = await ownProcess.getProcessPids(browsersProcesses[process.env.npm_config_browser]);
    console.log(`There are ${browserProcessesAfterExecution.length} browser processes after test execution`);
    await ownProcess.killAllHungProcesses(browserProcessesBeforeExecution, browserProcessesAfterExecution);

    const driversProcessesAfterExecution = await ownProcess.getProcessPids(driversProcesses[process.env.npm_config_browser]);
    console.log(`There are ${driversProcessesAfterExecution.length} driver processes after test execution`);
    await ownProcess.killAllHungProcesses(seleniumServerProcess, driversProcessesAfterExecution);

    if (isItRun) {
      await reporter.generate(options);
    }
    if (process.env.npm_config_mail) {
      await helper.sendMail();
    }
  },

  ignoreUncaughtExceptions: true,

  framework: 'custom',

  frameworkPath: require.resolve('protractor-cucumber-framework'),

  cucumberOpts: {
    require: [
      '../test-layer/cucumber-tests/world.js',
      '../test-layer/cucumber-tests/step_definitions/**/*.js',
      '../test-layer/cucumber-tests/step_definitions/*.js'
    ],
    'dry-run': !!process.env.npm_config_dryrun,
    format: process.env.npm_config_rerun ?
      ['rerun:ui-tests/@rerun.txt', 'json:ui-tests/results-rerun.json'] :
      ['rerun:ui-tests/@rerun.txt', 'json:ui-tests/results.json'],
    tags: tags
  },

  allScriptsTimeout: 120000

};
