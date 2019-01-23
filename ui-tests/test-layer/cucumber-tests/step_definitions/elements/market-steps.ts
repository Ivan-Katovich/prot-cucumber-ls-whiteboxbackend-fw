/* tslint:disable:max-line-length */
import { defineSupportCode } from 'cucumber';
import { browser, element, by } from 'protractor';
import { MarketStatusEnum } from '../../../../support/enums/market-status.enum';
import { getValue } from '../../../../support/utils/helper';


defineSupportCode(function({ Given, When, Then }) {

  // click on markets' elements from watchlist/position/orders/reports
  When(/^I click on '(.+)' in the '(.+)'(?:st|th|nd|rd|)(?: market| position| order)$/, async function(point, marketNameOrNumber) {
    if (point === 'sell' || point === 'buy') {
      this.memory.direction = point;
    }
    let marketId;
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketId = this.memory.marketId;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const marketElement = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber, marketId);

    if (!(String(marketNameOrNumber).toLowerCase() === 'previously added') || !(String(marketNameOrNumber).toLowerCase() === 'current')) {
      this.memory.marketId = await marketElement.getId();
      this.memory.marketName = await marketElement.getName();
    }

    if (process.env.npm_config_browser.includes('firefox')) {
      await marketElement.scrollTo();
    }
    await marketElement.click(point);
  });

  // click on markets' elements from BROWSER TAB
  When(/^I click on '(.+)' in the '(.+)'(?:st|th|nd|rd|) market on browse tab$/, async function(point, marketNameOrNumber) {
    if (point === 'sell' || point === 'buy') {
      this.memory.direction = point;
    }
    let marketId;
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketId = this.memory.marketId;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const marketElement = await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(marketNameOrNumber, marketId);

    if (!(String(marketNameOrNumber).toLowerCase() === 'previously added') || !(String(marketNameOrNumber).toLowerCase() === 'current')) {
      this.memory.marketId = await marketElement.getId();
      this.memory.marketName = await marketElement.getName();
    }

    if (process.env.npm_config_browser.includes('firefox')) {
      await marketElement.scrollTo();
    }
    await marketElement.click(point);
  });

  // click on markets' elements from SEARCH MODAL
  When(/^I click on '(.+)' in the '(.+)'(?:st|th|nd|rd|) market within search modal$/, async function(point, marketNameOrNumber) {
    if (point === 'sell' || point === 'buy') {
      this.memory.direction = point;
    }
    let marketId;
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketId = this.memory.marketId;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const marketElement = await this.basePage.searchModal.getMarket(marketNameOrNumber, marketId);

    if (!(String(marketNameOrNumber).toLowerCase() === 'previously added') || !(String(marketNameOrNumber).toLowerCase() === 'current')) {
      this.memory.marketId = await marketElement.getId();
      this.memory.marketName = await marketElement.getName();
    }

    if (process.env.npm_config_browser.includes('firefox')) {
      await marketElement.scrollTo();
    }
    await marketElement.click(point);
  });

  When(/^I perform right click on '(.+)' in the '(.+)'(?:st|th|nd|rd|) (market| market on browse tab| position| found market| order|)$/,
    async function(point, marketNameOrNumber, itemType) {
      if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
        if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
          marketNameOrNumber = this.memory.marketName;
        } else if (parseInt(marketNameOrNumber)) {
          marketNameOrNumber = marketNameOrNumber - 1;
        }
        await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber, this.memory.marketId).contextClick(point);
      }
    });

  When(/^I find the highest weighted market in '(.+)' watchlist$/, async function(watchlistName) {
    let allWatchlistMarkets;
    if (watchlistName === 'Popular Markets') {
      allWatchlistMarkets = await this.backendHelper.getMarketsNamesByQuery(152, 50, '', true, true, true);
    }
    // not covered for not-Popular Markets watchlist
    const group = await this.basePage.currentBoard.tabBody.browse.groupByWeighting(allWatchlistMarkets);
    const keys = Object.keys(group);
    const sortedGroup = [];
    for (let i = keys.length - 1; i >= 0; i--) {
      const b = await this.basePage.currentBoard.tabBody.browse.sortByName(group[keys[i]]);
      sortedGroup.push(b);
    }

    const highestWeightedMarket = sortedGroup.reduce(
      (accumulator, currentValue) => {
        return accumulator.concat(currentValue);
      },
      []
    )[0];

    this.memory.marketName = highestWeightedMarket;
  });

  When(/^I find( new|) market with (different|same) '(.+)' and '(.+)'$/,
  async function(isNew, state, firstProperty, secondProperty) {
    state = state === 'same';
    let marketInfo;
    const allMarketsIds = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getAllMarketsIds();
    for (const marketId of allMarketsIds) {
      marketInfo = await this.backendHelper.getMarketInformation(parseInt(marketId));
      if (state === (marketInfo[firstProperty] === marketInfo[secondProperty])) {
        if (isNew && this.memory.marketId !== marketId) {
          this.memory.newMarketName = marketInfo.Name;
          this.memory.newMarketId = marketId;
          break;
        } else {
          this.memory.marketName = marketInfo.Name;
          this.memory.marketId = marketId;
          break;
        }
      }
    }
    if (!state === (marketInfo[firstProperty] === marketInfo[secondProperty])) {
      console.log(`There is no market with ${state} ${firstProperty} and ${secondProperty}`);
    }
  });

  When(/^I find (Normal|Closed) market with '(.+)' property (is|is not) '(.+)' in (search modal|watchlist)$/,
    async function(marketStatus, property, flag, value, component) {
      this.memory.marketName = null;
      this.memory.marketId = null;
      let marketInfo;

      if (!isNaN(parseFloat(value))) {
        value = parseFloat(value);
      }

      value = value === 'true' ? true : value === 'false' ? false : value;

      let allMarketsIds;
      if (component === 'watchlist') {
        allMarketsIds = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getAllMarketsIds();
      } else {
        allMarketsIds = await this.basePage.searchModal.getAllMarketsIds();
      }

      let status;
      for (const marketId of allMarketsIds) {
        marketInfo = await this.backendHelper.getMarketInformation(parseInt(marketId));

        let propertyFlag;
        if (flag === 'is') {
          propertyFlag = (marketInfo[property] === value);
        } else {
          propertyFlag = (marketInfo[property] !== value);
        }

        if (propertyFlag) {
          this.lightstreamer.subscribe(marketId);
          status = parseInt(await this.lightstreamer.addListener('StatusSummary'));

          if (status === MarketStatusEnum[marketStatus]) {
            this.memory.marketName = marketInfo.Name;
            this.memory.marketId = marketId;
            break;
          }
        }
      }

      if (this.memory.marketId === null) {
        console.log(`There is no suitable opened market`);
      } else {
        console.log(this.memory.marketName);
      }
    });

  When(/^I find market with (available|disabled) Guaranteed stop$/, async function(state) {
    state = state === 'available';
    let marketInfo;
    const allMarketsIds = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getAllMarketsIds();
    for (const marketId of allMarketsIds) {
      marketInfo = await this.backendHelper.getMarketInformation(parseInt(marketId));
      if (state === marketInfo.AllowGuaranteedOrders) {
        this.memory.marketName = marketInfo.Name;
        this.memory.marketId = marketId;
        break;
      }
    }
    if (!state === marketInfo.AllowGuaranteedOrders) {
      console.log(`There is no market with ${state} Guaranteed stop`);
    }
  });

  When(/^I find market with at least '(\d*)' decimal places$/, async function(decimalPlaces) {
    decimalPlaces = parseInt(decimalPlaces);

    let marketInfo;
    let marketStatus;
    const allMarketsIds = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getAllMarketsIds();
    for (const marketId of allMarketsIds) {
      marketInfo = await this.backendHelper.getMarketInformation(parseInt(marketId));

      this.lightstreamer.subscribe(marketId);
      marketStatus = parseInt(await this.lightstreamer.addListener('StatusSummary'));
      // 4 - status for closed market
      if (marketInfo.PriceDecimalPlaces >= decimalPlaces && marketStatus === 0) {
        this.memory.marketName = marketInfo.Name;
        this.memory.marketId = marketId;
        break;
      }
    }
    if (!(marketInfo.PriceDecimalPlaces >= decimalPlaces && marketStatus === 0)) {
      console.log(`There is no opened market with at least ${decimalPlaces} decimal places`);
    } else {
      console.log(this.memory.marketName);
    }
  });

  When(/^I find market, which price without demical places$/, async function() {
    let marketInfo;
    let marketStatus;
    const allMarketsIds = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getAllMarketsIds();
    for (const marketId of allMarketsIds) {
      marketInfo = await this.backendHelper.getMarketInformation(parseInt(marketId));

      this.lightstreamer.subscribe(marketId);
      marketStatus = parseInt(await this.lightstreamer.addListener('StatusSummary'));
      // 4 - status for closed market
      if (marketInfo.PriceDecimalPlaces === 0 && marketStatus === 0) {
        this.memory.marketName = marketInfo.Name;
        this.memory.marketId = marketId;
        break;
      }
    }
    if (!(marketInfo.PriceDecimalPlaces === 0 && marketStatus === 0)) {
      console.log('There is no opened market, which price without demical places');
    } else {
      console.log(this.memory.marketName);
    }
  });

  When(/^I find (CFD|Spread|any) market with (available|disabled) Guaranteed stop( and '(1|2)'(?:st|nd) message type|) in (search modal|watchlist)$/, async function(marketType, state, messageType, component) {
    state = state === 'available';
    this.memory.marketName = null;
    this.memory.marketId = null;
    let marketInfo;
    let marketStatus;

    let allMarketsIds;
    if (component === 'watchlist') {
      allMarketsIds = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getAllMarketsIds();
    } else {
      allMarketsIds = await this.basePage.searchModal.getAllMarketsIds();
    }

    for (const marketId of allMarketsIds) {
      marketInfo = await this.backendHelper.getMarketInformation(parseInt(marketId));
      this.lightstreamer.subscribe(marketId);
      marketStatus = parseInt(await this.lightstreamer.addListener('StatusSummary'));

      const marketTypeFlag = marketType === 'any' ? true : marketType === marketInfo.MarketSettingsType;

      if (messageType) {
        if (marketStatus === 0 && state === marketInfo.AllowGuaranteedOrders && marketTypeFlag && parseInt(messageType) === marketInfo.GuaranteedOrderPremiumUnits) {
          this.memory.marketName = marketInfo.Name;
          this.memory.marketId = marketId;
          break;
        }
      } else {
        if (marketStatus === 0 && state === marketInfo.AllowGuaranteedOrders && marketTypeFlag) {
          this.memory.marketName = marketInfo.Name;
          this.memory.marketId = marketId;
          break;
        }
      }
    }

    if (this.memory.marketId === null) {
      console.log(`There is no opened market with ${state} Guaranteed stop`);
    }
  });

  When(/^I find (CFD|Spread|any)( new|) market$/, async function(marketType, isNew) {
    let marketInfo;
    let marketStatus;
    const allMarketsIds = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getAllMarketsIds();
    for (const marketId of allMarketsIds) {
      marketInfo = await this.backendHelper.getMarketInformation(parseInt(marketId));
      this.lightstreamer.subscribe(marketId);
      marketStatus = parseInt(await this.lightstreamer.addListener('StatusSummary'));
      if ((marketType === marketInfo.MarketSettingsType || marketType === 'any') && marketStatus === 0) {
        if (isNew && this.memory.marketId !== marketId) {
          this.memory.newMarketName = marketInfo.Name;
          this.memory.newMarketId = parseInt(marketId);
          break;
        } else if (!isNew) {
          this.memory.marketName = marketInfo.Name;
          this.memory.marketId = parseInt(marketId);
          break;
        }
      }
    }
  });

  When(/^I hover '(.+)'(?:st|th|nd|rd|) (market|found market|position|order)$/, async function(marketNameOrNumber, itemType) {
    let market;
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
      market = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber);
    } else if (marketNameOrNumber.toLowerCase() === 'new') {
      marketNameOrNumber = this.memory.newMarketName;
      market = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber);
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      if (itemType.includes('found')) {
        market = await this.basePage.searchModal.getMarket(marketNameOrNumber);
      } else {
        market = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber);
      }
      this.memory.marketName = await market.getName();
    } else {
      this.memory.marketName = marketNameOrNumber;
      market = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber);
      this.memory.marketId = parseInt(await market.getId());
    }

    await market.hover();
  });

  When(/^I remove '(.+)'(?:st|th|nd|rd|) (?:market|position|order)$/, async function(marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
    } else {
      this.memory.marketName = marketNameOrNumber;
    }
    const listName = this.basePage.currentBoard.tabBody.currentPanel.currentList.getListName();
    const closeAllSubMarkets = () => {
      return Promise.resolve()
        .then(() => this.basePage.currentBoard.tabBody.currentPanel.getList(listName).getMarket(marketNameOrNumber).getSubMarket(0).click('delete'))
        .then(() => this.basePage.currentBoard.tabBody.getPanel('Deal Ticket').submit())
        .then(() => this.basePage.currentBoard.tabBody.getPanel('positions and orders').getList(listName).doesMarketExist(this.memory.marketName))
        .then((is) => {
          if (is) {
            return closeAllSubMarkets();
          }
        });
    };
    const isMulti = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).isMulti();
    if (!isMulti) {
      await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).click('delete');
      await this.basePage.currentBoard.tabBody.getPanel('Deal Ticket').submit();
      await this.basePage.currentBoard.tabBody.getPanel('positions and orders');
    } else {
      const isExpanded = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).isExpanded();
      if (!isExpanded) {
        await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).expand();
      }
      await closeAllSubMarkets();
    }
  });

  When(/^I select '(.+)' in dropdown menu in '(.+)'(?:st|th|nd|rd|) (?:market|position|order)$/, async function(optionNameOrNumber, marketNameOrNumber) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
        // do nothing
      } else if (parseInt(marketNameOrNumber)) {
        marketNameOrNumber = marketNameOrNumber - 1;
        this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
      } else {
        this.memory.marketName = marketNameOrNumber;
      }

      if (parseInt(optionNameOrNumber)) {
        optionNameOrNumber = optionNameOrNumber - 1;
      }
      await this.basePage.dropdown.select(optionNameOrNumber);
    }
  });

  When(/^I expand dropdown for '(.+)'(?:st|th|nd|rd|) (market|position|order|found market)$/, async function(marketNameOrNumber, itemType) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      if (itemType.includes('found')) {
        this.memory.marketName = await this.basePage.searchModal.getMarket(marketNameOrNumber).getName();
      } else {
        this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
      }
    } else {
      this.memory.marketName = marketNameOrNumber;
    }
    if (itemType.includes('found')) {
      await this.basePage.searchModal.getMarket(marketNameOrNumber).expandDropdown();
    } else {
      await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).expandDropdown();
    }
  });

  When(/^I complete '(.+)'(?:st|th|nd|rd|) (market|position|order|found market) dropdown with value '(.+)'$/, async function(marketNameOrNumber, itemType, optionNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      if (itemType.includes('found')) {
        this.memory.marketName = await this.basePage.searchModal.getMarket(marketNameOrNumber).getName();
      } else {
        this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
      }
    } else {
      this.memory.marketName = marketNameOrNumber;
    }
    if (parseInt(optionNameOrNumber)) {
      optionNameOrNumber = optionNameOrNumber - 1;
    }
    if (itemType.includes('found')) {
      await this.basePage.searchModal.getMarket(marketNameOrNumber).expandDropdown();
      await this.basePage.dropdown.select(optionNameOrNumber);
    } else {
      await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).expandDropdown();
      await this.basePage.dropdown.select(optionNameOrNumber);
    }
  });

  When(/^I hover mouse on (Sell|Buy) price in the '(.+)'(?:st|th|nd|rd) market( on browse tab|)$/, async function(typePrice, marketNameOrNumber, location) {
    if (typeof parseInt(marketNameOrNumber) === 'number') {
      marketNameOrNumber = marketNameOrNumber - 1;
    }

    if (location === ' on browse tab') {
      await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(marketNameOrNumber).hoverElement(`${typePrice} on browse`);
    } else {
      await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).hoverElement(typePrice);
    }
  });

  Then(/^'(.+)' in the '(.+)'(?:st|th|nd|rd|) market on browse tab and '(.+)' on chart should contain the same price$/,
    async function(firstItem, marketNameOrNumber, secondItem) {
      if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
        marketNameOrNumber = this.memory.marketName;
      } else if (parseInt(marketNameOrNumber)) {
        marketNameOrNumber = marketNameOrNumber - 1;
        this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
      } else if (marketNameOrNumber.toLowerCase() === 'closed' || marketNameOrNumber.toLowerCase() === 'phone only') {
        marketNameOrNumber = this.memory[marketNameOrNumber];
      } else {
        this.memory.marketName = marketNameOrNumber;
      }

      const market = await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(marketNameOrNumber);
      let actualMarketPrice, actualChartPrice;

      await browser.wait(() => {
        const promiseArr = [];

        promiseArr.push(market.getPrice(firstItem)
          .then((price) => {
            actualMarketPrice = price.trim();
          }));

        promiseArr.push(this.basePage.currentBoard.tabBody.getPanel('chart').getText(secondItem)
          .then((price) => {

            if (process.env.npm_config_browser === 'safari') {
              actualChartPrice = price.trim().replace(/[A-Z]?[a-z]*/, '');
            } else {
              actualChartPrice = price.trim().split(/\n/)[1];
            }
          }));

        return Promise.all(promiseArr)
          .then(() => actualMarketPrice === actualChartPrice);
      }, 60000)
        .then(() => null, () => null);

      this.expect(actualMarketPrice).to.equal(actualChartPrice);
  });

  Then(/^'(.+)'(?:st|th|nd|rd|) found market fields should be arranged in the right order$/, async function(marketNameOrNumber) {
    let market;
    if (marketNameOrNumber.toLowerCase() === 'current') {
      market = await this.basePage.searchModal.getMarket(this.memory.marketName, this.memory.marketId);
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      market = await this.basePage.searchModal.getMarket(marketNameOrNumber);
    }
    const actualLocation = [];
    actualLocation[0] = (await market.getLocation('name')).x;
    actualLocation[1] = (await market.getLocation('bid price')).x;
    actualLocation[2] = (await market.getLocation('ask price')).x;
    actualLocation[3] = (await market.getLocation('change')).x;
    actualLocation[4] = (await market.getLocation('plus icon')).x;

    this.expect(actualLocation).to.deep.equal(actualLocation.sort());
  });

  Then(/^'(.+)'(?:st|th|nd|rd|) found market '(.+)' '(should|should not)' update according to market status$/,
    async function(marketNameOrNumber, type, state) {
    let market;
    if (marketNameOrNumber.toLowerCase() === 'current') {
      market = await this.basePage.searchModal.getMarket(this.memory.marketName, this.memory.marketId);
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      market = await this.basePage.searchModal.getMarket(marketNameOrNumber);
      this.memory.marketName = await market.getName();
      this.memory.marketId = parseInt(await market.getId());
    }
    const data = await market.getPrice(type);
    this.lightstreamer.subscribe(this.memory.marketId);
    const status = await this.lightstreamer.addListener('StatusSummary');
    const timeWait = status === '4' ? 30000 : 120000;

    const actualState = await browser.wait(() => {
      return market.getPrice(type)
        .then((text) => this.helper.sleepIfFalse(text !== data, 200));
    }, timeWait)
      .then(() => true, () => false);

    let expectedState;
    if (state === 'should') {
      expectedState = status === '0';
    } else {
      expectedState = false;
    }
    this.expect(actualState).to.equal(expectedState);
  });


  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order) should be (present|not present) on the list$/, async function(marketNameOrNumber, isPresent) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    let actualState: boolean;
    try {
      /* await browser.wait(async() => {
        // await this.basePage.currentBoard.tabBody.currentPanel.clickActiveList();
        await this.basePage.currentBoard.tabBody.currentPanel.currentList.clickList();
        if (isPresent === 'present') {
          actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.doesMarketExist(marketNameOrNumber);
        } else {
          actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.doesMarketAbsent(marketNameOrNumber);
        }

        return this.helper.sleepIfFalse(actualState);
      }, 3000); */

      await this.basePage.currentBoard.tabBody.currentPanel.currentList.clickList();
      if (isPresent === 'present') {
        actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.doesMarketExist(marketNameOrNumber);
      } else {
        actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.doesMarketAbsent(marketNameOrNumber);
      }
      if (!actualState) {
        throw new Error('Something wrong. Refresh');
      }
    } catch (err) {
      console.log('refresh light');
      await this.basePage.currentBoard.tabBody.currentPanel.refreshList();
      // await browser.refresh();
      // await this.basePage.waitLoading();
      /* await browser.wait(async() => {
        if (isPresent === 'present') {
          actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.doesMarketExist(marketNameOrNumber);
        } else {
          actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.doesMarketAbsent(marketNameOrNumber);
        }

        return this.helper.sleepIfFalse(actualState);
      }, 2000)
        .then(() => null, () => null); */

      if (isPresent === 'present') {
        actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.doesMarketExist(marketNameOrNumber);
      } else {
        actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.doesMarketAbsent(marketNameOrNumber);
      }
    }

    this.expect(actualState).to.equal(true);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order) should be colored correctly$/, async function(marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const listName = this.basePage.currentBoard.tabBody.currentPanel.currentList.getListName();
    const positionColor = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getPositionColor();
    let text;
    if (listName === 'positions') {
      text = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('position');
    } else {
      text = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('quantity');
    }
    if (text.toLowerCase().includes('sell')) {
      this.expect(positionColor).to.include('222, 69, 89');
    } else {
      this.expect(positionColor).to.include('44, 124, 179');
    }
  });

  Then(/^open trade confirmation message should be displayed correctly$/, async function() {
    const actualMessage = (await this.basePage.currentBoard.tabBody.currentPanel.getElementText('confirmation message'))
      .replace(/\n/g, ' ').replace(/\s{2,}/g, ' ').toLowerCase();
    const expectedMessage = new RegExp(/^trade placed buy \d+,?\d*?.?\d* at \d+,?\d*?.?\d*$/);
    this.expect(actualMessage).to.match(expectedMessage);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order) direction icon should be colored correctly$/, async function(marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const positionColor = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getDirectionColor();

    if (this.memory.direction === 'sell') {
      this.expect(positionColor).to.include('222, 69, 89');
    } else {
      this.expect(positionColor).to.include('44, 124, 179');
    }
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order) '(.+)' should be (visible|not visible)$/, async function(marketNameOrNumber, elementName, visibility) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const expectedCondition = visibility === 'visible';
    const actualCondition = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).isElementVisible(elementName);
    this.expect(actualCondition).to.equal(expectedCondition);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order) unrealised cell should be visible and colored correctly$/, async function(marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const textColor = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getUnrealisedColor();
    const data = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('unrealised');
    const num = data.split(/[\n ]/)[0] * 1;
    if (num < 0) {
      this.expect(textColor).to.include('222, 69, 89');
    } else {
      this.expect(textColor).to.include('44, 124, 179');
    }
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) market position cell should contain '(.*)' direction and quantity$/, async function(marketNameOrNumber, expectedPosition) {
    // expectedPosition = expectedPosition.toLowerCase().replace(/\s|\,/g, '');
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
    }
    let actualPosition: string;
    /* await browser.wait(async() => {
      await this.basePage.currentBoard.tabBody.currentPanel.currentList.clickList();
      actualPosition = (await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('position')).replace(/\s/g, '');

      return this.helper.sleepIfFalse(actualPosition.toLowerCase() === expectedPosition.toLowerCase());
    }, 5000)
      .then(() => null, async() => {
        console.log('refresh light');
        // await browser.refresh();
        await this.basePage.currentBoard.tabBody.currentPanel.refreshList();
        await browser.wait(async() => {
          actualPosition = (await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('position'))
            .replace(/\s/g, '').replace(/\,/g, '');

          return this.helper.sleepIfFalse(actualPosition.toLowerCase() === expectedPosition);
        }, 5000)
          .then(() => null, () => null);
      }); */

      const direction = expectedPosition.split(' ')[0];
      const value = await getValue.call(this, expectedPosition.replace(/\w+\s/, ''));
      expectedPosition = `${direction}${value}`;

      await this.basePage.currentBoard.tabBody.currentPanel.currentList.clickList();
      actualPosition = (await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('position'))
        .replace(/\s/g, '');

      if (actualPosition.toLowerCase() !== expectedPosition.toLowerCase()) {
        await this.basePage.currentBoard.tabBody.currentPanel.refreshList();
        actualPosition = (await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('position'))
            .replace(/\s/g, '').replace(/\,/g, '');
      }

    this.expect(actualPosition.toLowerCase()).to.equal(expectedPosition);
  });

  // this step uses this.memory[orderType] object - which is filed in
  // "I store data from the( main | oco | )'(.+)'(?:st|th|nd|rd|) (normal stop|guaranteed stop|trailing stop|limit|) linked order" step
  Then(/^the previously added market (stop price|limit price|) cell should contain previously set linked order data/,
    async function(cellName) {
      const actualText = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(this.memory.marketName).getText(cellName);
      const memoryValues = {
        'stop price': this.memory['normal stop']['price'],
        'limit price': this.memory['limit']['price']
      };
      const expectedText = memoryValues[cellName];
      this.expect(actualText).to.equal(expectedText);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|)(?: market's | )(market|[Pp]osition|[Oo]rder|sub-market \d) '(.+)' cell should contain '(.*)' (?:data|word)$/,
       async function(marketNameOrNumber, type, cellName, data) {
    if (data.match(/(buy|sell) (max|min|\d+min|\d+max) valid(\+|\*|-)\d+?\.?\d*/)) {
      const direction = data.split(' ')[0];
      let quantityType = data.split(/(\+|\*|-)/)[0].split(/\s/)[1];
      let coef = 1;
      if (quantityType.match(/\d+/)) {
        coef = parseInt(quantityType.match(/\d+/)[0]);
        quantityType = quantityType.split(/\d+/)[1];
      }
      const multiplier = data.split(/(\+|\*|-)/)[2];
      const operation = data.split(/(\+|\*|-)/)[1];
      data = direction + new Function('', `return ${coef * parseFloat(this.memory[`${quantityType}Quantity`])} ${operation} ${parseFloat(multiplier)};`)();
    } else if (data.match(/(max|min|\d+min|\d+max) valid(\+|\*|\-)\d+?\.?\d*/)) {
      let quantityType = data.split(/(\+|\*|-)/)[0].split(/\s/)[0];
      let coef = 1;
      if (quantityType.match(/\d+/)) {
        coef = parseInt(quantityType.match(/\d+/)[0]);
        quantityType = quantityType.split(/\d+/)[1];
      }
      const multiplier = data.split(/(\+|\*|-)/)[2];
      const operation = data.split(/(\+|\*|-)/)[1];
      data = new Function('', `return ${coef * parseFloat(this.memory[`${quantityType}Quantity`])} ${operation} ${parseFloat(multiplier)};`)();
    } else {
      data = data.replace(' ', '').toLowerCase();
    }

    cellName = cellName.toLowerCase();
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
      if ((cellName === 'position' && data === 'correct') || (cellName === 'quantity' && data === 'correct')) {
        data = this.memory.direction.toLowerCase() + this.memory.quantity;
      } else if ((cellName === 'position' || cellName === 'quantity') && data === 'updated') {
        data = this.memory.direction + this.memory.leftQuantity;
        data = data.toLowerCase();
      } else if (cellName === 'opening price' && data === 'correct') {
        data = this.memory.prices[this.memory.direction.toLowerCase()].replace(/\n| |,/g, '');
      } else if (parseFloat(this.memory[cellName]) && data === 'correct') {
        data = parseFloat(this.memory[cellName]);
      }
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    let actualText: string;
    if ((cellName === 'unrealised' || cellName === 'pip/point pl') && data === 'correct') {
      data = cellName === 'unrealised' ? /-?\d*\.?\d*(\s|\n)[a-z]{3}/ : /-?\d*\.?\d*/;
      if (type.includes('sub-market')) {
        const marketNumber = parseInt(type.split(' ')[1]) - 1;
        await browser.wait(() => {
          return this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarket(marketNumber).getText(cellName)
            .then((text) => {
              actualText = text;

              return this.helper.sleepIfFalse(actualText.toLowerCase().match(data), 1000);
            });
        }, 20000)
          .then(() => null, () => null);
      } else {
        await browser.wait(() => {
          return this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText(cellName)
            .then((text) => {
              actualText = text;

              return this.helper.sleepIfFalse(actualText.toLowerCase().match(data), 1000);
            });
        }, 20000)
          .then(() => null, () => null);
      }
      // actualText = actualText.replace(/\n| |,/g, '').toLowerCase();
      actualText = actualText.toLowerCase();
    } else {
      if (type.includes('sub-market')) {
        const marketNumber = parseInt(type.split(' ')[1]) - 1;
        actualText = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarket(marketNumber).getText(cellName);
      } else {
        actualText = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText(cellName);
      }
      actualText = actualText.replace(/\n| |,/g, '').toLowerCase();
    }
    if (cellName === 'unrealised' || cellName === 'pip/point pl') {
      this.expect(actualText).to.match(data);
    } else {
      this.expect(actualText).to.include(String(data).replace(/,/g, ''));
    }
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order) '(.+)' cell should be rounded correctly$/, async function(marketNameOrNumber, cellName) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      this.memory.marketId = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getId();
    }
    const marketInformation = await this.backendHelper.getMarketInformation(this.memory.marketId);
    let expectedDemicals;
    if (cellName === 'pip/point pl') {
      expectedDemicals = 1;
    } else if (cellName === 'unrealised') {
      expectedDemicals = parseInt(marketInformation.PriceTolerance);
    } else {
      expectedDemicals = parseInt(marketInformation.PriceDecimalPlaces);
    }
    let actualText = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText(cellName);
    if (cellName === 'unrealised') {
      actualText = actualText.split(/\s/)[0];
    }
    let actualDemicals;
    if (actualText.includes('.')) {
      actualDemicals = actualText.replace(/\,/g, '').split('.')[1].length;
    } else {
      actualDemicals = 0;
    }
    this.expect(expectedDemicals).to.equal(actualDemicals);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order) current price cell should change with time$/, async function(marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const data = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('current price');
    const state = await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('current price')
        .then((text) => this.helper.sleepIfFalse(text !== data, 1000));
    }, 60000)
      .then(() => true, () => false);

    this.expect(state).to.equal(true);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order)( on browse tab|) should be '(black|white)' when it is '(hovered|not hovered)'$/, async function(marketNameOrNumber, location, color, isHovered) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const expectedColor = color === 'black' ? '26, 26, 26' : '255, 255, 255';
    if (isHovered === 'hovered') {
      if (location === ' on browse tab') {
        await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(marketNameOrNumber).hover();
      } else {
        await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).hover();
      }
    }

    let actualColor;
    if (location === ' on browse tab') {
      actualColor = await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(marketNameOrNumber).getRowColor();
    } else {
      actualColor = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getRowColor();
    }
    if (isHovered === 'hovered') {
      await browser.actions().mouseMove({ x: 0, y: 500 }).perform()
        .then(() => null, () => console.log('actions error'));
    }
    this.expect(actualColor).to.include(expectedColor);
  });

  Then(/^the '(.+)' market on browse tab should not be hightlighted$/, async function(marketNameOrNumber) {
    let expectedColor;
    if (process.env.npm_config_browser === 'edge') {
      expectedColor = 'transparent';
    } else {
      expectedColor = '0, 0, 0';
    }
    const actualColor = await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(marketNameOrNumber).getRowColor();
    this.expect(actualColor).to.include(expectedColor);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|)(?: market's | )(market|position|order|sub-markets) columns should be visible:$/, async function(marketNameOrNumber, type, table) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const promises = [];
    table.raw().forEach((el) => {
      if (type === 'sub-markets') {
        promises.push(this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarket(0).isElementVisible(el[0])
          .then((actualState) => {
            this.expect(actualState).to.equal(true);
          }));
      } else {
        promises.push(this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).isElementVisible(el[0])
          .then((actualState) => {
            this.expect(actualState).to.equal(true);
          }));
      }
    });
    await Promise.all(promises);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order) should be displayed as '(multi|single)'$/, async function(marketNameOrNumber, isMulti) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const expectedState = isMulti === 'multi';
    let actualState: boolean;
    await browser.wait(async() => {
      await this.basePage.currentBoard.tabBody.currentPanel.currentList.clickList();
      actualState = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).isMulti();

      return this.helper.sleepIfFalse(actualState === expectedState, 500);
    }, 5000)
      .then(() => null, () => {
        console.log('refresh light');

        return this.basePage.currentBoard.tabBody.currentPanel.refreshList()
          // .then(() => this.basePage.waitLoading())
          .then(() => this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).isMulti())
          .then((state) => actualState = state);
      });

    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|)(?: market's | )(market|position|order|sub-market) '(.+)' should be correct$/, async function(marketNameOrNumber, type, cellName) {
    cellName = cellName.toLowerCase();
    const params = {
      'opening price': 'Price',
    };
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
    }
    let actualData;
    if (type === 'sub-market') {
      actualData = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarket(0).getText(cellName);
    } else {
      actualData = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText(cellName);
     }
    actualData = actualData.replace(/\n| |,/g, '').toLowerCase();
    const dataArray = await this.backendHelper.getBackendMultiDataByName(this.memory.marketName, params[cellName], true, parseInt(this.memory.marketId));
    const expectedData = dataArray[0];
    if (parseFloat(actualData)) {
      actualData = parseFloat(actualData);
    }
    const validError = Math.abs(expectedData) * 0.01; // 1%
    this.expect(actualData).to.be.within(expectedData - validError, expectedData + validError);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|)(?: market's | )(market|position|order|sub-market) '([Ss]top price|[Ll]imit price)' should contain correct data$/, async function(marketNameOrNumber, type, cellName) {
    cellName = cellName.toLowerCase();
    const params = {
      'stop price': 'Stop',
      'limit price': 'Limit',
      quantity: 'quantity'
    };
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
    }
    let actualData;
    if (type === 'sub-market') {
      actualData = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getSubMarket(0).getText(cellName);
    } else {
      actualData = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText(cellName);
    }
    const listName = this.basePage.currentBoard.tabBody.currentPanel.currentList.getListName();
    const isPosition = listName === 'positions';
    actualData = actualData.replace(/\n| |,/g, '').toLowerCase();
    const dataObj = await this.backendHelper.getBackendMultiDataByName(this.memory.marketName, 'IfDone', isPosition, parseInt(this.memory.marketId));
    const expectedData = dataObj[0][0][params[cellName]].TriggerPrice;
    actualData = parseFloat(actualData);
    this.expect(actualData).to.equal(expectedData);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (market|position|order|found market) '(.+)' should contain '(number|word)'$/, async function(marketNameOrNumber, containerType, cellName, regexpType) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    let expectedRegexp;
    switch (regexpType) {
      case 'number':
        expectedRegexp = /\d+\.?\d*/;
        break;
      case 'word':
        expectedRegexp = /\D+/;
        break;
    }
    let actualValue: string;
    if (containerType.includes('found')) {
      actualValue = await this.basePage.searchModal.getMarket(marketNameOrNumber).getText(cellName);
    } else {
      actualValue = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText(cellName);
    }
    this.expect(actualValue).to.match(expectedRegexp);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (market|position|order|found market) change cell should be correct$/, async function(marketNameOrNumber, containerType) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    let actualBid: string;
    let actualAsk: string;
    let actualChange: string;
    if (containerType.includes('found')) {
      actualBid = await this.basePage.searchModal.getMarket(marketNameOrNumber).getText('bid price');
      actualAsk = await this.basePage.searchModal.getMarket(marketNameOrNumber).getText('ask price');
      actualChange = await this.basePage.searchModal.getMarket(marketNameOrNumber).getText('change');
    } else {
      actualBid = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('bid price');
      actualAsk = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('ask price');
      actualChange = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText('change');
    }
    const actualBidNum = parseFloat(parseFloat(actualBid.replace(/\,/g, '')).toPrecision(6));
    const actualAskNum = parseFloat(parseFloat(actualAsk.replace(/\,/g, '')).toPrecision(6));
    const expectedChangeNum = actualBidNum - actualAskNum;
    const actualChangeNum = parseFloat(parseFloat(actualChange.replace(/\,/g, '')).toPrecision(6));
    this.expect(actualChangeNum).to.equal(expectedChangeNum);
  });

  Then(/^the (Sell|Buy) price should be (white|black) in the '(.+)'(?:st|th|nd|rd) market( on browse tab|)$/, async function(typePrice, color, numberOrNameMarket, location) {
    if (typeof parseInt(numberOrNameMarket) === 'number') {
      numberOrNameMarket = numberOrNameMarket - 1;
    }
    let expectedColor;

    if (color === 'white') {
      expectedColor = '255, 255, 255';
    } else {
      expectedColor = '26, 26, 26';
    }

    let actualColor;
    if (location === ' on browse tab') {
      actualColor = await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(numberOrNameMarket).getElementColor(`${typePrice} on browse`);
    } else {
      actualColor = await this.basePage.currentBoard.tabBody.currentPanel.currentList
        .getMarket(numberOrNameMarket).getElementColor(typePrice);
    }
    this.expect(actualColor).to.include(expectedColor);
  });

  Then(/^'(\d+)' '(.+)' (?:market|order)s? should be on the list$/, async function(expectedNumber, marketName) {
    if (marketName.toLowerCase() === 'previously added' || marketName.toLowerCase() === 'current') {
      marketName = this.memory.marketName;
    }

    let actualNumber: number;
    try {
      await browser.wait(async() => {
        await this.basePage.currentBoard.tabBody.currentPanel.currentList.clickList();
        actualNumber = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarketsCount(marketName);

        return this.helper.sleepIfFalse(actualNumber === expectedNumber, 500);
      }, 5000);
    } catch (err) {
      console.log('refresh light');
      await this.basePage.currentBoard.tabBody.currentPanel.refreshList();
      // await browser.refresh();
      // await this.basePage.waitLoading();
      await browser.wait(() => {
        return this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarketsCount(marketName)
          .then((num) => {
            actualNumber = num;

            return this.helper.sleepIfFalse(actualNumber === expectedNumber, 500);
          });
      }, 5000)
        .then(() => null, () => null);
    }

    this.expect(actualNumber).to.equal(expectedNumber);
  });

  Then(/^orders should be sorted by market name in alphabetical order$/, async function() {
    const actualList = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarketsNames();
    this.expect(actualList).to.deep.equal(actualList.sort());
  });

  Then(/^'(.+)' in dropdown menu in '(.+)'(?:st|th|nd|rd|) (?:market|position|order) should be (enabled|disabled)$/, async function(optionNameOrNumber, marketNameOrNumber, expectedState) {
    expectedState = expectedState === 'enabled';
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      // do nothing
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
      this.memory.marketName = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getName();
    } else {
      this.memory.marketName = marketNameOrNumber;
    }
    if (parseInt(optionNameOrNumber)) {
      optionNameOrNumber = optionNameOrNumber - 1;
    }
    const actualState = await this.basePage.dropdown.isOptionEnabled(optionNameOrNumber);
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order|alert) current price should be correct$/, async function(marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    // const marketId = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getId();
    const marketId = this.idMatcher.market[this.memory.marketName];
    let actualPrice = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getPrice('current price');
    this.lightstreamer.subscribe(parseInt(marketId));
    let expectedPrice;
    if (this.memory.direction === 'sell') {
      expectedPrice = await this.lightstreamer.addListener('Bid');
      console.log(`sell=${expectedPrice}`);
    } else {
      expectedPrice = await this.lightstreamer.addListener('Offer');
      console.log(`buy=${expectedPrice}`);
    }
    actualPrice = parseFloat(actualPrice);
    expectedPrice = parseFloat(expectedPrice);
    this.expect(actualPrice).to.be.within(expectedPrice - expectedPrice * 0.01, expectedPrice + expectedPrice * 0.01);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order|alert) distance away should be correct$/, async function(marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    // const marketId = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getId();
    const marketId = this.idMatcher.market[this.memory.marketName];
    let actualDistance = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getPrice('distance away');
    this.lightstreamer.subscribe(parseInt(marketId));
    let expectedPrice;
    if (this.memory.direction === 'sell') {
      expectedPrice = await this.lightstreamer.addListener('Bid');
      console.log(`sell=${expectedPrice}`);
    } else {
      expectedPrice = await this.lightstreamer.addListener('Offer');
      console.log(`buy=${expectedPrice}`);
    }
    actualDistance = parseFloat(actualDistance);
    expectedPrice = parseFloat(expectedPrice);
    const expectedDistance = parseFloat(this.memory['alert price']) - expectedPrice;
    this.expect(actualDistance).to.be.within(expectedDistance - expectedDistance * 0.05, expectedDistance + expectedDistance * 0.05);
  });

  Then(/^the '(.+)'(?:st|th|nd|rd|) (?:market|position|order|alert) '(date set|expiry)' cell should contain date '(\d+)' (minute|hour|day)?s more than now$/, async function(marketNameOrNumber, cell, count, units) {
    let expectedMS;
    count = parseInt(count);
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getText(cell);
    const multipliers = {
      minute: 60000,
      hour: 60 * 60000,
      day: 24 * 60 * 60000
    };

    if (this.memory.dateSetTime) {
      expectedMS = this.memory.dateSetTime;
    } else {
      expectedMS = parseInt(this.moment().format('x'));
      this.memory.dateSetTime = expectedMS;
    }

    const actualMS = parseInt(this.moment(actualValue, 'DD-MM-YYYY HH:mm').format('x'));
    expectedMS += count * multipliers[units];
    this.expect(actualMS).to.be.within(expectedMS - 240000, expectedMS + 60000);
  });

});
