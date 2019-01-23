import { defineSupportCode } from 'cucumber';
import { browser } from 'protractor';


defineSupportCode(function({ Given, When, Then }) {
  When(/^I am on the '(.+)'$/, async function(noPanelComponent) {
    await this.basePage.currentBoard.tabBody.getNoPanelComponent(noPanelComponent);
  });

  When(/^I switch to '(.+)'$/, async function(noPanelComponent) {
    noPanelComponent = noPanelComponent.toLowerCase();
    if (noPanelComponent === 'economic calendar') {
      await this.basePage.currentBoard.tabBody.getNoPanelComponent(noPanelComponent).switchToEconomicCalendar();
    }
  });

  When(/^I click on (dropdown arrow|more icon|) in product page$/, async function(elementName) {
    await this.basePage.currentBoard.tabBody.currentPanel.clickOnElement(elementName);
  });

  When(/^I switch on the market on the '(.+)'(?:st|th|nd|rd) position$/, async function(positionNumber) {
    if (process.env.npm_config_browser.includes('safari')) {
      await this.basePage.currentBoard.tabBody.currentPanel.getMarket(parseInt(positionNumber) - 1).clickMarketContainerElement();
    } else {
      await this.basePage.currentBoard.tabBody.currentPanel.getMarket(parseInt(positionNumber) - 1).click('name');
    }
    this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.getNameMarket(parseInt(positionNumber) - 1);
    this.memory.marketId = this.idMatcher.market[this.memory.marketName];
  });

  When(/^I switch on '(.+)'(?:st|th|nd|rd) market from markets dropdown in product page$/, async function(positionNumber) {
    this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel
      .getNameMarket(parseInt(positionNumber) - 1, 'within markets dropdown');
    await this.basePage.currentBoard.tabBody.currentPanel.selectMarketFromDropdown(parseInt(positionNumber) - 1);
  });

  When(/^I switch to '(.+)' watchlist within dropdown list in product page$/, async function(watchlistName) {
    this.memory.currentWatchlist = watchlistName;
    await this.basePage.currentBoard.tabBody.currentPanel.switchToWatchlist(watchlistName);
  });

  Then(/^'(.+)'(?:st|th|nd|rd|) market inside market container should (be|be not) hightlighted$/,
    async function(marketNameOrNumber, isHightlighted) {
    if (marketNameOrNumber === 'selected') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }

    let expectedColor;
    if (isHightlighted.includes('not')) {
      if (process.env.npm_config_browser === 'edge') {
        expectedColor = 'transparent';
      } else {
        expectedColor = '0, 0, 0';
      }
    } else {
      expectedColor = '72, 72, 72';
    }

    const actualColor = await this.basePage.currentBoard.tabBody.currentPanel.getMarket(marketNameOrNumber).getSubItemRowColor();
    this.expect(actualColor).to.include(expectedColor);
  });

  Then(/^the '(.+)' should be (visible|invisible) in product page$/, async function(element, visibility) {
    const expectedResult = visibility.toLowerCase() === 'visible';

    const actualResult = await this.basePage.currentBoard.tabBody.currentPanel.isElementPresent(element);

    this.expect(expectedResult).to.equal(actualResult);
  });

  Then(/^the correct market display to the right '(.+)'(?:st|th|nd|rd|) position$/, async function(positionNumber) {
    if (positionNumber === 'last') {
      positionNumber = (await this.basePage.currentBoard.tabBody.currentPanel.getAllMarketsNames()).length;
    }
    const actualMarketName = await this.basePage.currentBoard.tabBody.currentPanel.getNameMarket(parseInt(positionNumber) - 1);

    this.expect(this.memory.marketName).to.equal(actualMarketName);
  });

  Then(/^the correct market display in market information$/, async function() {
    const actualMarketName = await this.basePage.currentBoard.tabBody.currentPanel.getMarketName();

    this.expect(this.memory.marketName).to.equal(actualMarketName);

    await browser.switchTo().defaultContent();
  });

  Then(/^existed watchlists displayed in correct order within watchlist (dropdown body|) in product page$/, async function(elementsName) {
    const actualList = await this.basePage.currentBoard.tabBody.currentPanel.getWatchlistDropdownOptions();

    const sortedWatchlists = this.memory.allWatchlists.filter(item => item !== this.memory.currentWatchlist).sort();
    const expectedList = [this.memory.currentWatchlist, ...sortedWatchlists];
    this.expect(actualList.map(t => t.trim())).to.deep.equal(expectedList);
  });

  Then(/^all markets from selected watchlist are displayed in market container$/, async function() {
    const actualList = await this.basePage.currentBoard.tabBody.currentPanel.getAllMarketsNames();
    this.expect(actualList).to.deep.equal(this.memory.allMarketsInCurrentWatchlist);
  });

  Then(/^part of markets from '(.+)' watchlist is displayed in market container$/, async function(watchlistName) {
    let allWatchlistMarkets;
    if (watchlistName === 'Popular Markets') {
      allWatchlistMarkets = await this.backendHelper.getMarketsNamesByQuery(152, 50, '', true, true, true);
    }
    const group = await this.basePage.currentBoard.tabBody.browse.groupByWeighting(allWatchlistMarkets);
    const keys = Object.keys(group);
    const sortedGroup = [];
    for (let i = keys.length - 1; i >= 0; i--) {
      const b = await this.basePage.currentBoard.tabBody.browse.sortByName(group[keys[i]]);
      sortedGroup.push(b);
    }

    allWatchlistMarkets = sortedGroup.reduce(
      (accumulator, currentValue) => {
        return accumulator.concat(currentValue);
      },
      []
    );
    this.memory.popularMarkets = allWatchlistMarkets;
    let actualList = await this.basePage.currentBoard.tabBody.currentPanel.getAllMarketsNames();
    actualList = actualList.map((value) => value.toLowerCase());
    this.memory.hiddenPopularMarkets = allWatchlistMarkets.slice(actualList.length);
    this.memory.lastVisibleMarket = actualList[actualList.length - 1];
    this.expect(allWatchlistMarkets.some((value) => actualList.includes(value))).to.equal(true);
  });

  Then(/^the markets dropdown contains all the markets from selected watchlist that don't fit product page$/, async function() {
    let actualList = await this.basePage.currentBoard.tabBody.currentPanel.getAllMarketsNames('within markets dropdown');
    actualList = actualList.map((value) => value.toLowerCase());
    this.expect(actualList).to.deep.equal(this.memory.hiddenPopularMarkets);
  });

  Then(/^markets dropdown contains previous market from the last position of Market container$/, async function() {
    let actualList = await this.basePage.currentBoard.tabBody.currentPanel.getAllMarketsNames('within markets dropdown');
    actualList = actualList.map((value) => value.toLowerCase());
    this.expect(actualList.includes(this.memory.lastVisibleMarket)).to.equal(true);
  });

  Then(/^'(.+)' section should be (at the left side of|to the left of|to the right of) '(.+)'( section| page)$/,
    async function(sectionName, location, elemToCompareName, elemToCompareType) {
      const sectionElement = await this.basePage.currentBoard.tabBody.getElementLocation(sectionName);
      let elementToCompare;
      if (elemToCompareType.includes('section')) {
        elementToCompare = await this.basePage.currentBoard.tabBody.getElementLocation(elemToCompareName);
      } else {
        elementToCompare = {x: 0, y: 0};
      }

      if (location === 'at the left side') {
        this.expect(sectionElement.x).to.equal(0);
      } else if (location === 'to the left of') {
        this.expect(sectionElement.x).to.be.above(elementToCompare.x);
      } else {
        this.expect(sectionElement.x).to.be.below(elementToCompare.x);
      }
  });
});
