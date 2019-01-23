import { defineSupportCode } from 'cucumber';
import { browser, element, by, ExpectedConditions } from 'protractor';


defineSupportCode(function({Given, When, Then}) {

  When(/^I click on '(.+)' (?:element|button|link) in search modal$/, async function(elementName) {
    await this.basePage.searchModal.click(elementName);
  });

  When(/^I wait for markets loading$/, async function() {
    await this.basePage.searchModal.waitForMarketsLoading();
  });

  When(/^I select '(Market|ProductType)' filter with value '(.+)'$/, async function(filterType, filterValue) {
    await this.basePage.searchModal[`select${filterType}Filter`](filterValue);
  });

  When(/^I switch ([Oo]n|[Oo]ff) 'Include options' toggle$/, async function(state) {
    await this.basePage.searchModal.setIncludeOptions(state);
  });

  When(/^I remember found markets number$/, async function() {
    this.memory.searchMarketsAmount = await this.basePage.searchModal.getMarketsCount();
  });

  When(/^I store markets names from the Search modal$/, async function() {
    this.memory.marketsNames = await this.basePage.searchModal.getAllMarketsTitles();
  });

  When(/^I find opened market from the Search modal$/, async function() {
    this.memory.marketName = null;
    this.memory.marketId = null;
    let marketStatus;
    const marketsIds = await this.basePage.searchModal.getAllMarketsIds();

    for (const marketId of marketsIds) {
      this.lightstreamer.subscribe(marketId);
      marketStatus = parseInt(await this.lightstreamer.addListener('StatusSummary'));

      if (marketStatus === 0) {
        this.memory.marketId = marketId;
        break;
      }
    }

    if (this.memory.marketId === null) {
      console.log('There is no opened market within Search modal');
    } else {
      const marketInfo = await this.backendHelper.getMarketInformation(parseInt(this.memory.marketId));
      this.memory.marketName = marketInfo.Name;
      this.memory.marketPriceDemicals = marketInfo.PriceDecimalPlaces;
    }
  });

  Then(/^Markets in the Search modal should be the same$/, async function() {
    let actualArray;
    const expectedArray = this.memory.marketsNames;
    try {
      await browser.wait(async() => {
        actualArray = await this.basePage.searchModal.getAllMarketsTitles();

        return this.helper.sleepIfFalse(JSON.stringify(actualArray.sort()) === JSON.stringify(expectedArray.sort()), 2000);
      }, 15000);
    } catch (err) {
      console.log('timeout for waiting of similarity');
    }

    this.expect(actualArray.sort()).to.deep.equal(expectedArray.sort());
  });

  When(/^'(Market|ProductType)' filter should (not |)be filled( with option '(.+)'|)$/,
  async function(filterType, state, expectedOption) {
    const actualOption = await this.basePage.searchModal[`get${filterType}FilterOption`]();

    if (state === 'not ') {
      expectedOption = false;
      this.expect(actualOption).to.equal(expectedOption);
    } else {
      this.expect(actualOption.toLowerCase().trim()).to.equal(expectedOption.toLowerCase().trim());
    }
  });

  When(/^'Include options' toggle should be ([Oo]n|[Oo]ff)$/, async function(expectedStatus) {
    expectedStatus = expectedStatus.toLowerCase();
    const actualStatus = await this.basePage.searchModal.getIncludeOptionsToggleStatus();

    this.expect(actualStatus).to.equal(expectedStatus);
  });

  Then(/^'(.+)' message in Search modal should be correct$/, async function(msgName) {
    const messages = {
      'empty result': 'No matches found. Please try again or browse markets.'
    };
    const actualMessage = await this.basePage.searchModal.getResultMessage(msgName);
    const expectedMessage = messages[msgName];

    this.expect(actualMessage).to.equal(expectedMessage);
  });

  Then(/^Search modal should be (visible|not visible)$/, async function(visibility) {
    const expectedState = visibility === 'visible';
    const actualState = await this.basePage.searchModal.isVisible();
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^'(.+)' (is|is not) present in Search modal$/, async function(elementName, status) {
    const actualStatus = await this.basePage.searchModal.isElementPresent(elementName);
    const state = status === 'is';

    this.expect(actualStatus).to.equal(state);
  });

  Then(/^[Ss]earch modal element '(.+)' should be (visible|not visible)$/, async function(elementName, visibility) {
    const expectedState = visibility === 'visible';
    const actualState = await this.basePage.searchModal.isElementVisible(elementName);
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^1-click '(.+)' for all markets on search modal should be displayed according to market status$/,
  async function(field) {
    field = `1-click ${field.toLowerCase()}`;
    const marketsIds = await this.basePage.searchModal.getAllMarketsIds();
    for (let i = 0; i < marketsIds.length; i++) {
      let status;
      if (this.memory[`${marketsIds[i]}Status`]) {
        status = this.memory[`${marketsIds[i]}Status`];
      } else {
        await this.lightstreamer.subscribe(marketsIds[i]);
        status = await this.lightstreamer.addListener('StatusSummary');
        this.memory[`${marketsIds[i]}Status`] = status;
      }

      const market = await this.basePage.searchModal.getMarket(i);
      const actualState = await market.isElementVisible(field);
      // status === '4' for closed markets
      if (status === '4') {
        this.expect(actualState).to.equal(false);
      } else if (status === '0') {
        this.expect(actualState).to.equal(true);
      }
    }
  });

  Then(/^[Ss]earch modal element '(.+)' text should be '(.+)'$/, async function(elementName, expectedText) {
    expectedText = expectedText.toLowerCase();
    const actualElementText = (await this.basePage.searchModal.getElementText(elementName)).toLowerCase();
    this.expect(actualElementText).to.equal(expectedText);
  });

  Then(/^Default displayed markets should be first '(\d+)' from Popular Markets$/, async function(num) {
    const expectedArray = await this.backendHelper.getMarketsParametersByTagId(152, parseInt(num));
    const actualArray = await this.basePage.searchModal.getAllMarketsTitles();
    const expectedNumber = expectedArray.length;
    const actualNumber = actualArray.length;
    this.expect(actualNumber).to.equal(expectedNumber);
    this.expect(actualArray.sort()).to.deep.equal(expectedArray.sort());
  });

  Then(/^markets count should be (more|less|equal) (?:than|to) '(\d+|remembered)'$/, async function(comparator, num) {
    if (num === 'remembered') {
      num = this.memory.searchMarketsAmount;
    }
    num = parseInt(num);
    const actualNumber = await this.basePage.searchModal.getMarketsCount();
    if (comparator === 'equal') {
      this.expect(actualNumber).to.equal(num);
    } else if (comparator === 'more') {
      this.expect(actualNumber).to.be.above(num);
    } else {
      this.expect(actualNumber).to.be.below(num);
    }
  });

  Then(/^all markets should contain '(.+)'$/, async function(values) {
    // values = values.toLowerCase();
    const valuesArr = values.replace(/[ )(]/g, '').split('and');
    const titlesArray = await this.basePage.searchModal.getAllMarketsTitles();
    titlesArray.forEach((title) => {
      valuesArr.forEach((value) => {
        const strArr = value.split('or');
        const arrOfStates = strArr.map((str) => {
          if (str.match(/match\//)) {
            const strForRegexp = str.replace(/match\/(.+)\//, '$1');
            const regexp = new RegExp(strForRegexp);

            return !!title.match(regexp);
          } else {
            return title.replace(/[ )(]/g, '').toLowerCase().includes(str.toLowerCase());
          }
        });
        this.expect(arrOfStates).to.include(true);
      });
    });
  });

  Then(/^search modal dialogue header should be colored in '(black|gray)'$/, async function(color) {
    const expectedColorPart = color === 'black' ? '72, 72, 72' : '238, 238, 238';
    const actualColor = await this.basePage.searchModal.getHeaderBackground();
    this.expect(actualColor).to.include(expectedColorPart);
  });

});
