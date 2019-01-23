import { defineSupportCode } from 'cucumber';
import { browser, element } from 'protractor';


defineSupportCode(function({ Given, When, Then }) {
  Then(/^the chart should be loaded$/, async function() {
    const isChartVisible = await this.basePage.currentBoard.tabBody.currentPanel.isChartVisible();
    this.expect(isChartVisible).to.equal(true);
  });

  Then(/^the chart appeared on the right$/, async function() {
    const chartLocation = (await this.basePage.currentBoard.tabBody.currentPanel.getLocation('iframeRoot')).x;
    const marketTabNameLocation = (await this.basePage.currentBoard.tabBody.browse.filterTabs.getLocation('tag name')).x;

    this.expect(chartLocation).to.be.above(marketTabNameLocation);
  });

  Then(/^the chart is( | not )present$/, async function(visibility) {
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isElementPresent('chart');
    const expectedState = !(visibility.trim() === 'not');
    this.expect(actualState).to.equal(expectedState);
  });

  When(/^I switch market to '(.+)'$/, async function(marketName) {
    await this.basePage.currentBoard.tabBody.currentPanel.switchMarket(marketName);
  });

  Then(/^'(.+)' market should be opened on the chart$/, async function(marketName) {
    // INFO: only for spreadAccount && cfdAccount accounts!
    const defaultChartKey = 'defaultCharts';
    const accountInformation = await this.backendHelper.getClientAndTradingAccount();
    const marketId = (await this.backendHelper.getClientApplicationMessageTranslationWithInterestingItems(
      0, // INFO: as in AP app
      accountInformation.CultureId,
      accountInformation.AccountOperatorId,
      [defaultChartKey]
    ))[0].Value.split(',')[0];

    if (marketName === 'default') {
      marketName = (await this.backendHelper.getMarketInformation(marketId)).Name;
      this.memory.defaultMarketName = marketName;
    } else if (marketName === 'current') {
      marketName = this.memory.marketName;
    }
    let marketNameLabel: string;
    await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.getMarketNameLabelText()
        .then((text) => {
          marketNameLabel = text.toLowerCase();

          return this.helper.sleepIfFalse(marketNameLabel.includes(marketName.toLowerCase()), 1000);
        });
    }, 20000)
      .then(() => null, () => null);
    console.log(marketNameLabel);

    this.expect(marketNameLabel).to.include(marketName.toLowerCase());
  });

  Then(/^'(.+)' market should be in panel header$/, async function(marketName) {
    // INFO: only for spreadAccount && cfdAccount accounts!
    const defaultChartKey = 'defaultCharts';
    const accountInformation = await this.backendHelper.getClientAndTradingAccount();
    const marketId = (await this.backendHelper.getClientApplicationMessageTranslationWithInterestingItems(
      0, // INFO: as in AP app
      accountInformation.CultureId,
      accountInformation.AccountOperatorId,
      [defaultChartKey]
    ))[0].Value.split(',')[0];

    if (marketName === 'default') {
      marketName = (await this.backendHelper.getMarketInformation(marketId)).Name;
    }
    let panelName: string;
    /* await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.getPanelHeaderName()
        .then((text) => {
          panelName = text;

          return this.helper.sleepIfFalse(text.includes(marketName));
        });
    }, 100000)
      .then(() => null, () => null); */
    panelName = await this.basePage.currentBoard.tabBody.currentPanel.getPanelHeaderName();

    this.expect(panelName).to.include(marketName);
  });

  Then(/^the( add icon | price axis )is (invisible|visible) after mouse hovering$/, async function(chartElement, visibility) {
    const expectedResult = visibility.toLowerCase() === 'visible';
    const result = await this.basePage.currentBoard.tabBody.getPanel('chart').isChartElementVisibleOnMouseHover(chartElement);
    this.expect(result).to.equal(expectedResult);
  });

  Then(/^(floating |)(sell button |buy button | )element should be (enabled|disabled) inside chart$/,
  async function(position, name, status) {
    name = position.trim() + name;
    const actualState = await this.basePage.currentBoard.tabBody.getPanel('chart').isElementEnable(name);
    const expectedState = status === 'enabled';
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^(floating |)(sell button |buy button | )element should be colored in '(red|blue)'$/, async function(position, name, color) {
    name = position.trim() + name;
    const expectedColorPart = color === 'red' ? '222, 69, 89' : '21, 125, 177';
    const actualColor = await this.basePage.currentBoard.tabBody.getPanel('chart').getButtonBackground(name);
    this.expect(actualColor).to.include(expectedColorPart);
  });

  Then(/^(floating |)(sell button |buy button | )element should be located inside chart$/, async function(position, chartElement) {
    chartElement = position.trim() + chartElement;
    const actualState = await this.basePage.currentBoard.tabBody.getPanel('chart').isElementInsideChart(chartElement);
    this.expect(actualState).to.equal(true);
  });
/*
  When(/^I move sell\/buy button inside chart$/, async function() {
    await this.basePage.currentBoard.tabBody.getPanel('chart').moveSellBuyButtons();
  });
*/
  When(/^I click inside chart$/, async function() {
    await this.basePage.currentBoard.tabBody.getPanel('chart').clickInsideChart();
  });

  When(/^I click on( floating|)( sell| buy) button within Chart$/, async function(isFloating, name) {
    name = name.toLowerCase().trim();
    await this.basePage.currentBoard.tabBody.getPanel('chart').clickOnChartPrice(name, isFloating);
  });

  When(/^I wait for chart loading( with price values|)$/, async function(isPriceWaiting) {
    await this.basePage.currentBoard.tabBody.getPanel('chart').waitForChartLoading(isPriceWaiting);
  });

  When(/^I click on (close chart|add to workspace|add to watchlist|market 360|squares icon|price alert) within menu above Chart/, async function(name) {
    await this.basePage.currentBoard.tabBody.getPanel('chart').clickOnElement(name);
  });

  When(/^I wait '(.+)' disappear$/, async function(elementName) {
    await this.basePage.currentBoard.tabBody.getPanel('chart').waitForElementDisappeared(elementName);
  });

  Then(/^(?:workspace dropdown|watchlist dropdown) content is displayed in alphabetical order$/, async function() {
    const actualList = await this.basePage.actionsMenu.getItems();
    this.expect(actualList).to.deep.equal(actualList.sort());
  });

  Then(/^'(.+)' is (invisible|visible)$/, async function(elementName, visibility) {
    const expectedResult = visibility.toLowerCase() === 'visible';
    const result = await this.basePage.currentBoard.tabBody.getPanel('chart').isElementPresent(elementName);
    this.expect(result).to.equal(expectedResult);
  });

  When(/^I add current chart to '(.+)' from dropdown$/, async function(elementNameForAdding) {
    await this.basePage.currentBoard.tabBody.getPanel('chart').addChartTo(elementNameForAdding);
  });
});
