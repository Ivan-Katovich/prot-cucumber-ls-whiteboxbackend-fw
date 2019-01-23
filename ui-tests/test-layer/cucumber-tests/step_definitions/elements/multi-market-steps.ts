/* tslint:disable:max-line-length */
import { defineSupportCode } from 'cucumber';
import { browser } from 'protractor';


defineSupportCode(function({Given, When, Then}) {

  When(/^I (expand|collapse) '(.+)'(?:st|th|nd|rd|) multi-market$/, async function(action, marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
    } else {
      this.memory.marketName = marketNameOrNumber;
    }
    await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber)[action]();
  });

  When(/^I hover '(.+)'(?:st|th|nd|rd|) multi-market's '(.+)'(?:st|th|nd|rd|) sub-market$/, async function(market, subMarket) {
    market = parseInt(market) - 1;
    subMarket = parseInt(subMarket) - 1;
    await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(market).getSubMarket(subMarket).hover();
  });

  When(/^I (click on|scroll to) '(.+)' in the '(.+)'(?:st|th|nd|rd|) multi-market's '(.+)'(?:st|th|nd|rd|) sub-market$/,
    async function(action, point, market, subMarket) {
      if (market.toLowerCase() === 'previously added' || market.toLowerCase() === 'current') {
        market = this.memory.marketName;
      } else {
        market = parseInt(market) - 1;
      }
    subMarket = parseInt(subMarket) - 1;
    if (action === 'click on') {
      await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(market).getSubMarket(subMarket).click(point);
    } else if (action === 'scroll to') {
      await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(market).getSubMarket(subMarket).scrollTo();
    }
  });
/*
  Didn't find where this step is used
  When(/^I select '(.+)' in dropdown menu in the '(.+)'(?:st|th|nd|rd|) multi-market's '(.+)'(?:st|th|nd|rd|) sub-market$/, async function(option, market, subMarket) {
    market = parseInt(market) - 1;
    subMarket = parseInt(subMarket) - 1;
    await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(market).getSubMarket(subMarket).selectDropdownOption(option);
  });
*/
  Then(/^the '(.+)'(?:st|th|nd|rd|) market's sub-markets count should be '(.+)'$/, async function(marketNameOrNumber, expectedCount) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    expectedCount = expectedCount * 1;
    const actualCount = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarketsCount();
    this.expect(actualCount).to.equal(expectedCount);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) multi-market opening price should be average for opening prices of sub-markets$/, async function(marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    let price = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('opening price');
    price = price.replace(/\,/g, '');
    const position = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('position');
    const submarketPrices = await this.backendHelper.getBackendMultiDataByName(this.memory.marketName, 'Price', true);
    const submarketQuantities = await await this.backendHelper.getBackendMultiDataByName(this.memory.marketName, 'Quantity', true);
    const actualPrice = parseFloat((price * 1).toPrecision(6));
    let generalQuantity;
    if (process.env.npm_config_browser === 'safari') {
      generalQuantity = position.split('  ')[1].trim().replace(/\,/g, '') * 1;
    } else {
      generalQuantity = position.split('\n')[1].trim().replace(/\,/g, '') * 1;
    }
    const totalSum = submarketPrices.reduce((sum, el, i) => {
      return sum + el * submarketQuantities[i];
    }, 0);
    const expectedPrice = parseFloat((totalSum / generalQuantity).toPrecision(6));
    this.expect(actualPrice).to.be.below(expectedPrice * 1.00002);
    this.expect(actualPrice).to.be.above(expectedPrice * 0.99998);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) market's '(\d+)'(?:st|th|nd|rd|) sub-market should be black when it is hovered and other sub-markets should be white$/, async function(marketNameOrNumber, subMarketNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const expectedTargetColor = '26, 26, 26';
    const expectedOtherColor = '255, 255, 255';
    await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarket(subMarketNumber).hover();
    const actualTargetColor = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarket(subMarketNumber).getSubItemRowColor();
    this.expect(actualTargetColor).to.include(expectedTargetColor);
    const subMarketsCount = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarketsCount();
    const promises = [];
    for (let iterator = 0; iterator < subMarketsCount; iterator += 1) {
      if (iterator !== subMarketNumber) {
        promises.push(this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarket(iterator).getSubItemRowColor()
          .then((actualOtherColor) => {
            this.expect(actualOtherColor).to.include(expectedOtherColor);
          }));
      }
    }
    await Promise.all(promises);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) multi-market should be '(expanded|collapsed)'$/, async function(marketNameOrNumber, state) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const expectedState = state === 'expanded';
    let actualState: boolean;
    /* await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).isExpanded()
        .then((is) => {
          actualState = is;

          return this.helper.sleepIfFalse(actualState === expectedState);
        });
    }, 3000)
      .then(() => null, () => null); */
    actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).isExpanded();

    this.expect(actualState).to.equal(expectedState);
  });

});
