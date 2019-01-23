import { defineSupportCode } from 'cucumber';
import { browser } from 'protractor';
import { results } from '../../results';
import * as moment from 'moment';

defineSupportCode(function({ Before, After, setDefaultTimeout }) {

  setDefaultTimeout(180000);

  Before(async function() {
    if (process.env.npm_config_env === 'ppe') {
      try {
        await browser.switchTo().alert().accept();
        await this.helper.alertsReset();
      } catch (err) {
        console.log('no alerts');
      }
    }
  });

  Before(async function() {
    let iterator = 0;
    const reset = async(max) => {
      try {
        await browser.wait(() => {
          return this.basePage.currentBoard.header.getTabsNumber()
            .then((c) => this.helper.sleepIfFalse(c === 3, 500));
        }, 10000)
          .then(() => null, () => null);
        const isDefaultTabActive = await this.basePage.currentBoard.header.getTab('Default Workspace').isActive();
        const count = await this.basePage.currentBoard.header.getTabsNumber();
        if ((count !== 3 || !isDefaultTabActive) && iterator < max) {
          iterator += 1;
          console.log(`Wrong account options reset. Reset again after 10 sec. Attempt  ${iterator}`);

          await this.helper.alertsReset();
          await this.backendHelper.resetClientPreferences();
          if (process.env.npm_config_browser.includes('edge')) {
            console.log('refresh in edge');
            await browser.refresh();
          }
          await this.helper.sleep(10000);
          await browser.get(browser.baseUrl);
          await this.helper.alertsReset();
          await reset(max);
          await this.helper.alertsReset();
        }
      } catch (err) {
        await this.helper.alertsReset();
        await this.helper.sleep(5000);
        await reset(max);
        await this.helper.alertsReset();
      }
    };

    await this.helper.alertsReset();
    await browser.get(browser.baseUrl);
    await this.helper.alertsReset();
    let parsedSession = null;
    parsedSession = await browser.executeScript('return window.sessionStorage.getItem("web_trader_session");');
    if (!parsedSession) {
      parsedSession = await browser.executeScript('return window.localStorage.getItem("web_trader_session");');
    }
    if (!parsedSession) {
      await this.loginPage.signIn(browser.params.login, browser.params.password);
    }
    await this.basePage.waitLoading();
    await this.backendHelper.setSession();
    await this.backendHelper.setAccount();
    await reset(5);
    await this.helper.alertsReset();
    try {
      await this.backendHelper.clearPositionsAndOrders();
    } catch (err) {
      console.log(`Can't delete all positions or orders`);
    }
  });

  Before(async function() {
    const status = this.lightstreamer.getLsStatus();
    console.log(status);
    if (status.includes('DISCONNECTED')) {
      console.log('reconnect to LS');
      await this.lightstreamer.connectLS();
    }
  });

  Before(async function(scenario) {
    if (!results.version) {
      results.version = await this.basePage.getVersion();
    }
    const file = scenario.sourceLocation.uri.replace(/.+features\\(.+)/, '$1');
    console.log(`\n================================================================
feature: "${file}"
Scenario "${scenario.pickle.name}": starts
app version: ${results.version}
----------------------------------------------------------------`);
  });

  After(function(scenario) {
    const duration = this.moment.duration(moment().diff(results.start));
    const hours = duration._data.hours;
    const minutes = duration._data.minutes;
    const seconds = duration._data.seconds;
    results.duration = duration;
    results.time = `${hours}h ${minutes}m ${seconds}s`;
    scenario.result.status === 'passed' ? results.passed += 1 : results.failed += 1;
    console.log(`\n----------------------------------------------------------------
Scenario "${scenario.pickle.name}": ${scenario.result.status}
Test duration: ${(scenario.result.duration / 1000).toFixed(2)} sec
Execution time: ${hours}h ${minutes}m ${seconds}s
Statistic:
Passed scenarios: ${results.passed}
Failed scenarios: ${results.failed}
================================================================\n`);
  });

  After(async function() {
    try {
      await this.backendHelper.clearPositionsAndOrders();
    } catch (err) {
      console.log(`Can't delete all positions or orders`);
    }
  });

  After(async function() {
    try {
      await this.backendHelper.resetClientPreferences();
    } catch (err) {
      console.log(`Can't reset all preferences`);
    }
  });

  After(async function(scenario) {
    if (scenario.result.status !== 'passed') {
      return browser.takeScreenshot()
        .then((png) => this.attach(png, 'image/png'), (error) => console.log(error));
    }
  });

});
