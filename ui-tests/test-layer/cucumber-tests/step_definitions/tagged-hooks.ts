import { defineSupportCode } from 'cucumber';
import { browser } from 'protractor';
import { accounts } from '../../../configs/data/account-pool';


defineSupportCode(function({ Before, After }) {

  Before('@delete-watchlist', async function() {
    const num = await this.backendHelper.deleteWatchlists();
    if (num > 0) {
      await browser.get(browser.baseUrl);
      await this.helper.alertsReset();
    }
  });

  Before('@relogin-for-currencies-test', async function() {
    await browser.executeScript('window.sessionStorage.clear();');
    await this.backendHelper.deleteSession();
    await browser.get(browser.baseUrl);
    await this.loginPage.signIn(accounts['specific ppe accounts'].czech, 'password');
    await this.helper.alertsReset();
    await this.basePage.waitLoading();
    await this.backendHelper.setSession();
    await this.backendHelper.clearPositionsAndOrders();
    await this.backendHelper.resetClientPreferences();
    await this.backendHelper.setClientPreference('MERCURY_TUTORIAL_COMPLETED', true);
    await this.helper.alertsReset();
  });

  Before('@statements-and-contracts', async function() {
    await browser.executeScript('window.sessionStorage.clear();');
    await this.backendHelper.deleteSession();
    await browser.get(browser.baseUrl);
    await this.loginPage.signIn(accounts['specific ppe accounts']['statements and contracts'], 'password');
    await this.helper.alertsReset();
    await this.basePage.waitLoading();
    await this.backendHelper.setSession();
  });

  Before('@price-alerts', async function() {
    await this.backendHelper.clearPriceAlerts();
  });

  After('@default-resize-window', async function() {
    const size = {
      height: parseInt(process.env.npm_config_size.split(',')[1]),
      width: parseInt(process.env.npm_config_size.split(',')[0]),
    };

    await browser.driver.manage().window().setSize(size.width, size.height);
  });

  After('@delete-watchlist', function() {
    return this.backendHelper.deleteWatchlists()
      .catch((err) => console.log(`${err.status} error during watchlist deleting`));
  });

  After('@account-details', function() {
    console.log(this.memory['password changed']);
    console.log(this.memory['new password']);
    if (this.memory['password changed']) {
      return this.backendHelper.changePassword(this.memory['new password'], 'password');
    }
  });

  After('@statements-and-contracts', async function() {
    await browser.executeScript('window.sessionStorage.clear();');
    await this.backendHelper.deleteSession();
    await browser.get(browser.baseUrl);
    await this.loginPage.signIn(browser.params.login, browser.params.password);
    await this.helper.alertsReset();
    await this.basePage.waitLoading();
    await this.backendHelper.setSession();
  });

  After('@relogin-default-user', async function() {
    await browser.executeScript('window.sessionStorage.clear();');
    await this.backendHelper.deleteSession();
    await browser.get(browser.baseUrl);
    await this.loginPage.signIn(browser.params.login, browser.params.password);
    await this.helper.alertsReset();
    await this.basePage.waitLoading();
    await this.backendHelper.setSession();
  });

  After('@price-alerts', async function() {
    await this.backendHelper.clearPriceAlerts();
  });

  After('@handles', async function() {
    await browser.getAllWindowHandles().then(async(handles) => {
      if (handles.length > 1) {
        const {appWindow} = this.memory;
        for (let i = 0; i < handles.length; ++i) {
          const currentTab = handles[i];
          if (currentTab !== appWindow) {
            await browser.switchTo().window(currentTab);
            await browser.close();
          }
        }
        await browser.switchTo().window(appWindow);
      }
    });
  });
});
