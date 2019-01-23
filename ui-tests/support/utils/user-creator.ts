/* tslint:disable:max-line-length */
import * as rp from 'request-promise';
import { browser } from 'protractor';
import { accounts } from '../../configs/data/account-pool';

export let userCreator = {
  async getSessionInforForAccountCreation() {
    await browser.waitForAngularEnabled(false);
    await browser.get(`https://www1.applyforanaccount.com/testdemo`);
    const url = await browser.getCurrentUrl();
    process.env.userCreationSessionKey = url.replace(/.*sessionKey=(.+)&.*/, '$1');
    const cookie = await browser.manage().getCookie('ASP.NET_SessionId');
    process.env.userCreationCookie = cookie.value;
    await browser.waitForAngularEnabled(true);
  },

  getUserFromPool(testScope: string) {
    const username = accounts[process.env.npm_config_env][`${testScope}${process.env.npm_config_browser.replace('Headless', '')}`];

    return Promise.resolve()
      .then(() => {
        return {username: username, password: 'password', state: 'pool'};
      });
  },

  createUser() {
    const optionsSet = {
      optionsForAccountCreation: {
        method: 'POST',
        url: `${browser.params.accountCreationUrl}/DemoStartForm/Input?sessionKey=${process.env.userCreationSessionKey}&form=testdemo&navigationDirection=Next&`,
        headers: {
          Connection: 'keep-alive',
          'Content-Type': 'application/x-www-form-urlencoded',
          Cookie: `ASP.NET_SessionId=${process.env.userCreationCookie}`
        },
        body: `txtNavigationDirection=Next&aApplicationSourceStaffId=28&aProductCFD=true&aProductSpreadBetting=true&aDemoCurrencyId=6&aDemoCultureId=69&aTitle=4&aFirstName=test&aLastName=test&aMobileNumber=1234567890&aContactEmail=test%40gmail.com&aConfirmEmail=test%40gmail.com&aPassword=password&aConfirmPassword=password&aDemoAggreeDeclaration=true&aDemoAggreePrivacy=true`
      },
      optionsForGettingUserName: {
        method: 'GET',
        url: `${browser.params.accountCreationUrl}/DemoThankYouForm/Input?sessionKey=${process.env.userCreationSessionKey}&formName=DemoThankYou&form=testdemo`,
        headers: {
          Connection: 'keep-alive',
          Cookie: `ASP.NET_SessionId=${process.env.userCreationCookie}`
        }
      },
    };

    return rp(optionsSet.optionsForAccountCreation)
      .then(null, (err) => {
        return rp(optionsSet.optionsForGettingUserName);
      })
      .then((body) => {
        const username = body.match(/DA\d+/)[0];

        return {username: username, password: 'password', state: 'new'};
      }, () => null);
  }

};
