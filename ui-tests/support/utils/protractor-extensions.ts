import { browser, by, By } from 'protractor';
import { helper } from './helper';


(function() {
  'use strict';
  const specTimeoutMs = 40000,
    sleepIncrement = 200,
    protractor = require('protractor'),
    q = require('q');

  /**
   * This is used when an element is expected to 'move' into a position.
   * It will check the left most edge of the element is on screen (i.e. greater than or equal 0)
   * and then check it becomes 'stable' (i.e. not changed)
   *
   * @returns a promise that resolves to the element
   */
  protractor.ElementFinder.prototype.waitToBeCompletelyVisibleAndStable = function() {
    const self = this;
    let lastXLocation;
    let lastYLocation;
    let sleepTime = 1;

    function isCompletelyVisible(location, size) {
      if (location.x >= 0) {
        if (location.x + size.width >= 0) {
          return true;
        }
      }

      return false;
    }

    return self.getSize()
      .then(function(size) {
        browser.wait(function() {
          return helper.sleep(sleepTime)
            .then(function() {
              sleepTime = sleepTime + sleepIncrement;

              return self.getLocation();
            })
            .then(function(location) {
              if (lastXLocation === undefined) {
                lastXLocation = location.x;
                lastYLocation = location.y;
              } else {
                if (isCompletelyVisible(location, size) && (lastXLocation === location.x && lastYLocation === location.y)) {
                  return true;
                } else {
                  lastXLocation = location.x;
                  lastYLocation = location.y;
                }
              }

              return false;
            })
            .then((state) => state, () => false);
        }, specTimeoutMs, 'timed out waiting for element to be completely visible and stable');
      })
      .then (function() {
        return self;
      });
  };

  /**
   * This is used when an element is faded out and therefore takes some time to be 'hidden'.
   * This should be used when the element can be controlled outside of Angulars digests cycles (e.g. css animations)
   *
   * @returns a promise that resolves to true when the element is hidden
   */
  protractor.ElementFinder.prototype.waitToBeHidden = function() {
    const self = this;

    return browser.wait(function() {
      return self.isDisplayed()
        .then(function(displayed) {
          return !displayed;
        });
    }, specTimeoutMs, 'timed out waiting for element to be hidden');
  };

  /**
   * This is used to explicity wait for an element to become present and displayed
   * This should be used when the element can be controlled outside of Angulars digests cycles (e.g. css animations)
   *
   * @returns a promise that resolves to the element
   */

  protractor.ElementFinder.prototype.waitReady = function(timeout = specTimeoutMs) {
    const self = this;
    let sleepTime = 100;

    return browser.wait(function() {
      return self.isPresentAndDisplayed()
        .then(function(is) {
          if (!is) {
            return helper.sleep(sleepTime)
              .then(function() {
                sleepTime = sleepTime + sleepIncrement;

                return is;
              });
          } else {
            return is;
          }
        });
    }, timeout, 'element has not become present and visible after timeout')
      .then(function() {
        return self;
      });
  };

  protractor.ElementFinder.prototype.waitPresent = function(timeout = specTimeoutMs) {
    const self = this;
    let sleepTime = 100;

    return browser.wait(function() {
      return self.isPresent()
        .then(function(is) {
          if (!is) {
            return helper.sleep(sleepTime)
              .then(function() {
                sleepTime = sleepTime + sleepIncrement;

                return is;
              });
          } else {
            return is;
          }
        });
    }, timeout, 'element has not become present after timeout')
      .then(function() {
        return self;
      });
  };

  protractor.ElementFinder.prototype.waitVisible = function() {
    const self = this;

    return browser.wait(function() {
      return self.isDisplayed();
    }, specTimeoutMs, 'timed out waiting for element')
      .then(function() {
        return self;
      });
  };

  protractor.ElementFinder.prototype.waitMissing = function(timeout = specTimeoutMs) {
    const self = this;
    let sleepTime = 500;

    return browser.wait(function() {
      return self.isPresentAndDisplayed()
        .then(function(is) {
          if (is) {
            return helper.sleep(sleepTime)
              .then(function() {
                sleepTime = sleepTime + sleepIncrement;

                return !is;
              });
          } else {
            return !is;
          }
        });
    }, timeout, 'timed out waiting for element disappear');
  };

  protractor.ElementFinder.prototype.waitText = function(expectedText: string, timeout: number = specTimeoutMs) {
    const self = this;
    let sleepTime = 100;

    return browser.wait(function() {
      return self.getText()
        .then(function(text) {
          return text.trim().toLowerCase() === expectedText.toLowerCase();
        })
        .then(function(is) {
          if (!is) {
            return helper.sleep(sleepTime)
              .then(function() {
                sleepTime = sleepTime + sleepIncrement;

                return is;
              });
          } else {
            return is;
          }
        });
    }, timeout, `timed out waiting for element has text ${expectedText}`);
  };

  protractor.ElementFinder.prototype.waitTextIncludes = function(expectedText: string, timeout: number = specTimeoutMs) {
    const self = this;
    let sleepTime = 100;

    return browser.wait(function() {
      return self.getText()
        .then(function(text) {
          return text.trim().toLowerCase().includes(expectedText.toLowerCase());
        })
        .then(function(is) {
          if (!is) {
            return helper.sleep(sleepTime)
              .then(function() {
                sleepTime = sleepTime + sleepIncrement;

                return is;
              });
          } else {
            return is;
          }
        });
    }, timeout, `timed out waiting for element includes text ${expectedText}`);
  };

  /**
   * This is used to determine an element is present (in the DOM) and is displayed.
   *
   * @returns a promise that resolves to true or false
   */
  protractor.ElementFinder.prototype.isPresentAndDisplayed = function() {
    const self = this;

    return self.isPresent().then(function(present) {
      if (present) {
        return self.isDisplayed()
          .then((is) => is, () => false);
      }

      return false;
    });
  };

  protractor.ElementFinder.prototype.scrollIntoView = function(alignToTop) {
    const self = this;
    alignToTop = alignToTop !== undefined ? alignToTop : true;

    return browser.executeScript('arguments[0].scrollIntoView(arguments[1]);', self.getWebElement(), alignToTop)
      .then(function() {
        return self.waitToBeCompletelyVisibleAndStable();
      });
  };

  protractor.ElementFinder.prototype.scrollToAndClick = function() {
    const self = this,
      alignToTop = false;

    return this.scrollIntoView(alignToTop)
      .then(function() {
        return self.click();
      });
  };

  protractor.ElementFinder.prototype.ctrlClick = function() {
    const self = this;

    return browser.actions().keyDown(protractor.Key.CONTROL).click(self).keyUp(protractor.Key.CONTROL).perform()
      .then(() => null, () => console.log('actions error'));
  };

  protractor.ElementFinder.prototype.hover = function() {
    const self = this;

    return browser.actions().mouseMove(self).perform()
      .then(() => null, () => console.log('actions error'));
  };

  protractor.ElementFinder.prototype.shiftClick = function() {
    const self = this;

    return browser.actions().keyDown(protractor.Key.SHIFT).click(self).keyUp(protractor.Key.SHIFT).perform()
      .then(() => null, () => console.log('actions error'));
  };

  protractor.ElementFinder.prototype.doubleClick = function() {
    const self = this;

    return browser.actions().doubleClick(self).perform()
      .then(() => null, () => console.log('actions error'));
  };
  protractor.ElementFinder.prototype.contextClick = function() {
    const self = this;

    return browser.actions().mouseMove(self).perform()
      .then(() => null, () => console.log('actions error'))
      .then(function() {
        browser.actions().click(protractor.Button.RIGHT).perform()
          .then(() => null, () => console.log('actions error'));
      });
  };

  protractor.ElementArrayFinder.prototype.isHiddenOrNotPresent = function() {
    const self = this,
      deferred = q.defer();
    self.count()
      .then(function(n) {
        if (n > 0) {
          self.get(0).isDisplayed()
            .then(function(is) {
              deferred.resolve(!is);
            });
        } else {
          deferred.resolve(true);
        }
      });

    return deferred.promise;
  };

  protractor.ElementArrayFinder.prototype.isPresent = function() {
    const self = this,
      deferred = q.defer();
    self.count()
      .then(function(n) {
        deferred.resolve(n > 0);
      });

    return deferred.promise;
  };

  protractor.ElementArrayFinder.prototype.waitForDisappeared = function() {
    const self = this;

    return browser.wait(function() {
      return self.isHiddenOrNotPresent()
        .then(function(is) {
          return is;
        });
    }, specTimeoutMs, 'timed out waiting for element')
      .then(function() {
        return self.get(0);
      });
  };

  protractor.ElementArrayFinder.prototype.waitForAppeared = function() {
    const self = this;

    return browser.wait(function() {
      return self.isHiddenOrNotPresent()
        .then(function(is) {
          return !is;
        });
    }, specTimeoutMs, 'timed out waiting for element')
      .then(function() {
        return self.get(0);
      });
  };

})();
