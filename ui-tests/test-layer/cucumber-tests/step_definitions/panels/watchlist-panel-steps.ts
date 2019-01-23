/* tslint:disable:max-line-length */
import { defineSupportCode } from 'cucumber';
import { element, by, ElementFinder, protractor, browser } from 'protractor';


defineSupportCode(function({ Given, When, Then }) {

  When(/^I (expand|collapse) '(.+)'(?:st|th|nd|rd|) watchlist$/, async function(action, watchlist) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      if (parseInt(watchlist)) {
        watchlist = watchlist - 1;
      }
      await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlist)[action]();
    }
  });

  When(/^I remember '(.+)' market position$/, async function(marketName) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      if (!this.memory.marketPosition) {
        this.memory.marketPosition = {};
      }
      this.memory.marketPosition[marketName] = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarketPosition(marketName, 0);
    }
  });

  When(/^I remember markets in '(.+)' watchlist$/, async function(watchlistName) {
    this.memory.currentWatchlist = watchlistName;
    this.memory.allMarketsInCurrentWatchlist = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).getAllMarketsTitles();
  });

  When(/^I remember all existed watchlists$/, async function() {
    this.memory.allWatchlists = await this.basePage.currentBoard.tabBody.currentPanel.getWatchlistsNames();
  });

  When(/^I create '(.+)' watchlist(| without submitting action)$/, async function(watchlistName, isToBeCompleted) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      await this.basePage.currentBoard.tabBody.currentPanel.createNewWatchlist();
      const completionAction = isToBeCompleted.includes('without submitting action') ? 'do not complete' : 'key enter';
      await this.basePage.currentBoard.tabBody.currentPanel.getList(0).putName(watchlistName, completionAction);
    }
  });

  When(/^I add '(.+)' market in '(.+)' watchlist$/, async function(marketName, watchlistName) {
    await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).addMarket(marketName);
  });

  When(/^I delete '(.+)'(?:st|th|nd|rd|) watchlist$/, async function(watchlistNameOrNumber) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      if (parseInt(watchlistNameOrNumber)) {
        watchlistNameOrNumber = watchlistNameOrNumber - 1;
      }
      await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameOrNumber).deleteWatchlist();
    }
  });

  When(/^the '(.+)' watchlist is dragged and dropped on the '(.+)' watchlist$/, async function(dragAndDropWatchlist, destinationWatchlist) {
    const elem = await this.basePage.currentBoard.tabBody.currentPanel.getList(dragAndDropWatchlist).getHead();
    const target = await this.basePage.currentBoard.tabBody.currentPanel.getList(destinationWatchlist).getHead();

    await this.basePage.currentBoard.tabBody.currentPanel.dragAndDrop(elem, target);
  });

  When(/^I hover mouse on '(.+)'(?:st|th|nd|rd|) watchlist$/, async function(nameOrNum) {
    if (parseInt(nameOrNum)) {
      nameOrNum = nameOrNum - 1;
    }
    await this.basePage.currentBoard.tabBody.currentPanel.getList(nameOrNum).hover();
  });

  When(/^I change the name of '(.+)'(?:st|th|nd|rd|) watchlist to '(.*)' through '(.+)'$/, async function(nameOrNum, newName, actionToCompleteEdit) {
    if (parseInt(nameOrNum)) {
      nameOrNum = nameOrNum - 1;
    }
    await this.basePage.currentBoard.tabBody.currentPanel.getList(nameOrNum).editName(newName, actionToCompleteEdit);
  });

  When(/^I start to edit '(.+)'(?:st|th|nd|rd) watchlist$/, async function(watchlistNumber) {
    await this.basePage.currentBoard.tabBody.currentPanel.getList(parseInt(watchlistNumber) - 1).startEditingName();
  });

  When(/^I end to edit '(.+)'(?:st|th|nd|rd) watchlist$/, async function(watchlistNumber) {
    await this.basePage.currentBoard.tabBody.currentPanel.getList(parseInt(watchlistNumber) - 1).endEditingName();
  });

  When(/^I undo '(.+)'(?:st|th|nd|rd) watchlist removal$/, async function(watchlistNumber) {
    await this.basePage.currentBoard.tabBody.currentPanel.getList(parseInt(watchlistNumber) - 1).undoDeleting();
  });

  When(/^I type '(.+)' name of market(?: in '(.+)'(?:st|th|nd|rd|) watchlist|)$/, async function(searchText, watchlistNameOrNumber) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      if (searchText === 'closed' || searchText === 'phone only') {
        searchText = this.memory[searchText];
      }
      const isWait = searchText.length > 2;
      if (watchlistNameOrNumber) {
        if (parseInt(watchlistNameOrNumber)) {
          watchlistNameOrNumber = watchlistNameOrNumber - 1;
        }
        await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameOrNumber).typeNameOfMarket(searchText, isWait);
      } else {
        await this.basePage.currentBoard.tabBody.currentPanel.currentList.typeNameOfMarket(searchText, isWait);
      }
    }
  });

  When(/^I add '(.+)'(?:st|th|nd|rd) market from market dropdown$/, async function(marketNumber) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarketFromDropdown(parseInt(marketNumber) - 1);
      await this.basePage.currentBoard.tabBody.currentPanel.currentList.addMarketFromDropdown(parseInt(marketNumber) - 1);
      this.memory.marketId = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getLastAddedMarketId(parseInt(marketNumber) - 1);
    }
  });

  When(/^I drag and drop '(.+)'(?:st|th|nd|rd|) market from '(.+)' watchlist to '(|.+)'(?:|st|th|nd|rd|) (?:market |)(?:in|of) the '(.+)' watchlist$/,
    async function(dragAndDropMarket, watchlistNameOfDragAndDropMarket, destinationMarket, watchlistNameofDestinationMarket) {
      if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
        if (parseInt(dragAndDropMarket)) {
          dragAndDropMarket = dragAndDropMarket - 1;
        }
        if (parseInt(destinationMarket)) {
          destinationMarket = destinationMarket - 1;
        }

        this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameOfDragAndDropMarket)
          .getMarket(dragAndDropMarket).getName(false);

        const elem = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameOfDragAndDropMarket)
          .getMarket(dragAndDropMarket).getMarketElement();

        let target;
        if (destinationMarket === 'root') {
          target = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameofDestinationMarket).getListElement();
        } else if (destinationMarket === 'outside') {
          target = await this.basePage.header.logo;
        } else {
          target = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameofDestinationMarket).getMarket(destinationMarket).getMarketElement();
        }
        await this.basePage.currentBoard.tabBody.currentPanel.dragAndDrop(elem, target);
      }
  });

  When(/^I drag '(.+)' watchlist and drop to '(.+)' watchlist$/, async function(baseWatchlist, targetWatchlist) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      const elem = await this.basePage.currentBoard.tabBody.currentPanel.getList(baseWatchlist).getListElement();
      const target = await this.basePage.currentBoard.tabBody.currentPanel.getList(targetWatchlist).getListElement();

      await this.basePage.currentBoard.tabBody.currentPanel.dragAndDrop(elem, target);
    }
  });

  Then(/^'(.+)' watchlist should be (expanded|collapsed)$/, async function(watchlistNameOrNumber, state) {
    if (parseInt(watchlistNameOrNumber)) {
      watchlistNameOrNumber = watchlistNameOrNumber - 1;
    }
    const expectedState = state === 'expanded';
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameOrNumber).isExpanded();
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^watchlist panel table header should contain:$/, async function(table) {
    const expectedArray = table.hashes().map((el) => {
      return el.columnName.toLowerCase();
    });
    const columnNamesFromUi = await this.basePage.currentBoard.tabBody.currentPanel.tabHeader.getColumnsNames();
    const actualArray = columnNamesFromUi.map((el) => {
      return el.toLowerCase();
    });
    this.expect(actualArray).to.deep.equal(expectedArray);
  });

  Then(/^the '(.+)' watchlist should be on(?: the | )'(\d+|top|last)'(?:st|th|nd|rd|) position$/, async function(watchlistName, position) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      let p;
      if (parseInt(position)) {
        p = position - 1;
      } else if (position === 'top') {
        p = 0;
      } else if (position === 'last') {
        const count = await this.basePage.currentBoard.tabBody.currentPanel.getWatchlistCount();
        p = count - 1;
      }
      // await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).waitReady(2000);
      const name = await this.basePage.currentBoard.tabBody.currentPanel.getList(p).getName();
      this.expect(name).to.include(watchlistName);
    }
  });

  Then(/^the '(.+)' watchlist (could|couldn't) be deleted$/, async function(watchlist, ability) {
    const condition = ability === 'could';
    const is = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlist).isDeleteAvailable();
    this.expect(condition).to.equal(is);
  });

  Then(/^the '(.+)' watchlist should return the same markets as backend request$/, async function(watchlist) {
    const tags = {
      'Popular Markets': 152
    };
    const marketsFromBackend = await this.backendHelper.getMarketsParametersByTagId(tags[watchlist], 50);
    const marketsFromUi = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlist).getAllMarketsTitles();
    const marketsNum = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlist).getMarketsCount();
    this.expect(marketsNum).to.be.above(0);
    this.expect(marketsFromBackend.sort()).to.deep.equal(marketsFromUi.sort());
  });

  Then(/^the '(Popular Markets CFD|Popular Markets Spread Bet)' markets should be ordered by weight$/, async function(watchlist) {
    const options = {
      tagId: 152,
      num: 50,
      query: '',
      spread: false,
      cfd: false,
      includeOptions: true
    };

    if (watchlist === 'Popular Markets CFD') {
      options.cfd = true;
    } else if (watchlist === 'Popular Markets Spread Bet') {
      options.spread = true;
    }
    const marketsFromBackend = await this.backendHelper.getMarketsNamesByQuery(options);
    const group = await this.basePage.currentBoard.tabBody.browse.groupByWeighting(marketsFromBackend);
    const keys = Object.keys(group);
    const sortedGroup = [];
    for (let i = keys.length - 1; i >= 0; i--) {
      const b = await this.basePage.currentBoard.tabBody.browse.sortByName(group[keys[i]]);
      sortedGroup.push(b);
    }
    let expectedMarketsList = sortedGroup.reduce(
      (accumulator, currentValue) => {
        return accumulator.concat(currentValue);
      },
      []
    );
    expectedMarketsList = expectedMarketsList.map(a => a.trim());

    const marketsNum = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlist).getMarketsCount();
    let actualMarketsList = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlist).getAllMarketsTitles();
    actualMarketsList = actualMarketsList.map(a => a.toLowerCase());

    this.expect(marketsNum).to.be.above(0);
    this.expect(actualMarketsList).to.deep.equal(expectedMarketsList);
  });

  // review step and sorting way in watchlist - after 1.23
  Then(/^the PopularMarkets watchlist's markets should be ordered by '(.+)'$/, async function(orderParameter) {
    const marketsIdsFromUi = await this.basePage.currentBoard.tabBody.currentPanel.getList('Popular Markets').getAllMarketsIds();
    const actualOrderParams = [];
    for (let i = 0; i < marketsIdsFromUi.length; i++) {
      const info = await this.backendHelper.getMarketInformation(marketsIdsFromUi[i]);
      actualOrderParams.push(info[orderParameter]);
    }
    const expectedOrderParams = actualOrderParams.map(t => t);
    expectedOrderParams.sort((a, b) => {
      if (a > b) return -1;
      if (a < b) return 1;
      if (a === b) return 0;
    });
    this.expect(actualOrderParams).to.deep.equal(expectedOrderParams);
  });

  Then(/^the '(.+)' watchlist should contain '(.+)' market$/, async function(watchlistName, marketName) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      let actualState;
      if (marketName === 'previously added') {
        marketName = this.memory.marketName;
        actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.isMarketPresent(marketName);
      } else {
        if (marketName === 'current') {
          marketName = this.memory.marketName;
        }
        // await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).waitReady(2000);
        actualState = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).isMarketPresent(marketName);
      }

      const expectedState = true;
      this.expect(actualState).to.equal(expectedState);
    }
  });

  Then(/^1-click '(.+)' for all markets from '(.+)' watchlist should be displayed according to market status$/,
  async function(field, watchlistName) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      field = `1-click ${field.toLowerCase()}`;
      const marketsIds = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).getAllMarketsIds();
      for (let i = 0; i < marketsIds.length; i++) {
        let status;
        if (this.memory[`${marketsIds[i]}Status`]) {
          status = this.memory[`${marketsIds[i]}Status`];
        } else {
          await this.lightstreamer.subscribe(marketsIds[i]);
          status = await this.lightstreamer.addListener('StatusSummary');
          this.memory[`${marketsIds[i]}Status`] = status;
        }

        // status === '4' for closed markets, status === '0' for opened
        if (status === '4') {
          const actualState = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).getMarket(i).isElementVisible(field);
          this.expect(actualState).to.equal(false);
        } else if (status === '0') {
          const actualState = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).getMarket(i).isElementVisible(field);
          this.expect(actualState).to.equal(true);
        }
      }
    }
  });

  Then(/^markets of '(.+)' watchlist should be (visible|invisible)$/, async function(watchlistName, visibility) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      const expectedResult = visibility.toLowerCase() === 'visible';

      const result = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).isListMarketsVisible();

      this.expect(result).to.equal(expectedResult);
    }
  });

  Then(/^the '(.+)' watchlist should be (invisible|visible)$/, async function(watchlistName, visibility) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      const expectedResult = visibility.toLowerCase() === 'visible';
      const result = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).isVisible();

      this.expect(result).to.equal(expectedResult);
    }
  });

  Then(/^the '(.+)' element should be (invisible|visible) on '(.+)'(?:st|th|nd|rd|) watchlist$/, async function(elem, visibility, watchlistNameOrNumber) {
    if (parseInt(watchlistNameOrNumber)) {
      watchlistNameOrNumber = watchlistNameOrNumber - 1;
    }
    const expectedResult = visibility.toLowerCase() === 'visible';
    const result = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameOrNumber).isVisible(elem);

    this.expect(result).to.equal(expectedResult);
  });

  Then(/^the '(.+)' market is (invisible|visible)$/, async function(marketName, visibility) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      const expectedResult = visibility.toLowerCase() === 'visible';

      let result;

      if (marketName.toLowerCase() === 'previously added' || marketName.toLowerCase() === 'current') {
        result = await this.basePage.currentBoard.tabBody.currentPanel.currentList.isMarketPresent(this.memory.marketName.toLowerCase());
      } else {
        result = await this.basePage.currentBoard.tabBody.currentPanel.currentList.isMarketPresent(marketName.toLowerCase());
      }

      this.expect(result).to.equal(expectedResult);
    }
  });

  Then(/^the '(.+)' market should be on(?: the | )'(\d+|top|last|same|different)'(?:st|th|nd|rd|) position in the '(.+)' watchlist$/,
    async function(marketName, position, watchlistName) {
      if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
        let num;
        if (parseInt(position)) {
          num = position - 1;
        } else if (position === 'top') {
          num = 0;
        } else if (position === 'last') {
          const count = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).getMarketsCount();
          num = count - 1;
        } else if (position === 'same' || position === 'different') {
          num = this.memory.marketPosition[marketName] - 1;
        }
        await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).waitReady(2000);
        const name = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistName).getMarket(num).getName(false);

        if (position === 'different') {
          this.expect(name.toLowerCase()).to.not.include(marketName.toLowerCase());
        } else {
          this.expect(name.toLowerCase()).to.include(marketName.toLowerCase());
        }
      }
  });

  Then(/^watchlists count should be '(\d+)'$/, async function(expectedCount) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      let actualCount: number;
      await browser.wait(async() => {
        actualCount = await this.basePage.currentBoard.tabBody.currentPanel.getWatchlistCount();

        return this.helper.sleepIfFalse(actualCount === expectedCount, 500);
      }, 10000)
        .then(() => null, () => null);

      this.expect(actualCount).to.equal(expectedCount);
    }
  });

  Then(/^'(.+)' in watchlist panel should( not|) be displayed( in '(\d+)'ms|)$/, async function(elementName, expectedState, expectedTimeout) {
    function stopwatch(start?) {
      if (!start) {
        return process.hrtime();
      }
      const end = process.hrtime(start);

      return Math.round((end[0] * 1000) + (end[1] / 1000000));
    }

    let actualState;
    expectedState = expectedState !== ' not';

    let actualTimeout = stopwatch();
    await browser.wait(async() => {
      actualState = await this.basePage.currentBoard.tabBody.currentPanel.getList('Popular Markets').isVisible(elementName);

      return this.helper.sleepIfFalse(actualState === expectedState);
    }, 20000)
      .then(() => null, () => null);
    actualTimeout = stopwatch(actualTimeout);

    if (expectedTimeout) {
      // this.expect(actualTimeout).to.be.above(parseInt(expectedTimeout));
    }
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^text of '(.+)' in watchlist panel should be '(.+)'$/, async function(elementName, expectedText) {
    const actualText = await this.basePage.currentBoard.tabBody.currentPanel.getElementText(elementName);
    if (expectedText.match(/(WebMinSize|MaxLongSize|MaxShortSize)/)) {
      const text = expectedText.split(/(WebMinSize|MaxLongSize|MaxShortSize)/)[0];
      const size = expectedText.split(/(WebMinSize|MaxLongSize|MaxShortSize)/)[1];
      expectedText = `${text}${this.memory[size]}`;
    }
    this.expect(actualText).to.equal(expectedText);
  });

  Then(/^'(.+)'(?:st|th|nd|rd|) watchlist should be empty and contain text '(.+)'$/, async function(watchlistNameOrNumber, expectedText) {
    if (parseInt(watchlistNameOrNumber)) {
      watchlistNameOrNumber = watchlistNameOrNumber - 1;
    }
    let actualNumber: number;
    let actualText: string;
    if (watchlistNameOrNumber === 'current') {
      actualNumber = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarketsCount();
      actualText = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getEmptyText();
    } else {
      actualNumber = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameOrNumber).getMarketsCount();
      actualText = await this.basePage.currentBoard.tabBody.currentPanel.getList(watchlistNameOrNumber).getEmptyText();
    }
    this.expect(actualNumber).to.equal(0);
    this.expect(actualText).to.equal(expectedText);
  });


});
