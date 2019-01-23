/* tslint:disable:max-line-length */
import { defineSupportCode } from 'cucumber';
import { browser } from 'protractor';
import { CurrencySign } from '../../../../support/enums/currency-sign.enum';
import { CurrencyDecimalDigitsEnum } from '../../../../support/enums/currency-decimal-digits.enum';
import * as converter from '../../../../support/utils/currency-converter';
import * as _ from 'lodash';
import { ISOCurrencyEnum } from '../../../../support/enums/iso-currency.enum';

// should recieve 2 objects with top, bottom, left and right properties
const isInside = (obj, rootObj) => {
  let is = true;
  if (obj.top < rootObj.top || obj.bottom > rootObj.bottom || obj.left < rootObj.left || obj.right > rootObj.right) {
    is = false;
  }

  return is;
};

async function getValue(value) {
  if (!isNaN(parseFloat(value))) {
    return value;
  }

  const validValues = {
    sell: async() => {
      let result;

      if (this.memory['oco order price']) {
        result = parseFloat(this.memory['oco order price']);
      } else if (this.memory['order price']) {
        result = parseFloat(this.memory['order price']);
      } else if (this.memory.prices) {
        result = parseFloat(this.memory.prices.sell);
      } else {
        await this.lightstreamer.subscribe(this.memory.marketId);
        result = parseFloat(await this.lightstreamer.addListener('Bid'));
      }

      return result;
    },

    buy: async() => {
      let result;

      if (this.memory['oco order price']) {
        result = parseFloat(this.memory['oco order price']);
      } else if (this.memory['order price']) {
        result = parseFloat(this.memory['order price']);
      } else if (this.memory.prices) {
        result = parseFloat(this.memory.prices.buy);
      } else {
        await this.lightstreamer.subscribe(this.memory.marketId);
        result = parseFloat(await this.lightstreamer.addListener('Offer'));
      }

      return result;
    },

    'current sell': async() => {
      await this.lightstreamer.subscribe(this.memory.marketId);

      return parseFloat(await this.lightstreamer.addListener('Bid'));
    },

    'current buy': async() => {
      await this.lightstreamer.subscribe(this.memory.marketId);

      return parseFloat(await this.lightstreamer.addListener('Offer'));
    },

    'min valid': () => {
      return parseFloat(this.memory.minQuantity);
    },

    'max valid': () => {
      return parseFloat(this.memory.maxQuantity);
    },

    'valid stop price': async() => {
      return await getValidPrice.call(this, 'stop');
    },

    'valid limit price': async() => {
      return await getValidPrice.call(this, 'limit');
    },

    'valid order price': async() => {
      return await calculateValidOrderPrice.call(this);
    },

    'min sizeProperty': () => {
      return parseFloat(this.memory.minSizeProperty);
    },

    'max sizeProperty': () => {
      return parseFloat(this.memory.maxSizeProperty);
    },

    'half of available': async() => {
      return parseFloat(await this.basePage.currentBoard.tabBody.currentPanel.getMaxAvailableQty()) / 2;
    },

    'oco stop price': () => {
      return this.memory[`oco stop price`];
    },

    'oco limit price': () => {
      return this.memory[`oco limit price`];
    },

    'stop price': () => {
      return this.memory[`stop price`];
    },

    'limit price': () => {
      return this.memory[`limit price`];
    },

    'clientPreference quantity': () => {
      return this.memory[`clientPreference quantity`];
    }
  };

  while (value.match(/[A-z\s]+/) && value.match(/[A-z\s]+/)[0].trim()) {
    const pattern = value.match(/[A-z\s]+/)[0].trim();
    const replacement = validValues[pattern] ? await validValues[pattern]() : parseFloat(this.memory[pattern]);

    if (!replacement) {
      console.log(`${pattern} value not exists in the current memory!`);
      break;
    }

    value = value.replace(/[A-z\s]+/, replacement);
  }

  return value ? new Function('', `return ${value};`)() : value;
}

async function calculateValidOrderPrice() {
  let price;
  const marketId = this.memory.marketId;
  const marketInformation = await this.backendHelper.getMarketInformation(marketId);
  const betPer = parseFloat(marketInformation.BetPer);
  const minimumOrderDistance = parseFloat(marketInformation.MinDistance);
  const decimals = marketInformation.PriceDecimalPlaces;

  await this.lightstreamer.subscribe(marketId);
  price = await this.lightstreamer.addListener('Offer');

  return (parseFloat(price) + (minimumOrderDistance * betPer) * 10).toFixed(decimals);
}

async function getValidPrice(type) {
  let price, result;
  const marketId = this.memory.marketId;
  const marketInformation = await this.backendHelper.getMarketInformation(marketId);
  const betPer = parseFloat(marketInformation.BetPer);
  const minimumOrderDistance = parseFloat(marketInformation.MinDistance);
  const decimals = marketInformation.PriceDecimalPlaces;
  const direction = this.memory.direction;

  await this.lightstreamer.subscribe(marketId);
  if ((type === 'stop' && direction === 'buy') || (type === 'limit' && direction === 'sell')) {
    if (this.memory['order price']) {
      price = this.memory['order price'];
    } else {
      price = await this.lightstreamer.addListener('Bid');
    }
    result = (parseFloat(price) - (minimumOrderDistance * betPer) * 3).toFixed(decimals);
  } else {
    if (this.memory['order price']) {
      price = this.memory['order price'];
    } else {
      price = await this.lightstreamer.addListener('Offer');
    }
    result = (parseFloat(price) + (minimumOrderDistance * betPer) * 3).toFixed(decimals);
  }

  return result;
}

defineSupportCode(function({Given, When, Then}) {

  When(/^I fill( main | oco | )'(.+)' with value '(.+)'$/, async function(ticketType, field, value) {
    field = field.toLowerCase();
    const marketId = parseInt(this.memory.marketId);
    const marketInformation = await this.backendHelper.getMarketInformation(marketId);
    const decimals = marketInformation.PriceDecimalPlaces;

    value = parseFloat(await getValue.call(this, value));
    if (field.includes('price')) {
      value = value.toFixed(decimals);
    }
    ticketType = ticketType.trim();
    if (ticketType === 'oco') {
      this.memory[`oco ${field}`] = value;
    } else {
      this.memory[field] = value;
    }

    await this.basePage.currentBoard.tabBody.currentPanel.fillInputWithValue(field, value, ticketType);
  });

  Then(/^filled value '(.+)' in( main | oco | )'(.+)' field should be processed correctly$/, async function(value, ticketType, field) {
    field = field.toLowerCase();
    ticketType = ticketType.trim();

    await this.basePage.currentBoard.tabBody.currentPanel.clearField(field, ticketType);
    await this.basePage.currentBoard.tabBody.currentPanel.fillInputWithValue(field, value, ticketType);
    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue(field);

    const expectedValue = parseInt(value).toLocaleString();
    this.expect(actualValue).to.equal(expectedValue);
  });

  Then(/^filled value '(.+)' in the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' should be processed correctly$/,
    async function(value, ticketType, orderNumber, field) {
    field = field.toLowerCase();
    orderNumber = parseInt(orderNumber) - 1;

    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).clearField(field);
    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).fillInputWithValue(field, value);
    let actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue(field);
    if (field === 'p/l') {
      actualValue = actualValue.replace(/-/g, '');
    }
    const expectedValue = parseInt(value).toLocaleString();
    this.expect(actualValue).to.equal(expectedValue);
  });

  Then(/^'(.+)' should be filled with '(.+)'$/, async function(field, expectedValue) {
    field = field.toLowerCase();

    const actualValue = parseFloat(await this.basePage.currentBoard.tabBody.currentPanel.getInputValue(field));
    expectedValue = parseFloat(expectedValue);

    this.expect(actualValue).to.equal(expectedValue);
  });

  When(/^I click on 1-click '(.+)' in the '(.+)' market$/, async function(field, marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    }
    field = `1-click ${field.toLowerCase()}`;
    await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).click(field);
  });

  When(/^I fill 1-click '(.+)' with value '(.+)' for the '(.+)' market$/, async function(field, value, marketNameOrNumber) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    }
    field = `1-click ${field.toLowerCase()}`;

    value = await getValue.call(this, value);

    this.memory[field] = value;
    await this.basePage.currentBoard.tabBody.currentPanel.getList('Popular Markets').getMarket(marketNameOrNumber).fillInputWithValue(field, value);
  });

  When(/^I remember all quantity sizes for '(.+)' market$/, async function(marketName) {
    let marketId;
    if (marketName === 'current') {
      marketId = parseInt(this.memory.marketId);
    } else if (marketName === 'new') {
      marketId = parseInt(this.memory.newMarketId);
    } else {
      marketId = this.idMatcher.market[marketName];
    }
    const marketInfo = await this.backendHelper.getMarketInformation(marketId);
    this.memory.WebMinSize = marketInfo.WebMinSize;
    this.memory.MaxShortSize = marketInfo.MaxShortSize;
    this.memory.MaxLongSize = marketInfo.MaxLongSize;
    this.memory.minSizeProperty = marketInfo.WebMinSize;
    this.memory.maxSizeProperty = Math.max(marketInfo.MaxShortSize, marketInfo.MaxLongSize);
  });

  When(/^I remember (min|max) valid quantity for '(.+)' market$/, async function(valueType, marketName) {
    let validValue;
    let marketId;
    if (marketName === 'current') {
      marketId = parseInt(this.memory.marketId);
    } else {
      marketId = this.idMatcher.market[marketName];

    }
    const marketInfo = await this.backendHelper.getMarketInformation(marketId);
    if (valueType === 'min') {
      validValue = marketInfo.WebMinSize;
      // validValue = marketInfo.FxFinancing.Quantity;
    } else {
      if (this.memory.direction === 'sell') {
        validValue = marketInfo.MaxShortSize;
      } else {
        validValue = marketInfo.MaxLongSize;
      }
    }
    this.memory[`${valueType}Quantity`] = validValue;
  });

  When(/^I modify( main | oco | )'(.+)' by typing '(.+)' key '(.+)' times$/, async function(ticketType, field, key, times) {
    ticketType = ticketType.trim();
    await this.basePage.currentBoard.tabBody.currentPanel.modifyInputValue(field, key, times, ticketType);
  });

  When(/^I modify( main | oco | )'(.+)' by typing '(.+)' key until the value will be (below|above|equal) '(.+)'$/, async function(ticketType, field, key, expection, value) {
    ticketType = ticketType.trim();
    value = await getValue.call(this, value);
    await this.basePage.currentBoard.tabBody.currentPanel.modifyInputValueByTyping(field, key, expection, value, ticketType);
  });

  When(/^I modify the '(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order filled '(.+)' by typing '(.+)' key until the price will be (below|above) '(.+)' in the '(.+)'$/,
  async function(orderNumber, field, key, expection, value, marketName) {
    if (marketName === 'current market') {
      marketName = this.memory.marketName;
      // this.memory['order price'] = null;
    }
    const marketId = this.memory.marketId ? parseInt(this.memory.marketId) : this.idMatcher.market[marketName];
    const marketInformation = await this.backendHelper.getMarketInformation(marketId);
    const betPer = marketInformation.BetPer;
    const decimals = marketInformation.PriceDecimalPlaces;

    orderNumber = parseInt(orderNumber) - 1;
    value = await getValue.call(this, value);

    if (orderNumber === 0) {
      this.memory['stop price'] = parseFloat(value).toFixed(decimals);
    } else {
      this.memory['limit price'] = parseFloat(value).toFixed(decimals);
    }
    await this.basePage.currentBoard.tabBody.currentPanel.getLinkedOrder(orderNumber).modifyInputValueByTyping(field, key, expection, value, betPer);
  });

  When(/^I modify the '(.+)'(?:st|th|nd|rd|)( main | oco | )(?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' by typing '(.+)' key '(.+)' time(?:|s)$/, async function(orderNumber, ticketType, field, key, times) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).modifyInputValue(field, key, times);
  });

  When(/^I modify the '(.+)'(?:st|th|nd|rd|)( main | oco | )(?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' by typing '(.+)' key until the value will be (below|above|equal) '(.+)'$/,
    async function(orderNumber, ticketType, field, key, expection, value) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    value = parseFloat(value);

    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).modifyInputValueByTyping(field, key, expection, value);
  });

  When(/^I click on the '(.+)'(?:st|th|nd|rd|)( main | oco | )(?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' (?:field|element)$/, async function(orderNumber, ticketType, field) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).click(field);
    // await this.basePage.currentBoard.tabBody.currentPanel.getLinkedOrder(orderNumber).click(field);
  });

  When(/^I fill '(.+)'( main | oco | )price with value between current prices$/, async function(marketName, ticketType) {
    const marketInformation = await this.backendHelper.getMarketInformation(this.idMatcher.market[marketName]);
    const decimals = marketInformation.PriceDecimalPlaces;

    ticketType = ticketType.trim();

    let between =  `(current sell + current buy) / 2`;
    between = (await getValue.call(this, between)).toFixed(decimals);

    if (ticketType === 'oco') {
      this.memory['oco order price'] = between;
    } else {
      this.memory['order price'] = between;
    }

    await this.basePage.currentBoard.tabBody.currentPanel.fillInputWithValue('order price', between, ticketType);
  });

  When(/^I fill '(.+)'( main | oco | )price with value not between current prices on '(.+)'$/, async function(marketName, ticketType, direction) {
    ticketType = ticketType.trim();
    let marketId;
    if (marketName === 'current market') {
      marketName = this.memory.marketName;
      marketId = this.memory.marketId;
    } else {
      marketId = this.idMatcher.market[marketName];
      this.memory.marketName = marketName;
    }

    const marketInformation = await this.backendHelper.getMarketInformation(marketId);
    const decimals = marketInformation.PriceDecimalPlaces;

    const notBetween = direction === 'buy'
      ? (await getValue.call(this, `current sell * 0.99`)).toFixed(decimals)
      : (await getValue.call(this, `current buy * 1.01`)).toFixed(decimals);

    if (ticketType === 'oco') {
      this.memory['oco order price'] = notBetween;
    } else {
      this.memory['order price'] = notBetween;
    }

    await this.basePage.currentBoard.tabBody.currentPanel.fillInputWithValue('order price', notBetween, ticketType);
  });

  When(/^I clear( main | oco | )'(.+)' field$/, async function(ticketType, field) {
    field = field.toLowerCase();
    ticketType = ticketType.trim();
    await this.basePage.currentBoard.tabBody.currentPanel.clearField(field, ticketType);
  });

  When(/^I fill the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' with value '(.+)' in the '(.+)'$/,
  async function(ticketType, orderNumber, field, value, marketName) {
    if (marketName === 'current market') {
      // used in @stop/limit-fields-border-validation and @place-sell-trade-with-multiple-linked-orders-spread-market tests
      marketName = this.memory.marketName;
      // this.memory['order price'] = null;
    }

    const marketId = this.memory.marketId ? parseInt(this.memory.marketId) : this.idMatcher.market[this.memory.marketName];
    const marketInformation = await this.backendHelper.getMarketInformation(marketId);
    const decimals = marketInformation.PriceDecimalPlaces;

    ticketType = ticketType.trim();
    field = field.toLowerCase();
    orderNumber = parseInt(orderNumber) - 1;
    value = await getValue.call(this, value);

    // workaround for bug with different time representation
    if (process.env.npm_config_browser.includes('firefox')) {
      if (typeof value === 'string') {
        if (value.includes('pm')) {
          value = parseInt(value.replace('pm', '')) + 1200;
        } else if (value.includes('am')) {
          value = value.replace('am', '');
        }
      }
    }

    value = parseFloat(value).toFixed(decimals);

    const ticket = ticketType === 'oco' ? 'oco ' : '';
    if (orderNumber === 0 && field === 'price') {
      this.memory[`${ticket}stop price`] = value;
    } else if (orderNumber === 1 && field === 'price') {
      this.memory[`${ticket}limit price`] = value;
    } else if (field === 'quantity') {
      this.memory[`${ticket}${orderNumber} quantity`] = value;
    } else {
      this.memory[`${ticket}${field}`] = value;
    }

    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).fillInputWithValue(field, value);
  });

  When(/^I clear the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' input field$/, async function(ticketType, orderNumber, field) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).clearField(field);
  });

  When(/^I submit the form$/, async function() {
    this.memory.prices = await this.basePage.currentBoard.tabBody.currentPanel.submit();
  });

  When(/^I (?:check|uncheck)( main | oco | )'([Ss]top|[Ll]imit)' checkbox$/, async function(ticketType, name) {
    name = name.toLowerCase();
    const orderNumber = name === 'stop' ? 0 : 1;
    ticketType = ticketType.trim();
    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).checkCheckbox();
  });

  When(/^I click on( main | oco | )'(.+)' (button|label|link|element)( after waiting|)$/, async function(ticketType, name, elementType, isWait) {
    const time = isWait ? 60000 : 2000;
    const method = elementType.charAt(0).toUpperCase() + elementType.slice(1);
    /* if (name === 'ok') {
      await this.basePage.waitLoading();
    } */

    if ((name === 'buy' || name === 'sell') && method === 'Label') {
      this.memory.direction = name;
    }
    await this.basePage.currentBoard.tabBody.currentPanel[`clickOn${method}`](name, ticketType.trim(), time);
  });

  When(/^I expand( main | oco | )add stop limit dropdown$/, async function(ticketType) {
    await this.basePage.currentBoard.tabBody.currentPanel.expandDropdown('add stop limit dropdown link', ticketType.trim());
  });

  When(/^I switch to '([Tt]rade|[Oo]rder|[Ss]et [Aa]lert)' tab$/, async function(itemType) {
    await this.basePage.currentBoard.tabBody.currentPanel.selectItemType(itemType);
  });

  When(/^I remove( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) order$/, async function(orderType, orderNumber) {
    orderType = orderType.trim();
    orderNumber = parseInt(orderNumber) - 1;
    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(orderType, orderNumber).removeLinkedOrder();
  });

  When(/^I expand( main | oco | )'(.+)'(?:st|th|nd|rd|) (applicability|linked order types|date picker) dropdown$/, async function(orderType, orderNumber, dropdownName) {
    orderNumber = parseInt(orderNumber) - 1;
    orderType = orderType.trim();
    await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(orderType, orderNumber).expandDropdown(dropdownName);
  });

  When(/^I expand (?:applicability|[Gg][Tt][Cc]) dropdown$/, async function() {
    await this.basePage.currentBoard.tabBody.currentPanel.expandDropdown('good till dropdown link');
  });

  When(/^I expand( main | oco | )'(.+)' dropdown$/, async function(orderType, dropdownName) {
    orderType = orderType.trim();
    await this.basePage.currentBoard.tabBody.currentPanel.expandDropdown(dropdownName, orderType);
  });

  When(/^I reload page$/, async function() {
    await browser.get(browser.baseUrl);
    await this.helper.alertsReset();
  });

  When(/^I enter current date in '(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order$/, async function(orderNumber) {
    orderNumber = parseInt(orderNumber) - 1;
    await this.basePage.currentBoard.tabBody.currentPanel.getLinkedOrder(orderNumber).selectCurrentDate();
  });

  When(/^I find market with '(.+)' status$/, async function(status) {
    const marketsPool = this.idMatcher[status];
    const statusNum = {
      closed: '4',
      'phone only': '2'
    };

    for (const name in marketsPool) {
      if (marketsPool.hasOwnProperty(name)) {
        this.lightstreamer.subscribe(marketsPool[name]);
        const marketStatus = await this.lightstreamer.addListener('StatusSummary');
        if (marketStatus === statusNum[status]) {
          this.memory[status] = name;
          console.log(`${name} market has closed status`);
          break;
        }
      }
    }
  });

  When(/^I hover (main|oco) order '(.+)' element$/, async function(orderType, elementName) {
    await this.basePage.currentBoard.tabBody.currentPanel.hover(elementName, orderType);
  });

  When(/^I wait confirmation message is displayed within panel$/, async function() {
    await this.basePage.currentBoard.tabBody.currentPanel.waitForConfirmationMessage(60000);
  });

  When(/^I wait for '(.+)' price has trailing zeros$/, async function(type) {
    const state = await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.getPrice(type)
        .then((text) => {
          this.memory.priceWithZeros = text;

          return text.match(/0+$/);
        });
    }, 60000)
      .then(() => true, () => false);

    this.expect(state).to.equal(true);
  });

  Then(/^1-click '(.+)' field( placeholder|) for the '(.+)'( market| market on browse tab| found market) should be filled with ((.+\s)|)'(.*)'$/,
  async function(field, placeholder, marketNameOrNumber, itemType, word, expectedValue) {
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
    } else if (marketNameOrNumber.toLowerCase() === 'new') {
      marketNameOrNumber = this.memory.newMarketName;
    }
    field = `1-click ${field.toLowerCase()}`;

    if (expectedValue === 'previously added') {
      expectedValue = this.memory[field];
    } else {
      expectedValue = await getValue.call(this, expectedValue);
    }

    if (word) {
      expectedValue = word + expectedValue;
    }

    let market;
    if (itemType.includes('on browse tab')) {
      market = await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(marketNameOrNumber, this.memory.marketId);
    } else if (itemType.includes('found')) {
      market = await this.basePage.searchModal.getMarket(marketNameOrNumber, this.memory.marketId);
    } else {
      market = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber, this.memory.marketId);
    }
    this.memory[field] = expectedValue;
    let actualValue;
    if (placeholder) {
      actualValue = await market.getPlaceholder(field);
    } else {
      actualValue = await market.getInputValue(field)
        .then((value) => {
          value = parseFloat(value.replace(/,/g, ''));

          return value ? value : '';
        });
    }

    this.expect(actualValue).to.equal(expectedValue);
  });

  Then(/^1-click '(.+)' field should be removed$/, async function(field) {
    field = `1-click ${field.toLowerCase()}`;
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.getList('Popular Markets').isVisible(field);

    this.expect(actualState).to.equal(false);
  });

  Then(/^max allowed symbols in( main | oco | )'(.+)' field should be '(.+)'$/, async function(ticketType, field, expectedMaxLength) {
    field = field.toLowerCase();
    ticketType = ticketType.trim();
    expectedMaxLength = parseFloat(expectedMaxLength);
    let actualMaxLength = await this.basePage.currentBoard.tabBody.currentPanel.getInputMaxLength(field);
    if (!actualMaxLength) {
      await this.basePage.currentBoard.tabBody.currentPanel.fillInputWithValue(field, '1'.repeat(expectedMaxLength + 1), ticketType);
      const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue(field, ticketType);
      actualMaxLength = actualValue.replace(/,/g, '').length;
    }

    this.expect(actualMaxLength).to.equal(expectedMaxLength);
  });

  When(/^max allowed symbols in the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' should be '(.+)'$/, async function(ticketType, orderNumber, field, expectedMaxLength) {
    expectedMaxLength = parseFloat(expectedMaxLength);
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    await this.basePage.currentBoard.tabBody.currentPanel.getLinkedOrder(orderNumber).fillInputWithValue(field, '1'.repeat(expectedMaxLength + 1), ticketType);
    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getLinkedOrder(orderNumber).getInputValue(field, ticketType);
    const actualMaxLength = actualValue.replace(/,/g, '').length;

    this.expect(actualMaxLength).to.equal(expectedMaxLength);
  });

  Then(/^'(.+)' radiobutton should be '(selected|not selected)'$/, async function(name, isSelected) {
    const expectedCondition = isSelected === 'selected';
    const actualCondition = await this.basePage.currentBoard.tabBody.currentPanel.isRadiobuttonSelected(name);
    this.expect(actualCondition).to.equal(expectedCondition);
  });

  Then(/^the( main | oco | )'([Ss]top|[Ll]imit)' checkbox is (checked|unchecked)$/, async function(ticketType, name, state) {
    name = name.toLowerCase();
    const orderNumber = name === 'stop' ? 0 : 1;
    ticketType = ticketType.trim();
    const currentState = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).isChecked();

    state === 'checked' ? this.expect(currentState).to.equal(true) : this.expect(currentState).to.equal(false);
  });

  Then(/^'(.+)' ticket type should be '(selected|not selected)'$/, async function(name, isSelected) {
    const expectedCondition = isSelected === 'selected';
    const actualCondition = await this.basePage.currentBoard.tabBody.currentPanel.isTypeSelected(name);
    this.expect(actualCondition).to.equal(expectedCondition);
  });

  Then(/^trade confirmation appeared in right places$/, async function() {
    const upConfirmationLocaction = (await this.basePage.currentBoard.tabBody.currentPanel.getLocation('up confirmation')).y;
    const downConfirmationLocaction = (await this.basePage.currentBoard.tabBody.currentPanel.getLocation('down confirmation')).y;
    const marketNameLocaction = (await this.basePage.currentBoard.tabBody.currentPanel.getLocation('market name')).y;
    const actualState = (upConfirmationLocaction < marketNameLocaction) && (marketNameLocaction < downConfirmationLocaction);

    this.expect(actualState).to.equal(true);
  });

  Then(/^(main |oco |)'(.+)' in deal ticket panel should( not|) be displayed$/,
  async function(ticketType, field, expectedState) {
    field = field.toLowerCase();
    ticketType = ticketType.toLowerCase();
    expectedState = expectedState !== ' not';

    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isElementPresent(field, ticketType);
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^'(.+)' input should be predefined with '(.*)'$/, async function(name, expectedValue) {
    let actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue(name);

    if (expectedValue.includes('same')) {
      expectedValue = typeof this.memory[name] === 'string' ? parseFloat(this.memory[name].replace(/\,/, '')) : parseFloat(this.memory[name]);
      actualValue = parseFloat(actualValue.replace(/\,/g, ''));
    } else if (expectedValue !== '') {
      expectedValue = parseFloat(expectedValue.replace(/\,/, ''));

      if (name.includes('price')) {
        expectedValue = expectedValue.toLocaleString(undefined, {minimumFractionDigits: this.memory.marketPriceDemicals});
      } else {
        expectedValue = expectedValue.toLocaleString();
      }

    }
    this.expect(actualValue).to.equal(expectedValue);
  });

  // TODO can be deleted when all features are updated with new steps
  Then(/^'(.+)' input should be autopopulated$/, async function(fieldName) {
    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue(fieldName);
    const expectedValue = new RegExp('\\d+?\\.?\\d*');
    this.expect(actualValue).to.match(expectedValue);
  });

  Then(/^date picker input should be defined with '(\d+)' (minute|hour|day)?s more than now$/, async function(count, units) {
    count = parseInt(count);
    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue('date picker');
    const multipliers = {
      minute: 60000,
      hour: 60 * 60000,
      day: 24 * 60 * 60000
    };
    const actualMS = parseInt(this.moment(actualValue, 'DD-MM-YYYY H:mm A').format('x'));
    const expectedMS = parseInt(this.moment().format('x')) + count * multipliers[units];
    console.log(`actual - ${actualMS}, expected - ${expectedMS} `);
    this.expect(actualMS).to.be.within(expectedMS - 180000, expectedMS + 60000);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order date picker input should be defined with '(\d+)' (minute|hour|day)?s more than now$/, async function(ticketType, orderNumber, count, units) {
    let expectedMS;

    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    count = parseInt(count);

    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('date picker input');
    const multipliers = {
      minute: 60000,
      hour: 60 * 60000,
      day: 24 * 60 * 60000
    };
    const actualMS = parseInt(this.moment(actualValue, 'DD-MM-YYYY H:mm A').format('x'));

    if (this.memory.storedTime) {
      expectedMS = this.memory.storedTime;
    } else {
      expectedMS = parseInt(this.moment().format('x'));
      this.memory.storedTime = expectedMS;
    }
    expectedMS += count * multipliers[units];
    this.expect(actualMS).to.be.within(expectedMS - 180000, expectedMS + 120000);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' input should be (autopopulated|blank|[0-9,.]+)$/, async function(ticketType, orderNumber, name, value) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue(name);
    this.memory[name + orderNumber] = actualValue;

    const expectedValue = value === 'autopopulated' ? new RegExp('\\d+?\\.?\\d*') : new RegExp('^\s*$');
    if (value.match(/[0-9,]+/)) {
      this.expect(actualValue).to.equal(value);
    } else {
      this.expect(actualValue).to.match(expectedValue);
    }
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' input should be rounded correctly$/, async function(ticketType, orderNumber, name) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    const marketInformation = await this.backendHelper.getMarketInformation(this.memory.marketId);
    let expectedDemicals;
    if (name === 'pips/points') {
      expectedDemicals = 1;
    } else if (name === 'price') {
      expectedDemicals = parseInt(marketInformation.PriceDecimalPlaces);
    }
    /* else if (name === 'p/l') { // for using necessary to clarify which property show p/l precision
      expectedDemicals = parseInt(marketInformation.PriceTolerance);
    } */
    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue(name);
    let actualDemicals;
    if (actualValue.includes('.')) {
      actualDemicals = actualValue.replace(/\,/g, '').split('.')[1].length;
    } else {
      actualDemicals = 0;
    }
    this.expect(expectedDemicals).to.equal(actualDemicals);
  });

  Then(/^I store data from the( main | oco | )'(.+)'(?:st|th|nd|rd|) (normal stop|guaranteed stop|trailing stop|limit|) linked order$/,
  async function(ticketType, orderNumber, orderType) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    const orderNumberMemory = (orderNumber === 0 || orderNumber === 1) ? '' : `${orderNumber} `;
    const ticketTypeMemory = (ticketType === 'oco') ? 'oco ' : '';
    const linkedOrderName = `${ticketTypeMemory}${orderNumberMemory}${orderType}`;

    this.memory[linkedOrderName] = {};

    if ((await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).isElementPresent('quantity'))) {
      this.memory[linkedOrderName]['quantity'] = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('quantity');
    }
    if ((await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).isElementPresent('p/l'))) {
      this.memory[linkedOrderName]['p/l'] = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('p/l');
    }
    if ((await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).isElementPresent('price'))) {
      this.memory[linkedOrderName]['price'] = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('price');
    }
    this.memory[linkedOrderName]['pips/points'] = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('pips/points');
   });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' input should be changed$/,
  async function(ticketType, orderNumber, orderType, name) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    const orderNumberMemory = (orderNumber === 0 || orderNumber === 1) ? '' : `${orderNumber} `;
    const ticketTypeMemory = (ticketType === 'oco') ? 'oco ' : '';
    const linkedOrderName = `${ticketTypeMemory}${orderNumberMemory}${orderType}`;
    const previousValue = this.memory[linkedOrderName][name];

    let actualValue;
    await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue(name)
        .then((value) => {
          actualValue = value;

          return actualValue !== previousValue;
        });
    }, 10000);
    this.expect(actualValue).to.not.equal(previousValue);
    this.memory[linkedOrderName][name] = actualValue;
  });

  // INFO: CurrencyDecimalDigitsEnum
  Then(/^the (sell|buy)( main | oco | )'(.+)'(?:st|th|nd|rd|) (stop|guaranteed stop|trailing stop|limit) linked order '(.+)' input should be calculated from '(.+)'$/,
  async function(direction, ticketType, orderNumber, orderType, name, from) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    const marketInformation = this.memory.marketId ? await this.backendHelper.getMarketInformation(this.memory.marketId)
      : await this.backendHelper.getMarketInformation(this.idMatcher.market[this.memory.marketName]);
    const pfd = marketInformation.PointFactorDivisor;
    const qcf = marketInformation.QuantityConversionFactor;
    const betPer = marketInformation.BetPer;
    const trailingStopConversionFactor = marketInformation.TrailingStopConversionFactor || 1;
    const decimals = marketInformation.PriceDecimalPlaces;
    const ccy = marketInformation.MarketSizesCurrencyCode;
    const plDecimals = +CurrencyDecimalDigitsEnum[ccy];
    const qty = this.memory.quantity;
    const price = this.memory['order price'];
    const ccyId = marketInformation.MarketCurrencyId;

    const accountInfo = await this.backendHelper.getClientAndTradingAccount();
    const accountCcy = Number(ISOCurrencyEnum[accountInfo.ClientAccountCurrency]);
    let rates = await this.backendHelper.getAllConversionRates();
    rates = converter.convertRates(rates);

    let currentPrice;
    const lightDir = direction === 'sell' ? 'Bid' : 'Offer';
    let promiseArr = [];
    let actualValue;
    let expectedValue;

    if (ticketType === '') {
      this.lightstreamer.subscribe(this.memory.marketId);
    }

    await browser.wait(() => {
      promiseArr = [];
      if (ticketType === '') {
        promiseArr.push(this.lightstreamer.addListener(lightDir)
        .then((cp) => currentPrice = cp));
      } else {
        currentPrice = price;
      }

      if (name === 'price' && (from === 'points' || from === 'p/l')) {
        promiseArr.push(this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('points')
          .then((points) => expectedValue = this.formulas.calculatePriceFromPoints(currentPrice, pfd, points.replace(/\,/g, ''), betPer, trailingStopConversionFactor, orderType, direction).toFixed(Math.min(marketInformation.PriceDecimalPlaces, 3)))
        );
      } else if (name === 'p/l' && from === 'price') {
        promiseArr.push(this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('price')
          .then((orderPrice) => {
            expectedValue = this.formulas.calculatePLFromPrice(orderPrice.replace(/\,/g, ''), currentPrice.replace(/\,/g, ''), pfd, betPer, qty, qcf, trailingStopConversionFactor, direction, orderType).toFixed(plDecimals);
            if (marketInformation.MarketSettingsType === 'CFD') {
              // convert profitLoss from market currency to account currency
              expectedValue = converter.convert(expectedValue, ccyId, accountCcy, direction, rates).value;
            }
          })
        );
      } else if (name === 'p/l' && from === 'points') {
        promiseArr.push(this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('points')
          .then((points) => {
            const orderPrice = this.formulas.calculatePriceFromPoints(currentPrice.replace(/\,/g, ''), pfd, points.replace(/\,/g, ''), betPer, trailingStopConversionFactor, orderType, direction).toFixed(decimals);
            expectedValue = this.formulas.calculatePLFromPrice(orderPrice, currentPrice.replace(/\,/g, ''),
          pfd, betPer, qty, qcf, trailingStopConversionFactor, direction, orderType).toFixed(plDecimals);
            if (marketInformation.MarketSettingsType === 'CFD') {
              // convert profitLoss from market currency to account currency
              expectedValue = converter.convert(expectedValue, ccyId, accountCcy, direction, rates).value;
            }
          })
        );
      } else if (name === 'points' && from === 'price') {
        promiseArr.push(this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('price')
          .then((orderPrice) => expectedValue = this.formulas.calculatePointsFromPrice(orderPrice.replace(/\,/g, ''), currentPrice.replace(/\,/g, ''), pfd, betPer, trailingStopConversionFactor, direction, orderType).toFixed(decimals))
        );
      } else if (name === 'points' && from === 'p/l') {
        promiseArr.push(this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('p/l')
          .then((pl) => {
            pl = pl.replace(/\,/g, '');
            if (marketInformation.MarketSettingsType === 'CFD') {
              // convert profitLoss from market currency to account currency
              pl = converter.convert(pl.replace(/\,/g, ''), accountCcy, ccyId, direction, rates).value;
            }
            expectedValue = _.round(this.formulas.calculatePointsFromPL(pl, qty, qcf, trailingStopConversionFactor, orderType, direction), decimals);
          })
        );
      }

      promiseArr.push(this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue(name)
          .then((av) => actualValue = av.replace(/\,/g, '')));

      return Promise.all(promiseArr)
        .then(() => {
          return parseFloat(actualValue) === parseFloat(expectedValue);
        });

    }, 20000)
      .then(() => null, () => null);

    expectedValue = parseFloat(expectedValue);
    const validError = Math.abs(expectedValue) * 0.01; // 1%
    this.expect(parseFloat(actualValue)).to.be.within(expectedValue - validError, expectedValue + validError);
  });

  Then(/^'(.+)' should be inside '(.+)' background box$/,
  async function(name, expectedColor) {
    const colors = {
      grey: '238, 238, 238'
    };
    expectedColor = colors[expectedColor];

    const actualColor = await this.basePage.currentBoard.tabBody.currentPanel.getCssValue('background box', '', 'background-color');
    const backgroundPosition = await this.basePage.currentBoard.tabBody.currentPanel.getElementPosition('background box');
    const elementPosition = await this.basePage.currentBoard.tabBody.currentPanel.getElementPosition(name);
    const actualState = isInside(elementPosition, backgroundPosition);

    this.expect(actualColor).to.include(expectedColor);
    this.expect(actualState).to.equal(true);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (normal stop|guaranteed stop|trailing stop|limit|) linked order '(.+)' input should be '(.*)'/,
    async function(ticketType, orderNumber, orderType, name, expectedValue) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    const orderNumberMemory = (orderNumber === 0 || orderNumber === 1) ? '' : `${orderNumber} `;
    const ticketTypeMemory = (ticketType === 'oco') ? 'oco ' : '';
    const linkedOrderName = `${ticketTypeMemory}${orderNumberMemory}${orderType}`;
    const marketInformation = await this.backendHelper.getMarketInformation(this.memory.marketId);

    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue(name);
    if (expectedValue === 'correct') {
      expectedValue = this.memory[linkedOrderName][name];
    } else if (expectedValue.match(/(price|pips\/points|p\/l)(\+|\*|-)\d+?\.?\d*/)) {
      const type = expectedValue.split(/(\+|\*|-)/)[0].split(/\s/)[0];
      const multiplier = expectedValue.split(/(\+|\*|-)/)[2];
      const operation = expectedValue.split(/(\+|\*|-)/)[1];
      expectedValue = new Function('', `return ${parseFloat(this.memory[linkedOrderName][`${type}`])} ${operation} ${parseFloat(multiplier)};`)();
      const demicals = {
        price: parseInt(marketInformation.PriceDecimalPlaces),
        'pips/points': 1,
        'p/l': 1
      };
      expectedValue = expectedValue.toLocaleString(undefined, { minimumFractionDigits: demicals[type]});
      this.memory[linkedOrderName][`${type}`] = expectedValue;
    } else {
      expectedValue = (await getValue.call(this, expectedValue)).toLocaleString();
    }
    if (actualValue !== expectedValue) {
      this.expect(parseFloat(actualValue)).to.equal(parseFloat(expectedValue));
    } else {
      this.expect(actualValue).to.equal(expectedValue);
    }
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' should be displayed and fit the ticket width$/,
  async function(ticketType, orderNumber, field) {
    field = field.toLowerCase();
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    const isDisplayed = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).isElementPresent(field);

    const rowPosition = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getElementPosition('root');
    const fieldPosition = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getElementPosition(field);
    const actualState = isInside(fieldPosition, rowPosition);

    this.expect(isDisplayed).to.equal(true);
    this.expect(actualState).to.equal(true);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' should be filled with '(.*)'$/,
  async function(ticketType, orderNumber, field,  expectedValue) {
    field = field.toLowerCase();
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    if (expectedValue === 'same') {
      expectedValue = this.memory[field + orderNumber];
    }

    let actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue(field);
    if (actualValue === expectedValue) {
      this.expect(actualValue).to.equal(expectedValue);
    } else {
      expectedValue = parseFloat(expectedValue);
      actualValue = parseFloat(actualValue);
      this.expect(actualValue).to.equal(expectedValue);
    }
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' should be colored grey$/,
  async function(ticketType, orderNumber, field) {
    const colors = {
      grey: '209, 209, 209'
    };
    field = field.toLowerCase();
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    const actualColor = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getCssValue(field, 'color');
    const expectedColor = colors['grey'];

    this.expect(actualColor).to.include(expectedColor);
  });

  Then(/^(main |oco |)'(.+)' element text should (contain|be) '(.+)'$/, async function(ticketType, name, comparisonType, expectedText) {
    if (expectedText.includes('current market')) {
      expectedText = this.memory.marketName;
    }
    expectedText = expectedText.toLowerCase();

    if (name.match(/(limit|stop) validation/) && expectedText === 'correct') {
      expectedText = `too low. minimum ${this.memory.minQuantity}`;
    }

    let text: string;
    let actualText: string;
    await browser.wait(async() => {
      text = await this.basePage.currentBoard.tabBody.currentPanel.getElementText(name, ticketType)
        .then((textAct) => textAct, () => '');
      actualText = text.replace(/ *\n */g, ' ').toLowerCase();
      if (comparisonType === 'contain') {
        return this.helper.sleepIfFalse(actualText.includes(expectedText), 2000);
      } else {
        return this.helper.sleepIfFalse(actualText === expectedText, 200);
      }
    }, 10000)
      .then(() => null, () => null);

    if (comparisonType === 'contain') {
      this.expect(actualText).to.include(expectedText);
    } else {
      this.expect(actualText).to.equal(expectedText);
    }
  });

  Then(/^(?:|partially )close info message should be correct$/, async function() {
    let closeQuantity = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue('close quantity');
    closeQuantity = parseFloat(closeQuantity.replace(/\,/g, ''));

    // this.memory.leftQuantity is set only in this step
    // set in step: And the 'previously added' market 'position' cell should contain 'updated' data
    // when we use this step several time in scenario this.memory.leftQuantity can be equal 0
    if (this.memory.leftQuantity && this.memory.leftQuantity !== '0') {
       this.memory.quantity = `${this.memory.leftQuantity}`.replace(/\,/g, '');
    }
    const leftQuantity = (parseFloat(`${this.memory.quantity}`.replace(/\,/g, '')) - closeQuantity).toLocaleString();
    this.memory.leftQuantity = leftQuantity;

    const expectedPattern =
      new RegExp(`Close ${closeQuantity.toLocaleString()} of ${parseFloat(this.memory.quantity).toLocaleString()} at \\d+?\\.?\\d* Leaving a position of ${leftQuantity}`);
    let text: string;
    let actualText: string;
    await browser.wait(async() => {
      text = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('close info');
      actualText = text.replace(/\s+/g, ' ');

      return this.helper.sleepIfFalse(!!actualText.match(expectedPattern), 500);
    }, 10000).then(() => null, () => null);

    text = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('close info');
    actualText = await text.replace(/\s+/g, ' ');

    this.expect(actualText).to.match(expectedPattern);
  });

  Then(/^amalgamated position close info message should be correct( after changing|)$/, async function(isChanged) {
    let closeQuantity = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue('close quantity');
    closeQuantity = parseFloat(closeQuantity.replace(/,/g, ''));
    let actualText;
    let leftAmalgamatedQty;
    let amalgamatedQty;
    if (isChanged) {
      amalgamatedQty = this.memory.leftAmalgamatedQty;
      leftAmalgamatedQty = this.memory.leftAmalgamatedQty - closeQuantity;
      this.memory.leftAmalgamatedQty = leftAmalgamatedQty;
    } else {
      amalgamatedQty = this.memory.amalgamatedQty;
      leftAmalgamatedQty = this.memory.amalgamatedQty - closeQuantity;
      this.memory.leftAmalgamatedQty = leftAmalgamatedQty;
    }
    const expectedPattern = new RegExp(`Close ${closeQuantity.toLocaleString()} of ${amalgamatedQty.toLocaleString()} at \\d+?\\.?\\d* Leaving a position of ${leftAmalgamatedQty}`);
    await browser.wait(async() => {
      actualText = (await this.basePage.currentBoard.tabBody.currentPanel.getElementText('close info')).replace(/\s+/g, ' ');

      return this.helper.sleepIfFalse(!!actualText.match(expectedPattern), 500);
    }, 10000).then(() => null, () => null);
    this.expect(actualText).to.match(expectedPattern);
  });

  Then(/^current (simple|amalgamated) position information should be correct$/, async function(positionType) {
    const text = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('position info');
    const actualText = text.replace(/\s+/g, ' ').toLowerCase();

    const expectedPattern = positionType === 'simple' ? new RegExp(`position ${this.memory.direction.toLowerCase()} ${parseInt(this.memory.quantity).toLocaleString()} at \\d+?\\.?\\d* -?\\d+?\\.?\\d* gbp`)
                                                : new RegExp(`position ${this.memory.direction.toLowerCase()} ${parseInt(this.memory.amalgamatedQty).toLocaleString()} at \\d+?\\.?\\d* -?\\d+?\\.?\\d* gbp`);
    this.expect(actualText).to.match(expectedPattern);
  });

  Then(/^(?:'(trade|order|oco order|set alert incorrect time|set alert)' |)confirmation message should be correct$/, async function(ticketType) {
    const text = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('confirmation message');
    const actualText = text.replace(/\s+/g, ' ');
    let expectedPattern;
    if (!ticketType || ticketType === 'trade') {
      expectedPattern = new RegExp(`Closed: (Buy|Sell) `
        + `${this.memory.quantity} at \\d+\\.?\\d*`
        + ` You (lost|made) \\d+\\.?\\d* GBP on this trade`);
    } else if (ticketType === 'oco order') {
      expectedPattern = new RegExp(`Order added to (Buy|Sell) \\d+\\.?\\d* at \\d+\\.?\\d* ?`
        + `(Attached stop order added to (Buy|Sell) \\d+\\.?\\d* at \\d+\\.?\\d* \\(-?\\d+\\.?\\d* [A-Z]{3}\\)|) ?`
        + `(Attached limit order added to (Buy|Sell) \\d+\\.?\\d* at \\d+\\.?\\d* \\(-?\\d+\\.?\\d* [A-Z]{3}\\)|) ?`
        + `OCO Order added to (Buy|Sell) \\d+\\.?\\d* at \\d+\\.?\\d* ?`
        + `(Attached stop order added to (Buy|Sell) \\d+\\.?\\d* at \\d+\\.?\\d* \\(-?\\d+\\.?\\d* [A-Z]{3}\\)|) ?`
        + `(Attached limit order added to (Buy|Sell) \\d+\\.?\\d* at \\d+\\.?\\d* \\(-?\\d+\\.?\\d* [A-Z]{3}\\)|)`);
    } else if (ticketType === 'set alert incorrect time') {
      expectedPattern = new RegExp(`ExpiryDate should be greater than UTC now.`);
    } else if (ticketType === 'set alert') {
      expectedPattern = new RegExp(`(Buy|Sell) alert at \\d+\\.?\\d*`);
    }

    this.expect(actualText).to.match(expectedPattern);
  });

  Then(/^'(.+)' confirmation messages about close amalgamated positions should be displayed$/, async function(positions) {
    positions = parseInt(positions);
    const closeQuantity = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue('close quantity');
    let dif = closeQuantity;
    let closed = 0;
    for (let n = 0; n < positions; n++) {
      const text = await this.basePage.currentBoard.tabBody.currentPanel.getElementText(`confirmation message ${n + 1}`);
      const actualText = text.replace(/\s+/g, ' ');
      const qty = dif - this.memory.qtyArray[n] > 0 ? this.memory.qtyArray[n] : dif;

      if (dif - this.memory.qtyArray[n] > 0) {
        closed++;
      } else {
        this.memory.qtyArray[n] = this.memory.qtyArray[n] - dif;
      }

      dif = dif - this.memory.qtyArray[n];

      const expectedPattern = new RegExp(`Closed: (Buy|Sell) `
        + `${qty} at \\d+?\\.?\\d*`
        + ` You (lost|made) \\d+?\\.?\\d* GBP on this trade`);
      let actualCondition = false;
      if (actualText.match(expectedPattern)) {
          actualCondition = true;
      }
      this.memory.amalgamatedQty = this.memory.amalgamatedQty - closeQuantity;

      this.expect(actualCondition).to.equal(true);
    }

    if (closed !== 0) {
      this.memory.qtyArray = this.memory.qtyArray.splice(0, closed);
    }
  });

  Then(/^correct confirmation message about (adding|removing) '(.+)' (?:linked orders|order) should be displayed$/, async function(action, orders) {
    const removingMessage = orders === 'OCO' ? ' You have deleted your OCO order.' : ' Your (OCO Order |)attached (Stop|Limit) has been deleted.';
    if (orders === 'OCO') {
      orders = 1;
    } else {
      orders = parseInt(orders);
    }
    const text = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('confirmation message');
    const actualText = text.replace(/\s+/g, ' ');
    const pattern = 'Your order has been updated.';
    let expectedMessage = '';
    const message = action === 'adding' ? ' You have successfully added an order. Your order is confirmed with Order ID \\d{9}.' : removingMessage;
    for (let n = 0; n < orders; n++) {
      expectedMessage = expectedMessage + message;
    }

    const expectedPattern = new RegExp(`^${pattern}${expectedMessage}$`);
    console.log(actualText);
    console.log(expectedPattern);
    let actualCondition = false;
      if (actualText.match(expectedPattern)) {
          actualCondition = true;
      }

    this.expect(actualCondition).to.equal(true);
  });


  Then(/^partially close confirmation message should be correct$/, async function() {
    const text = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('confirmation message');
    const actualText = text.replace(/\s+/g, ' ');
    // temporary solution - https://jira.gaincapital.com/browse/TPDWT-14948 - will be implemented
    const expectedPattern = new RegExp(`Closed: (Buy|Sell) `
      + `${this.memory.leftQuantity.replace(/\,/g, '')} at \\d+?\\.?\\d*`
      + ` You (lost|made) \\d+?\\.?\\d* GBP on this trade`);
    this.expect(actualText).to.match(expectedPattern);
  });

  Then(/^open ([Bb]uy|[Ss]ell) '(.+)' (trade|order)( without stops and limits|) confirmation message should be correct$/,
  async function(direction, marketName, tradeOrOrder, notUsingStopsAndLimits) {
    const text = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('confirmation message');
    const actualText = text.replace(/\s+/g, ' ');

    const point = direction.match(/[Bb]uy/) ? 'Sell' : 'Buy';
    const stopPrice = await this.basePage.currentBoard.tabBody.currentPanel.getLinkedOrder(0).getInputValue('price');
    let stopProfitLoss = await this.basePage.currentBoard.tabBody.currentPanel.getLinkedOrder(0).getInputValue('p/l');
    // temporary solution - https://jira.gaincapital.com/browse/TPDWT-14948 - will be implemented
    stopProfitLoss = stopProfitLoss.replace(/,/g, '');

    const limitPrice = await this.basePage.currentBoard.tabBody.currentPanel.getLinkedOrder(1).getInputValue('price');
    let limitProfitLoss = await this.basePage.currentBoard.tabBody.currentPanel.getLinkedOrder(1).getInputValue('p/l');
    // temporary solution - https://jira.gaincapital.com/browse/TPDWT-14948 - will be implemented
    limitProfitLoss = limitProfitLoss.replace(/,/g, '');

    if (marketName.includes('current')) {
      marketName = this.memory.marketName;
    }

    const accountInfo = await this.backendHelper.getClientAndTradingAccount();
    const ccy = accountInfo.ClientAccountCurrency;

    if (marketName === 'current market') {
      marketName = this.memory.marketName;
    }
    const marketId = this.memory.marketId ? parseInt(this.memory.marketId) : this.idMatcher.market[marketName];
    const marketInfo = await this.backendHelper.getMarketInformation(marketId);
    const decimals = marketInfo.PriceDecimalPlaces;

    // stopPrice = parseFloat(stopPrice).toFixed(decimals);
    // limitPrice = parseFloat(limitPrice).toFixed(decimals);
    this.memory.quantity = parseFloat(this.memory.quantity);

    const stringStartFrom = tradeOrOrder === 'trade' ? 'Opened:' : 'Order added to';

    let expectedPattern;
    if (notUsingStopsAndLimits) {
      expectedPattern = new RegExp(`${stringStartFrom} ${direction.charAt(0).toUpperCase() + direction.slice(1)} `
      + `${this.memory.quantity} at \\d*\\,*\\d*\\.*\\d*`);
    } else {
      expectedPattern = new RegExp(`${stringStartFrom} ${direction.charAt(0).toUpperCase() + direction.slice(1)} `
        + `${this.memory.quantity} at \\d*\\,*\\d*\\.*\\d* `
        + `Attached stop order added to ${point} `
        + `${this.memory.quantity} at ${stopPrice}`
        + ` \\(${stopProfitLoss} ${ccy}\\) `
        + `Attached limit order added to ${point} `
        + `${this.memory.quantity} at ${limitPrice}`
        + ` \\(${limitProfitLoss} ${ccy}\\)`);
    }

    this.expect(actualText).to.match(expectedPattern);
  });

  // use when there are multiple linked orders on main and oco DT
  // use memory state filled in "I store data from the( main | oco | )' .."
  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (normal stop|guaranteed stop|trailing stop|limit) linked order confirmation message should be correct$/,
    async function(ticketType, orderNumber, orderType) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    let expectedPattern;

    const actualText = await this.basePage.currentBoard.tabBody.currentPanel.getConfirmationMessage(orderNumber, ticketType);

    const point = this.memory.direction === 'buy' ? 'Sell' : 'Buy';
    const orderNumberMemory = (orderNumber === 0 || orderNumber === 1) ? '' : `${orderNumber} `;
    const ticketTypeMemory = ticketType === 'oco' ? 'oco ' : '';
    let quantity = this.memory[`${ticketTypeMemory}${orderNumberMemory}${orderType}`].quantity;
    quantity = parseFloat(quantity.replace(/\,/g, ''));

    const price = this.memory[`${ticketTypeMemory}${orderNumberMemory}${orderType}`].price;
    const accountInfo = await this.backendHelper.getClientAndTradingAccount();
    const ccy = accountInfo.ClientAccountCurrency;

      if (orderType === 'limit') {
        expectedPattern = new RegExp(`Attached limit order added to ${point} ${quantity} at ${price} \\((\\-|)\\d*\\.?\\d* ${ccy}\\)`);
      } else if (orderType === 'trailing stop') {
        expectedPattern = new RegExp(/^Attached stop order added to (Buy|Sell) (\d+.?\d*) at (\d+,?\d*?.?\d*) \((\-|)(\d+.?\d*) ([A-Z]{3})\)$/);
      } else {
        expectedPattern = new RegExp(`Attached stop order added to ${point} ${quantity} at ${price} \\((\\-|)(\\d+\\.?\\d*) ${ccy}\\)`);
      }

    this.expect(actualText).to.match(expectedPattern);
  });

  Then(/^open (?:buy|sell) confirmation message should be displayed correctly$/, async function() {
    const actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('confirmation message');
    const expectedMessage = new RegExp(`Opened: (Buy|Sell) \\d+?\\.?\\d* at \\d+?\\.?\\d*`);
    this.expect(actualMessage).to.match(expectedMessage);
  });

  Then(/^open '(.+)' (?:buy|sell)( | main | oco )attached (trailing stop|guaranteed|stop|limit) order confirmation message should be displayed correctly$/, async function(marketName, ticketType, orderType) {
    const actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('attached order confirmation');
    const expectedMessage = new RegExp(/^Attached stop order added to (Buy|Sell) (\d+.?\d*) at (\d+,?\d*?.?\d*) \((\-|)(\d+.?\d*) ([A-Z]{3})\)$/);

    const stopPrice = actualMessage.split('at ')[1].split(/\s/)[0];
    ticketType = ticketType.trim();
    const ticket = ticketType === 'oco' ? 'oco ' : '';
    if (orderType === 'stop' || orderType === 'trailing stop' || orderType === 'guaranteed') {
      this.memory[`${ticket}stop price`] = stopPrice;
    } else {
      this.memory[`${ticket}limit price`] = stopPrice;
    }

    this.expect(actualMessage).to.match(expectedMessage);
  });

  Then(/^(main |oco |)trade direction should be '(buy|sell)'$/, async function(ticketType, expectedDirection) {
    ticketType = ticketType.trim();
    const actualDirection = await this.basePage.currentBoard.tabBody.currentPanel.getDirection(ticketType);
    this.expect(actualDirection).to.equal(expectedDirection);
  });

  Then(/^'(.+)' price should change with time$/, async function(type) {
    const data = await this.basePage.currentBoard.tabBody.currentPanel.getPrice(type);
    const state = await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.getPrice(type)
        .then((text) => this.helper.sleepIfFalse(text !== data, 1000));
    }, 60000)
      .then(() => true, () => false);
    this.expect(state).to.equal(true);
  });

  Then(/^(main |oco |)'(.+)' input should be editable$/, async function(ticketType, name) {
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isElementEnabled(name, ticketType);
    this.expect(actualState).to.equal(true);
  });

  Then(/^the (main|oco|)'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' value should change with time$/,
  async function(ticketType, orderNumber, field) {
    orderNumber = parseInt(orderNumber) - 1;
    const currentValue = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue(field);

    const state = await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue(field)
        .then((value) => this.helper.sleepIfFalse(value !== currentValue, 300));
    }, 20000)
      .then(() => true, () => false);
    this.expect(state).to.equal(true);
  });

  Then(/^(main |oco |)'(.+)' element should be (disabled|enabled)( on the not active DT panel|)$/,
  async function(ticketType, name, status, panelName) {
    ticketType = ticketType.toLowerCase();
    let actualState;
    if (panelName.includes('not active DT')) {
      actualState = await this.basePage.currentBoard.tabBody.getPanel('deal ticket').isControlDisabled(name, ticketType);
    } else {
      actualState = await this.basePage.currentBoard.tabBody.currentPanel.isControlDisabled(name, ticketType);
    }
    const expectedState = status === 'disabled';
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^'(.+)' element should be colored '(.+)'$/, async function(name, expectedColor) {
    const colors = {
      green: '79, 180, 107',
      grey: '238, 238, 238'
    };

    const actualColor = await this.basePage.currentBoard.tabBody.currentPanel.getCssValue(name, '', 'background-color');
    expectedColor = colors[expectedColor.toLowerCase()];
    this.expect(actualColor).to.include(expectedColor);
  });

  Then(/^'(.+)' '(.+)' placeholder should be correct$/, async function(marketName, field) {
    let marketId;
    if (marketName.includes('current')) {
      marketId = this.memory.marketId;
    } else {
      marketId = this.idMatcher.market[marketName];
    }
    const marketInformation = await this.backendHelper.getMarketInformation(marketId);
    const size = marketInformation.WebMinSize;
    const actualPlaceholder = await this.basePage.currentBoard.tabBody.currentPanel.getPlaceholder(field);
    const expectedPlaceholder = `min. ${size}`;
    this.expect(actualPlaceholder).to.equal(expectedPlaceholder);
  });

  Then(/^the (main|oco|)'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' placeholder should be correct$/, async function(ticketType, orderNumber, field) {
    orderNumber = parseInt(orderNumber) - 1;
    let expectedPlaceholder;
    if (field === 'price') {
      expectedPlaceholder = `price`;
    } else if (field === 'pips/points') {
      const marketInformation = await this.backendHelper.getMarketInformation(this.memory.marketId);
      // market with marketInformation.FxFinancing === null, has 'point' input
      if (!marketInformation.FxFinancing) {
        expectedPlaceholder = `points`;
      } else {
        expectedPlaceholder = `pips`;
      }
    } else if (field === 'p/l') {
      expectedPlaceholder = `P/L`;
    }

    const actualPlaceholder = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getPlaceholder(field);
    this.expect(actualPlaceholder).to.equal(expectedPlaceholder);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' element should be (enabled|disabled)$/,
  async function(ticketType, orderNumber, field, state) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).isElementEnabled(field);
    const expectedState = state === 'enabled';
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^the '(.+)'( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order p\/l (currency sign|value) should be correct$/,
  async function(marketName, ticketType, orderNumber, value) {
    ticketType = ticketType.trim();
    orderNumber = parseInt(orderNumber) - 1;
    let marketId;
    if (marketName === 'current market') {
      marketId = this.memory.marketId;
    } else {
      marketId = this.idMatcher.market[marketName];
    }
    const marketInformation = await this.backendHelper.getMarketInformation(marketId);
    const ccy = marketInformation.MarketSizesCurrencyCode;
    const ccyId = marketInformation.MarketCurrencyId;
    let expectedPlaceholder = CurrencySign[ccy];
    let demicals = parseFloat(CurrencyDecimalDigitsEnum[ccy]);
    const linkedOrderPrice = (await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('price')).replace(/\,/g, '');

    let linkedOrderQty;
    const is = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).isElementPresent('quantity');
    linkedOrderQty = is ? (await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('quantity')).replace(/\,/g, '')
                        : this.memory.quantity;

    let expectedValue: any;
    expectedValue = this.memory.direction === 'buy' ? (linkedOrderPrice - parseFloat(this.memory['order price'])) * linkedOrderQty / parseFloat(marketInformation.BetPer)
                                                    : -(linkedOrderPrice - parseFloat(this.memory['order price'])) * linkedOrderQty / parseFloat(marketInformation.BetPer);

    console.log(`market type: ${marketInformation.MarketSettingsType}`);
    if (marketInformation.MarketSettingsType === 'CFD') {
      const accountInfo = await this.backendHelper.getClientAndTradingAccount();
      const accountCcy = Number(ISOCurrencyEnum[accountInfo.ClientAccountCurrency]);
      expectedPlaceholder = CurrencySign[accountInfo.ClientAccountCurrency];

      let rates = await this.backendHelper.getAllConversionRates();
      rates = converter.convertRates(rates);
      demicals = parseFloat(CurrencyDecimalDigitsEnum[accountInfo.ClientAccountCurrency]);
      expectedValue = converter.convert(expectedValue, ccyId, accountCcy, this.memory.direction, rates).value;
    }
    expectedValue = _.round(expectedValue, demicals);
    const validError = _.round(Math.abs(expectedValue) * 0.03, demicals); // 3%

    if (value === 'currency sign') {
      const actualPlaceholder = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('ccy');
      this.expect(actualPlaceholder).to.equal(expectedPlaceholder);
    } else {
      const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('p/l');
      this.expect(parseFloat(actualValue.replace(/\,/g, ''))).to.be.within(expectedValue - validError, expectedValue + validError);
    }
  });

  Then(/^the (?:trade|order|edit) ticket (?:standard|advanced) view panel (should|should not) contain items:$/, async function(state, table) {
    const itemNames = table.hashes().map((el) => {
      return el.itemName;
    });

    for (let i = 0; i < itemNames.length; i++) {
      let actualState;
      if (itemNames[i].includes('tick') && state === 'should') {

        actualState = await browser.wait(() => {
          return this.basePage.currentBoard.tabBody.currentPanel.isElementPresent(itemNames[i])
            .then((is) => this.helper.sleepIfFalse(is, 1000));
        }, 10000)
          .then(() => true, () => false);
      } else {
        actualState = state === 'should' ? await this.basePage.currentBoard.tabBody.currentPanel.isElementPresent(itemNames[i])
          : await this.basePage.currentBoard.tabBody.currentPanel.isElementPresent(itemNames[i], '', false);
      }
      state === 'should' ? this.expect(actualState).to.equal(true) : this.expect(actualState).to.equal(false);
    }
  });

  Then(/^the '(.+)' order area should contain items:$/, async function(orderType, table) {
    const itemNames = table.hashes().map((el) => {
      return el.itemName;
    });

    for (let i = 0; i < itemNames.length; i++) {
      const actualState = orderType === 'main'
        ? await this.basePage.currentBoard.tabBody.currentPanel.isElementPresent(itemNames[i], 'main')
        : await this.basePage.currentBoard.tabBody.currentPanel.isElementPresent(itemNames[i], 'oco');
      this.expect(actualState).to.equal(true);
    }
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) order (should|should not) contain fields:$/, async function(ticketType, orderNumber, state, table) {
    const itemNames = table.hashes().map((el) => {
      return el.itemName;
    });
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    for (let i = 0; i < itemNames.length; i++) {
      const actualState = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).isElementPresent(itemNames[i]);
      state === 'should' ? this.expect(actualState).to.equal(true) : this.expect(actualState).to.equal(false);
    }
  });

// not sure about moving it to dropdown-steps.ts
  Then(/^add a stop or limit dropdown from (trade|order) tab contains correct items$/, async function(location) {
    let actualItems = await this.basePage.dropdown.getOptions();
    actualItems = actualItems.map(text => text.replace(/\s+/g, ' '));

    let expectedItems = [];
    const marketInfo = await this.backendHelper.getMarketInformation(parseInt(this.memory.marketId));
    if (location === 'trade' && marketInfo.AllowGuaranteedOrders) {
      console.log(`AllowGuaranteedOrders: ${marketInfo.AllowGuaranteedOrders} for market`);
      expectedItems = ['Normal stop', 'Trailing stop', 'Guaranteed stop If triggered, charge is 4 times the quantity', 'Limit'];
    } else {
      expectedItems = ['Normal stop', 'Trailing stop', 'Limit'];
    }

    this.expect(actualItems.map(i => i.toLowerCase())).to.deep.equal(expectedItems.map(i => i.toLowerCase()));
  });

  Then(/^the number of( main | oco | )linked orders should be '(.+)'$/, async function(ticketType, orderNumber) {
    ticketType = ticketType.trim();
    const actualNumber = await this.basePage.currentBoard.tabBody.currentPanel.getNumberOfLinkedOrders(ticketType);
    const expectedNumber = parseInt(orderNumber);

    this.expect(actualNumber).to.deep.equal(expectedNumber);
  });

  Then(/^'(.+)'(?:st|th|nd|rd|) option should be selected in (main |oco |)'(.+)'(?:st|th|nd|rd|) (?:applicability|[Gg][Tt][Cc]) dropdown$/, async function(nameOrNumber, ticketType, orderNumber) {
    ticketType = ticketType.trim();
    orderNumber = parseInt(orderNumber) - 1;
    const actualApplicability = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getInputValue('applicability');
    const expectedApplicability = nameOrNumber;

    if (typeof expectedApplicability === 'number') {
      this.expect(this.OrderApplicabilityEnum[actualApplicability].to.equal(expectedApplicability));
    }

    this.expect(actualApplicability).to.equal(expectedApplicability);
  });

  Then(/^'(.+)'(?:st|th|nd|rd|) option should be selected in (main|oco) (?:applicability|[Gg][Tt][Cc]) dropdown$/, async function(nameOrNumber, ticketType) {
    const actualApplicability = await this.basePage.currentBoard.tabBody.currentPanel.getElementText(`${ticketType} good till dropdown`);
    const expectedApplicability = nameOrNumber;

    if (typeof expectedApplicability === 'number') {
      this.expect(this.OrderApplicabilityEnum[actualApplicability].to.equal(expectedApplicability));
    }

    this.expect(actualApplicability).to.include(expectedApplicability);
  });

  Then(/^(trade|order|oco) ticket '(.+)' element is (visible|not visible)$/, async function(ticketType, element, visibility) {
    const expectedState = visibility === 'visible';
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isElementVisible(ticketType, element);
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^(main |oco |)'(.+)' input value is '(.+)'$/, async function(ticketType, field, value) {
    let expectedValue;
    ticketType = ticketType.trim();
    field = field.toLowerCase();
    if (value === 'correct') {
      if (ticketType === 'oco') {
        expectedValue = this.memory[`oco ${field}`];
      } else {
        expectedValue = this.memory[field];
      }
    }
    expectedValue = parseFloat(expectedValue).toLocaleString();

    const actualValue = parseFloat((await this.basePage.currentBoard.tabBody.currentPanel.getInputValue(field, ticketType)).replace(/,/, '')).toLocaleString();
    this.expect(actualValue).to.equal(expectedValue);
  });

  Then(/^'(.+)'( main | oco | )order '(.+)' validation should be correct( and should not appear for '(.+)'ms|)$/, async function(marketName, ticketType, field, expectedTimeout) {
    let marketId;
    if (marketName === 'current market') {
      marketId = parseInt(this.memory.marketId);
    } else {
      marketId = this.idMatcher.market[marketName];
    }
    const marketInformation = await this.backendHelper.getMarketInformation(marketId);

    let expectedText;
    let expectedNumber;
    let actualNumber;
    let actualMessage;
    function stopwatch(start?) {
      if (!start) {
        return process.hrtime();
      }
      const end = process.hrtime(start);

      return Math.round((end[0] * 1000) + (end[1] / 1000000));
    }
    let actualTimeout = stopwatch();

    ticketType = ticketType.trim();
    this.lightstreamer.subscribe(this.idMatcher.market[marketName]);

    if (field === 'sell price') {
      expectedNumber = await this.lightstreamer.addListener('Offer');
      expectedText = `Сannot be less than or equal to`;
      await browser.wait(async() => {
        actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getValidationMessage(ticketType, 'price');

        return !!actualMessage;
      }, 3000);
      actualNumber = actualMessage.match(/\d+,?\d*.?\d*/)[0];
    } else if (field === 'buy price') {
      expectedNumber = await this.lightstreamer.addListener('Bid');
      expectedText = `Сannot be more than or equal to`;
      await browser.wait(async() => {
        actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getValidationMessage(ticketType, 'price');

        return !!actualMessage;
      }, 3000);
      actualNumber = actualMessage.match(/\d+,?\d*.?\d*/)[0];
    } else if (field === 'min quantity') {
      expectedNumber = marketInformation.WebMinSize;
      expectedText = `Too low. Minimum`;
      await browser.wait(async() => {
        actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getValidationMessage(ticketType, 'quantity');

        return !!actualMessage;
      }, 3000);
      actualNumber = actualMessage.match(/\d+,?\d*.?\d*/)[0];
    } else if (field === 'max quantity') {
      expectedNumber = marketInformation.MaxLongSize;
      expectedText = `Too high. Maximum`;
      await browser.wait(async() => {
        actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getValidationMessage(ticketType, 'quantity');

        return !!actualMessage;
      }, 3000);
      actualNumber = actualMessage.match(/\d+,?\d*.?\d*/)[0];
    } else if (field === 'between price') {
      expectedText = 'Price must not be between the buy and sell price';
      await browser.wait(async() => {
        actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getValidationMessage(ticketType, 'price');

        return !!actualMessage;
      }, 3000);
    }
    console.log(actualMessage);
    console.log(actualNumber);
    console.log(expectedText);
    console.log(expectedNumber);
    actualTimeout = stopwatch(actualTimeout);
    if (parseInt(expectedTimeout)) {
      this.expect(actualTimeout).to.be.above(parseInt(expectedTimeout) - 1);
    }
    this.expect(actualMessage).to.include(expectedText);
    if (actualNumber) {
      expectedNumber = parseFloat(expectedNumber);
      actualNumber = parseFloat(actualNumber);
      const delta = actualNumber * 0.01;
      this.expect(actualNumber).to.be.within(expectedNumber - delta, expectedNumber + delta);
    }
  });

  Then(/^(main |oco |)'(.+)' field validation should be cleared$/, async function(ticketType, field) {
    const actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getValidationMessage(ticketType, field);
    this.expect(actualMessage).to.equal('');
  });

  Then(/^'(.+)' '(.+)'( main | oco | )'(.+)'(?:st|th|nd|rd|) (stop|limit) price validation should be correct( and should not appear for '(.+)'ms|)$/, async function(direction, marketName, ticketType, orderNumber, orderType, expectedTimeout) {
    const self = this;

    let expectedPattern;
    let actualMessage;
    let actualTimeout;

    ticketType = ticketType.trim();
    orderNumber = orderNumber === 'default' ? orderType : orderNumber;
    orderNumber = orderNumber === 'stop'
      ? 1
      : orderNumber === 'limit'
        ? 2
        : orderNumber;

    orderNumber = parseInt(orderNumber) - 1;
    const order = await self.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber);

    function getExpectedPattern(dir, type) {
      const expectedPattern1 = new RegExp(`Too low\\. Minimum price \\d+?\\.?\\d*`);
      const expectedPattern2 = new RegExp(`Too high\\. Maximum price \\d+?\\.?\\d*`);

      const setOrderPrice = self.memory[`${type} price`] ?
        parseFloat(self.memory[`${type} price`]) :
        parseFloat(self.memory[`oco ${type} price`]);

      if (setOrderPrice === 0) {
        return new RegExp('Price should be greater than 0');
      } else if (dir === 'sell' && type === 'stop') {
        return expectedPattern1;
      } else if (dir === 'sell' && type === 'limit') {
        return expectedPattern2;
      } else if (dir === 'buy' && type === 'stop') {
        return expectedPattern2;
      } else if (dir === 'buy' && type === 'limit') {
        return expectedPattern1;
      }
    }

    function stopwatch(start?) {
      if (!start) {
        return process.hrtime();
      }
      const end = process.hrtime(start);

      return Math.round((end[0] * 1000) + (end[1] / 1000000));
    }

    async function compareValidationMsg(dir, oType) {
      expectedPattern = getExpectedPattern(dir, oType);
      actualTimeout = stopwatch();
      await browser.wait(() => {
        return order.getValidationMessage()
          .then((msg) => {
            actualMessage = msg;

            return this.helper.sleepIfFalse(actualMessage.match(expectedPattern));
          }, () => false);
      }, 20000)
        .then(() => null, () => null);
      actualTimeout = stopwatch(actualTimeout);
    }

    await compareValidationMsg(direction, orderType);
    if (parseInt(expectedTimeout)) {
      this.expect(actualTimeout).to.be.above(parseInt(expectedTimeout) - 1);
    }
    this.expect(actualMessage).to.match(expectedPattern);
  });

  Then(/^(buy|sell) '(.+)' '(.+)'(?:st|th|nd|rd|) guaranteed stop price validation should be correct$/, async function(direction, marketName, orderNumber) {
    const self = this;
    const marketId = marketName === 'current market' ? parseInt(this.memory.marketId) : this.idMatcher.market[marketName];
    const marketInformation = await self.backendHelper.getMarketInformation(marketId);
    let expectedPattern;
    let expectedPrice;
    let actualMessage;
    let promiseArr = [];

    orderNumber = parseInt(orderNumber) - 1;
    const order = await self.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder('', orderNumber);

    function getValidPricePointsUnits(dir, price) {
      const betPer = parseFloat(marketInformation.BetPer);
      const minDistance = parseFloat(marketInformation.GuaranteedOrderMinDistance);
      const units = parseInt(marketInformation.GuaranteedOrderMinDistanceUnits); // 26 - percentage, 27 - points
      const decimals = marketInformation.PriceDecimalPlaces;
      const d = dir === 'sell' ? 1 : -1;
      let validPrice;

      if (units === 26) {
        validPrice = (parseFloat(price) * (1 + d * minDistance * 0.01)).toFixed(decimals);
      } else {
        validPrice = (parseFloat(price) + d * minDistance * betPer).toFixed(decimals);
      }

      return validPrice;
    }

    function getExpectedPattern(dir, price) {
      const expectedPattern1 = `Too low. Minimum price ${price.toString().replace(/0+$/, '')}`;
      const expectedPattern2 = `Too high. Maximum price ${price.toString().replace(/0+$/, '')}`;

      if (dir === 'sell') {
        return expectedPattern1;
      } else if (dir === 'buy') {
        return expectedPattern2;
      }
    }

    async function compareValidationMsg(dir) {
      self.lightstreamer.subscribe(marketId);
      const oppositeDir = dir === 'sell' ? 'Offer' : 'Bid';
      await browser.wait(() => {
        promiseArr = [];
        promiseArr.push(self.lightstreamer.addListener(oppositeDir)
          .then((dt) => {
          expectedPrice = getValidPricePointsUnits(dir, dt);
          expectedPattern = getExpectedPattern(dir, expectedPrice);
        }));
        promiseArr.push(order.getValidationMessage()
          .then((am) => actualMessage = am));

        return Promise.all(promiseArr)
          .then(() => {
            console.log(`${actualMessage} === ${expectedPattern}`);

            return actualMessage === expectedPattern;
          });
      }, 20000)
        .then(() => null, () => null);
    }

    await compareValidationMsg(direction);
    this.expect(actualMessage).to.equal(expectedPattern);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (stop|limit) max quantity validation should be correct$/, async function(ticketType, orderNumber, orderType) {
    let expectedPattern;
    let actualMessage;
    const quantity = this.memory.quantity;

    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getValidationMessage();
    expectedPattern = `Max for all ${orderType}s can't be greater than ${quantity}`;

    this.expect(actualMessage).to.equal(expectedPattern);
  });

  // step for quantity validation stop/limit orders, when main quantity is NOT set and validation message are
  // `Too low. Minimum ${minSize}` / `Too high. Maximum ${maxSize}`;
  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' validation should be correct( and should not appear for '(.+)'ms|)$/, async function(ticketType, orderNumber, field, expectedTimeout) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    let actualMessage, expectedPattern, actualTimeout;

    const marketInformation = await this.backendHelper.getMarketInformation(this.memory.marketId);

    if (field === 'min quantity') {
      const minSize = marketInformation.WebMinSize;
      expectedPattern = `Too low. Minimum ${minSize}`;
    } else if (field === 'max quantity') {
      const maxSize = marketInformation.MaxLongSize;
      expectedPattern = `Too high. Maximum ${maxSize}`;
    }

    function stopwatch(start?) {
      if (!start) {
        return process.hrtime();
      }
      const end = process.hrtime(start);

      return Math.round((end[0] * 1000) + (end[1] / 1000000));
    }
    actualTimeout = stopwatch();
    await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getValidationMessage()
        .then((text) => text === expectedPattern);
    }, 5000)
      .catch(() => null);
    actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getValidationMessage();
    actualTimeout = stopwatch(actualTimeout);
    if (parseInt(expectedTimeout)) {
      this.expect(actualTimeout).to.be.above(parseInt(expectedTimeout) - 1);
    }
    this.expect(actualMessage).to.equal(expectedPattern);
  });

  // step for quantity validation stop/limit orders, when main quantity is set
  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (stop|limit) max quantity validation should be correct for '(.+)'( and should not appear for '(.+)'ms|)$/, async function(ticketType, orderNumber, orderType, marketName, expectedTimeout) {
    const marketInformation = await this.backendHelper.getMarketInformation(this.memory.marketId);
    const minSize = marketInformation.WebMinSize;
    const maxSize = marketInformation.MaxLongSize;
    let expectedPattern;
    let actualMessage;

    function stopwatch(start?) {
      if (!start) {
        return process.hrtime();
      }
      const end = process.hrtime(start);

      return Math.round((end[0] * 1000) + (end[1] / 1000000));
    }
    let actualTimeout = stopwatch();

    let quantity = this.memory.quantity;
    if (quantity > maxSize) {
      quantity = maxSize;
    }
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getValidationMessage();
    expectedPattern = `Max for all ${orderType}s can't be greater than ${quantity}`;

    actualTimeout = stopwatch(actualTimeout);
    if (parseInt(expectedTimeout)) {
      this.expect(actualTimeout).to.be.above(parseInt(expectedTimeout) - 1);
    }
    this.expect(actualMessage).to.equal(expectedPattern);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:stop|limit) (?:max quantity|price|pips\/points) validation should be cleared$/, async function(ticketType, orderNumber) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();

    const actualMessage = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getText('validationContainer');
    this.expect(actualMessage).to.equal('');
  });

  Then(/^margin calculator should contain (correct information|nothing)$/, async function(expectedState) {
    let actualText: string;
    let expectedPattern;
    const marketInfo = await this.backendHelper.getMarketInformation(parseInt(this.memory.marketId));
    const pointsType = marketInfo.MarketUnderlyingType === 'FX' ? 'PIP' : 'Point';
    const ccy = (await this.backendHelper.getClientAndTradingAccount()).ClientAccountCurrency;

    if (expectedState === 'nothing') {
      expectedPattern = /^$/;
      if (process.env.npm_config_browser === 'safari') {
        expectedPattern =
          new RegExp(`^${pointsType} Value: Margin required: Percentage of available funds:$`);
      }
    } else {
      expectedPattern =
        new RegExp(`^${pointsType} Value: ${ccy} \\d+\\.?\\d* Margin required: \\d+\\.?\\d* ${ccy} Percentage of available funds: \\d+\\.?\\d*%$`);
    }

    await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.getMarginCalcText()
        .then((text) => {
          actualText = text.replace(/\,/g, '').replace(/\s{2,}/g, ' ').replace(/ *\n */g, ' ');

          return this.helper.sleepIfFalse(actualText.match(expectedPattern), 200);
        });
    }, 2000, `Margin calculator is not matched ${expectedPattern} after 2 sec`);

    this.expect(actualText).to.match(expectedPattern);
  });

  When(/^I store data from margin calculator$/, async function() {
    this.memory['margin calculator'] = {};
    this.memory['margin calculator'].risks = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('risks');
    this.memory['margin calculator'].margin = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('margin');
    this.memory['margin calculator'].details = await this.basePage.currentBoard.tabBody.currentPanel.getElementText('details');
  });

  Then(/^Margin calculator '(.+)' value should be changed$/, async function(fieldValue) {
    let actualValue;
    const expiryValue = this.memory['margin calculator'][fieldValue];

    await browser.wait(() => {
      return this.basePage.currentBoard.tabBody.currentPanel.getElementText(fieldValue)
        .then((value) => {
          actualValue = value;

          return actualValue !== expiryValue;
        }, () => false);
    }, 10000, `Expiry value ${expiryValue} is not updated after 10 sec`);

    this.expect(actualValue).to.not.equal(expiryValue);
    this.memory['margin calculator'][fieldValue] = actualValue;
  });

  Then(/^(main |oco |)'(.+)' (?:element|input) should be (active|inactive)$/, async function(ticketType, field, state) {
    field = field.toLowerCase();
    ticketType = ticketType.trim();
    const expectedState = state === 'active';
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isElementActive(field, ticketType);
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^cursor is placed in the '(.+)' field$/, async function(elementName) {
    const elementPlaceholder = await this.basePage.currentBoard.tabBody.currentPanel.getPlaceholder(elementName);
    const focusPlaceholder = await browser.switchTo().activeElement().getAttribute('placeholder');

    this.expect(elementPlaceholder).to.be.equal(focusPlaceholder);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' field (should be|should be not) focused$/, async function(ticketType, orderNumber, field, state) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    const elementPlaceholder = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getPlaceholder(field);
    const focusPlaceholder = await browser.switchTo().activeElement().getAttribute('placeholder');
    if (state === 'should be') {
      this.expect(elementPlaceholder).to.be.equal(focusPlaceholder);
    } else {
      this.expect(elementPlaceholder).to.not.equal(focusPlaceholder);
    }
  });

  Then(/^the number of decimal places in (sell|buy) price button is correct for '(.+)'$/, async function(direction, marketName) {
    if (marketName.toLowerCase() === 'current market') {
      marketName = this.memory.marketName;
    }
    const marketInformation = await this.backendHelper.getMarketInformation(this.idMatcher.market[marketName]);
    const decimals = marketInformation.PriceDecimalPlaces;
    const price = await this.basePage.currentBoard.tabBody.currentPanel.getPrice(direction);
    this.expect(price.split('.')[1].length).to.equal(decimals);
  });

  Then(/^(?:confirmation|failure) message should not be displayed within panel$/, async function() {
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.waitForConfirmationMessage(200)
      .then(() => true, () => false);
    this.expect(actualState).to.equal(false);
  });

  // steps with color
  Then(/^the '(.+)' button should be '(red|blue|grey|darkRed|darkBlue)'( when it is '(clicked|hovered)'|)$/, async function(labelOrButtonName, color, state?) {
    labelOrButtonName = labelOrButtonName.toLowerCase();
    const colors = {
      red: '222, 69, 89',
      darkRed: '150, 0, 19',
      blue: '44, 124, 179',
      darkBlue: '15, 88, 125',
      grey: '238, 238, 238'
    };
    const expectedColorPart = colors[color];

    if (labelOrButtonName === 'sell' || labelOrButtonName === 'buy') {
      if (state === 'clicked') {
        await this.basePage.currentBoard.tabBody.currentPanel.clickOnLabel(labelOrButtonName);
      }
      labelOrButtonName = `${labelOrButtonName}Label`;
    } else if (labelOrButtonName === 'submit') {
      if (state === 'hovered') {
        await this.basePage.currentBoard.tabBody.currentPanel.hover(`${labelOrButtonName} button`);
      }
      labelOrButtonName = `${labelOrButtonName}Btn`;
    }
    const actualColor = await this.basePage.currentBoard.tabBody.currentPanel.getColor(labelOrButtonName, 'background-color');
    this.expect(actualColor).to.include(expectedColorPart);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) order '(.+)' (?:field|element) should have (red|blue|grey) color$/, async function(ticketType, orderNumber, fieldName, expectedColor) {
    orderNumber = parseInt(orderNumber) - 1;
    ticketType = ticketType.trim();
    const actualColor = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getCssValue(fieldName, 'border-left-color');
    const colors = {
      red: '208, 1, 27',
      grey: '209, 209, 209'
    };
    this.expect(actualColor).to.include(colors[expectedColor]);
  });

  Then(/^the( main | oco | )(?:order|trade) '(.+)' field should have (red|blue|no) color$/, async function(ticketType, fieldName, expectedColor) {
    ticketType = ticketType.trim();
    let actualColor = await this.basePage.currentBoard.tabBody.currentPanel.getCssValue(fieldName, ticketType, 'border-color');
    if (expectedColor === 'no') {
      actualColor = await this.basePage.currentBoard.tabBody.currentPanel.getCssValue(fieldName, ticketType, 'border');
    }
    const colors = {
      red: '208, 1, 27',
      no: process.env.npm_config_browser === 'firefox' || process.env.npm_config_browser === 'edge' ? '' : 'none'
    };
    this.expect(actualColor).to.include(colors[expectedColor]);
  });

  Then(/^'(.+)' tick should be correct color$/, async function(direction) {
    const promiseArr = [];
    let actualColor;
    let expectedColor;

    await browser.wait(() => {
    promiseArr.push(this.basePage.currentBoard.tabBody.currentPanel.getCssValue(`${direction} tick`, '', 'color')
      .then((color) => {
        actualColor = color;
      }));
    promiseArr.push(this.basePage.currentBoard.tabBody.currentPanel.getAttribute(`${direction} tick`, 'class')
      .then((elementClass) => {

        if (this.memory.direction === direction) {
          expectedColor = (process.env.npm_config_browser === 'firefox' || process.env.npm_config_browser === 'edge') ? '' : '255, 255, 255'; // white
        } else {
          if (elementClass.includes('down')) {
            expectedColor = '222, 69, 89'; // red
          } else if (elementClass.includes('up')) {
            expectedColor = '21, 125, 177'; // blue
          } else {
            expectedColor = '';
          }
        }
      }));

      return Promise.all(promiseArr)
        .then(() => actualColor.includes(expectedColor));
  }, 100000)
    .then(() => null, () => null);

    this.expect(actualColor).to.include(expectedColor);
  });

  Then(/^1-click '(.+)' for the '(.+)' market should have (red|blue|grey|no) color$/, async function(field, marketNameOrNumber, expectedColor) {
    let marketId;
    if (marketNameOrNumber.toLowerCase() === 'previously added' || marketNameOrNumber.toLowerCase() === 'current') {
      marketNameOrNumber = this.memory.marketName;
      marketId = parseInt(this.memory.marketId);
    } else if (marketNameOrNumber.toLowerCase() === 'new') {
      marketNameOrNumber = this.memory.newMarketName;
      marketId = parseInt(this.memory.newMarketId);
    }
    const market = await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber, marketId);
    let actualColor = await market.getCssValue(field, 'border-color');
    if (expectedColor === 'no' || field.includes('hover')) {
      await market.scrollTo();
      actualColor = await market.getCssValue(field, 'border');
    }
    const colors = {
      red: '208, 1, 27',
      grey: '209, 209, 209',
      blue: '44, 124, 179',
      redSell: '222, 69, 89',
      no: process.env.npm_config_browser === 'firefox' || process.env.npm_config_browser === 'edge' ? '' : 'none'
    };
    if (field.includes('sell')) {
      expectedColor = `${expectedColor}Sell`;
    }
    this.expect(actualColor).to.include(colors[expectedColor]);
  });

  Then(/^the( main | oco | )'(.+)'(?:st|th|nd|rd|) (?:normal stop|guaranteed stop|trailing stop|limit) linked order '(.+)' element (background|color) should be (grey|white|blue|red)$/,
    async function(ticketType, orderNumber, field, property, color) {
      let expectedColorPart;
      const colors = {
        grey: '238, 238, 238',
        white: '0, 0, 0',
        blue: '44, 124, 179',
        red: '222, 69, 89'
      };
      expectedColorPart = colors[color];
      orderNumber = parseInt(orderNumber) - 1;
      ticketType = ticketType.trim();

      if (process.env.npm_config_browser.includes('firefox') && property === 'background') {
        property = 'background-color';
      }

      const actualColor = await this.basePage.currentBoard.tabBody.currentPanel.getAnyLinkedOrder(ticketType, orderNumber).getCssValue(field, property);
      this.expect(actualColor).to.include(expectedColorPart);
    });

  Then(/^Submit button should be (disable|enable)$/, async function(state) {
    const expectedState = state === 'disable';
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isSubmitDisabled();
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^quantity field in '(.+)' component should (be|be not) predefined with value from ClientPreference responce( and be equal '(.+)'|)$/, async function(componentName, state, value?) {
    let expectedvalue = await this.backendHelper.getClientPreference('MARKET_QUANTITIES');
    if (expectedvalue) {
      expectedvalue = expectedvalue.match( new RegExp(`"${this.memory.marketId}"\,\\d*\\.?\\d*`))[0];
      expectedvalue = parseFloat(expectedvalue.split(/"\,/)[1]);
      this.memory['clientPreference quantity'] = expectedvalue;
    }
    let actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue('quantity');
    actualValue = actualValue ? parseFloat(actualValue.replace(/\,/g, '')) : null;

    if (state.includes('not')) {
      this.expect(expectedvalue === null && actualValue === expectedvalue).to.equal(true);
    } else {
      if (value) {
        value = (await getValue.call(this, value));
        this.expect(expectedvalue).to.equal(value);
      }
      this.expect(actualValue).to.equal(expectedvalue);
    }
  });
});
