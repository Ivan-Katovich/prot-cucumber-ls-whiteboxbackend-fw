/* tslint:disable:max-line-length */
import { defineSupportCode } from 'cucumber';
import * as _ from 'lodash';
import { browser, element, by, ExpectedConditions } from 'protractor';
import { BalanceEnum } from '../../../../support/enums/balance.enum';
import { userCreator } from '../../../../support/utils/user-creator';
import { accounts } from '../../../../configs/data/account-pool';
import { helper } from '../../../../support/utils/helper';

defineSupportCode(function({Given, When, Then}) {

  When(/^I (enable|disable) one click trading$/, async function(status) {
    status = status === 'enable' ? true : false;
    await this.basePage.header.setOneClickTrading(status);
  });

  When(/^I click on Search input$/, async function() {
    await this.basePage.header.clickSearch();
  });

  When(/^I click on '(.+)' (header|userMenu|feedbackModal) element$/, async function(elementName, componentName) {
    const url = {
      logOutLink: browser.params.logOutRedirectUrl
    };
    if (elementName.toLowerCase().includes('link')) {
      this.memory[elementName] = url[elementName];
    }
    await this.basePage[componentName].click(elementName);
  });

  When(/^I go to my account (?:page|tab)$/, async function() {
    await this.basePage.userMenu.click('myAccLink');
  });

  When(/^I redirect to '(.+)'$/, async function(to) {
    browser.waitForAngularEnabled(false);
    this.memory.appWindow = await browser.getWindowHandle();
    await this.basePage.feedbackModal.redirect(to);
  });

  When(/^I close current browser tab$/, async function() {
    await browser.close();
    browser.waitForAngularEnabled(true);
  });

  When(/^I switch to '(.+)' browser tab$/, async function(tabNumber) {
    await browser.wait(helper.windowCount(parseInt(tabNumber)), 10000);
    tabNumber = parseInt(tabNumber) - 1;

    await browser.getAllWindowHandles().then((handles) => {
      if (process.env.npm_config_browser === 'safari') {
        tabNumber = handles.indexOf(this.memory.appWindow) === 0 ? tabNumber : handles.length - tabNumber - 1;
      }
      browser.switchTo().window(handles[tabNumber]);
      // browser.waitForAngularEnabled(false);
    });
  });

  When(/^I dismiss alert$/, async function() {
    await browser.switchTo().alert().then(
      (alert) => alert.accept()
    );
  });

  When(/^I close [Ss]earch input$/, async function() {
    await this.basePage.header.clickLogo();
  });

  When(/^I select '([Ww]orkspace|[Bb]rowse)' board$/, async function(boardName) {
    await this.basePage.header.selectBoard(boardName);
  });

  When(/^I fill search field with value '(.+)'$/, async function(value) {
    if (value === 'current market') {
      value = this.memory.marketName;
    }
    await this.basePage.header.addSearchValue(value);
  });

  When(/^I clear search input field$/, async function() {
    await this.basePage.header.clearSearchInput();
  });

  When(/^I (submit|cancel) one click trading message$/, async function(action) {
    if (action === 'submit') {
      action = 'ok';
    }
    await this.basePage.header.closeOneClickTradingMessage(action);
  });

  When(/^I fill feedback text field with value '(.+)'/, async function(value) {
    await this.basePage.feedbackModal.fillInputWithValue(value);
  });

  When(/^I obtain '(.+)' url from kvp/, async function(itemKey) {
    const accountInformation = await this.backendHelper.getClientAndTradingAccount();
    const expectedUrl = itemKey === 'contact us' ?  browser.params.logOutRedirectUrl
     : (await this.backendHelper.getClientApplicationMessageTranslationWithInterestingItems(
      0, // INFO: as in AP app
      accountInformation.CultureId,
      accountInformation.AccountOperatorId,
      [itemKey]
    ))[0].Value.split(',')[0];

    this.memory[itemKey] = expectedUrl;
  });

  When(/^I (re|)login to the application( as '(CFD|Spread|CFD & Spread|)' account|)$/, async function(action, accountType?: string) {
    // const url = await browser.getCurrentUrl();
    if (action === 're') {
      await this.basePage.logOut();
    }
    // this.lightstreamer.disconnectLS();

    /* await browser.wait(() => {
      return browser.getCurrentUrl()
        .then((changedUrl) => this.helper.sleepIfFalse(url !== changedUrl, 500));
    }, 10000); */
    await browser.waitForAngularEnabled(false);
    await browser.get(browser.params.loginUrl);

    if (!accountType) {
      accountType = 'CFD & Spread';
    }
    const users = {
      CFD: {
        login: accounts['specific ppe accounts'].CFD,
        password: 'password'
      },
      Spread: {
        login: accounts['specific ppe accounts'].Spread,
        password: 'password'
      },
      'CFD & Spread': {
        login: browser.params.login,
        password: browser.params.password
      }
    };

    await browser.refresh();
    await browser.waitForAngularEnabled(true);
    await this.loginPage.signIn(users[accountType].login, users[accountType].password);
    await this.helper.alertsReset();
    await this.basePage.waitLoading();
    await this.backendHelper.setSession();
    await this.backendHelper.setAccount();
    // await this.lightstreamer.connectLS();
    if (accountType) {
      await this.backendHelper.resetClientPreferences();
    }
    // await this.basePage.waitLoading();
  });

  When(/^I login as (CFD|Spread|CFD & Spread|default) account to the application$/, async function(accountType) {
    accountType = accountType === 'default' ? 'CFD & Spread' : accountType;
    const users = {
      CFD: {
        login: accounts['specific ppe accounts'].CFD,
        password: 'password'
      },
      Spread: {
        login: accounts['specific ppe accounts'].Spread,
        password: 'password'
      },
      'CFD & Spread': {
        login: browser.params.login,
        password: browser.params.password
      }
    };
    await browser.executeScript('window.sessionStorage.clear();');
    await this.backendHelper.deleteSession();

    await browser.waitForAngularEnabled(false);
    await browser.get(browser.baseUrl);
    await browser.refresh();
    await browser.waitForAngularEnabled(true);

    await this.loginPage.signIn(users[accountType].login, users[accountType].password);
    await this.helper.alertsReset();
    await this.basePage.waitLoading();
    await this.backendHelper.setSession();
    await this.backendHelper.setAccount();
  });

  Then(/^One click trading board should be (ON|OFF)$/, async function(state) {
    const expectedState = state === 'ON';
    const actualState = await this.basePage.header.isOneClickTradingON();
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^'(.+)' color should be (green|grey)$/, async function(elementName, color) {
    const expectedColorPart = color === 'green' ? '79, 180, 107' : '125, 126, 126';
    const actualColor = await this.basePage.header.getBackgroundColor(elementName);
    this.expect(actualColor).to.include(expectedColorPart);
  });

  When(/^I click on '(.+)' button in Search header$/, async function(name) {
    name = `${name.toLowerCase()} button`;
    await this.basePage.header.click(name);
  });

  Then(/^icon in Search header is '(.+)' button$/, async function(name) {
    name = `${name.toLowerCase()} button`;
    const actualState = await this.basePage.header.isElementPresent(name);

    this.expect(actualState).to.equal(true);
  });

  Then(/^balance bar displays items in the correct order:$/, async function(table) {
    const itemNames = table.raw().map((el) => {
      return el[0];
    });

    let actualItem = await this.basePage.balanceBar.getElementText('root');
    actualItem = actualItem.replace(/[0-9]|[,]|[.]|[-]|[>]|[%]|\ss+/g, '').split('\n').map(t => t.trim()).filter(t => t);
    if (process.env.npm_config_browser === 'safari') {
      actualItem = actualItem[0].replace(/\s{2,}/g, '  ').split('  ');
    }

    for (let i = 0; i < itemNames.length; i++) {
      this.expect(actualItem[i]).to.contain(itemNames[i]);
    }
  });

  Then(/^'(.+)' is displayed on balance bar with correct text and value(| updated)$/, async function(itemName, isUpdated) {
    const self = this;
    let expectedPattern = new RegExp(`\\d*\\,?\\d*\\.?\\d* ${itemName}`);
    let actualPattern;
    let expectedValue;
    let actualValue;
    let errorMultiplier = 0.01; // common 1%

    await browser.wait(() => {
      const promiseArr = [];
      if ((itemName.toLowerCase() === 'unrealised p&l' || itemName.toLowerCase() === 'total margin') && isUpdated.trim() === 'updated') {
        const dataNumber = {
          'unrealised p&l': '11',
          'total margin': '4'
        };
        if (itemName.toLowerCase() === 'unrealised p&l') {
          errorMultiplier = 0.1; // special for unrealised p&l - 10 %
        }
        this.lightstreamer.subscribeMargin();
        promiseArr.push(this.lightstreamer.addMarginListener(dataNumber[itemName.toLowerCase()])
          .then((marginItem) => {
            expectedValue = marginItem;
        }));
      } else if ((itemName === 'Available to trade' || itemName === 'Margin Indicator') && isUpdated.trim() === 'updated') {
        this.lightstreamer.subscribeMargin();
        let totalMargin;
        let newEquity;
        promiseArr.push(this.lightstreamer.addMarginListener('4')
          .then((marginItem) => {
            totalMargin = marginItem;
            if (itemName === 'Available to trade') {
              expectedValue = (newEquity - totalMargin).toLocaleString(undefined, {minimumFractionDigits: 2});
            } else {
              expectedValue = Math.round(newEquity / totalMargin * 100).toLocaleString();
              expectedPattern = new RegExp(`\\d*\\,?\\d*\\.?\\d*% ${itemName}`);
            }
          }));
        promiseArr.push(self.backendHelper.getMarginInfo()
          .then((balanceInformation) => {
            newEquity = balanceInformation[BalanceEnum['Net Equity']];
          }));
      } else {
        promiseArr.push(self.backendHelper.getMarginInfo()
          .then((balanceInformation) => {
            const expectedNumber = balanceInformation[BalanceEnum[itemName]];
            expectedValue = expectedNumber.toLocaleString(undefined, {minimumFractionDigits: 2});
            if (itemName.toLowerCase() === 'cash' || itemName.toLowerCase() === 'unrealised p&l') {
              const expectedCurrency = balanceInformation.CurrencyIsoCode;
              expectedPattern = new RegExp(`\\d*\\,?\\d*\\.?\\d* ${itemName} \\(${expectedCurrency}\\)`);
            } else if (itemName.toLowerCase() === 'margin indicator') {
              if (expectedNumber === -1) {
                expectedValue = String(200);
                expectedPattern = new RegExp(`> \\d*\\,?\\d*\\.?\\d*% ${itemName}`);
              } else {
                expectedValue = Math.round(expectedNumber).toLocaleString();
                expectedPattern = new RegExp(`\\d*\\,?\\d*\\.?\\d*% ${itemName}`);
              }
            }
          }));
      }
      promiseArr.push(self.basePage.balanceBar.getElementItemValue(itemName.toLowerCase())
        .then((value) =>  {
        actualValue = value.replace('>', ' ').replace('%', ' ').trim();
        }));

      promiseArr.push(self.basePage.balanceBar.getElementText(itemName.toLowerCase())
        .then((av) =>  {
          actualPattern = av.replace(/\n/g, ' ').replace(/\s{2,}/g, ' ').trim();
        }));

      return Promise.all(promiseArr)
        .then(() => actualValue === expectedValue);
    }, 100000)
      .then(() => null, () => null);

    actualValue = parseFloat(actualValue.replace(/\,/g, ''));
    expectedValue = parseFloat(expectedValue.replace(/\,/g, ''));
    const validError = Math.abs(expectedValue) * errorMultiplier;

    console.log(`${actualValue} should be within ${_.round(expectedValue - validError, 2)} - ${_.round(expectedValue + validError, 2)}`);
    this.expect(actualValue).to.be.within(_.round(expectedValue - validError, 2), _.round(expectedValue + validError, 2));
    this.expect(actualPattern).to.match(expectedPattern);
  });

  Then(/^'([Ww]orkspace|[Bb]rowse)' board should be (active|not active)$/, async function(boardName, activeState) {
    const expectedState = activeState === 'active';
    const actualState = await this.basePage.header.isBoardActive(boardName);
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^link redirects to the correct '(.+)' url$/, async function(redirectUrl) {
    let expectedUrl = this.memory[redirectUrl];
    let actualUrl: string;
    if (redirectUrl === 'AP_Online_Chat_URL') {
      await browser.get(expectedUrl);
      const checkUrl = await browser.getCurrentUrl();
      expectedUrl = checkUrl.slice(0, 156);
    }

    actualUrl = await browser.getCurrentUrl();
    if (!actualUrl.includes(expectedUrl)) {
      await browser.wait(async() => {
        actualUrl = await browser.getCurrentUrl();

        return actualUrl.includes(expectedUrl);
      }, 10000)
        .then(() => null, () => console.log('Wait timed out after 10000ms'));
    }

    this.expect(actualUrl).to.include(expectedUrl);
  });

  Then(/^[Aa]ccount board should be (active|not active)$/, async function(activeState) {
    this.memory.clientInfo = await this.backendHelper.getClientAndTradingAccount();
    const expectedState = activeState === 'active';
    // await this.basePage.waitLoading();
    const actualState = await this.basePage.userMenu.isAccountActive();
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^the '(header|userMenu|feedbackModal)' should contain items:$/, async function(componentName, table) {
    const itemNames = table.hashes().map((el) => {
      return el.itemName;
    });

    for (let i = 0; i < itemNames.length; i++) {
      const actualState = await this.basePage[componentName].isElementPresent(itemNames[i]);
      this.expect(actualState).to.equal(true);
    }
  });

  Then(/^the submit button should be (enabled|disabled)$/, async function(isEnable) {
    const expectedCondition = isEnable === 'enabled';
    const actualCondition = await this.basePage.feedbackModal.isSubmitActive();
    this.expect(actualCondition).to.equal(expectedCondition);
  });

  Then(/^the search text input '(placeholder|value)' should be '(.+)'$/, async function(textType, expectedText) {
    const actualText = await this.basePage.header.getSearchText(textType);

    this.expect(actualText).to.equal(expectedText);
  });

  Then(/^'(.+)' tab should be (below|to the right of|to the left of) '(.+)'( tab|)$/, async function(tabElement, location, elemToCompare, isTab) {
    const tab = await this.basePage.currentBoard.header.getTab(tabElement).getLocation();
    const elementToCompare = isTab
      ? await this.basePage.currentBoard.header.getTab(elemToCompare).getLocation()
      : await this.basePage.header.getElementLocation(elemToCompare);

    if (location === 'below') {
      this.expect(tab.y).to.be.above(elementToCompare.y);
    } else if (location === 'to the right of') {
      this.expect(tab.x).to.be.above(elementToCompare.x);
    } else {
      this.expect(tab.x).to.be.below(elementToCompare.x);
    }
  });

  Then(/^'(.+)'( tab| section|) default (width|height) should be '(.+)' px$/, async function(elementName, elementType, size, expectedValue) {
    size = size.trim().toLowerCase();
    if (elementName === 'current market product') {
      elementName = this.memory.marketName;
    }
    let actualValue;
    if (elementType.includes('tab')) {
      actualValue = await this.basePage.currentBoard.header.getTab(elementName).getSize();
    } else if (elementType.includes('section')) {
      actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getSize();
    } else if (elementName.includes('search input')) {
      actualValue = await this.basePage.header.getSize('searchDiv');
    }
    this.expect(actualValue[size]).to.equal(parseInt(expectedValue));
  });

  Then(/^'(.+)' feedback link should lead us to '(.+)'$/, async function(linkName, expectedLink) {
    const actualLink = await this.basePage.feedbackModal.getElementHref(linkName);
    this.expect(actualLink).to.equal(expectedLink);
  });

  Then(/^'(.+)' element in feedback modal dialogue should contain text '(.+)'$/, async function(elementName, expectedText) {
    const actualText = await this.basePage.feedbackModal.getElementText(elementName);
    this.expect(actualText).to.equal(expectedText);
  });

  Then(/^'(.+)' element in (header|feedbackModal) should be (visible|invisible)$/, async function(elementName, componentName, visibility) {
    const expectedState = visibility === 'visible';
    const actualState = await this.basePage[componentName].isElementPresent(elementName);
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^application version from UI should be correct$/, async function() {
    if (process.env.npm_config_appVersion) {
      const versionInfoArr = String(process.env.npm_config_appVersion).split('.');

      versionInfoArr[0] = versionInfoArr[0] ? versionInfoArr[0] : '.*';
      versionInfoArr[1] = versionInfoArr[1] ? versionInfoArr[1] : '.*';
      versionInfoArr[2] = versionInfoArr[2] ? versionInfoArr[2] : '.*';

      const expectedVersionPattern =   new RegExp(`^${versionInfoArr[0]}\.${versionInfoArr[1]}\.${versionInfoArr[2]}\.[a-z|\\d]{7,10}`);
      const actualVersion = await this.basePage.getVersion();
      this.expect(actualVersion).to.match(expectedVersionPattern);
    }
  });
});
