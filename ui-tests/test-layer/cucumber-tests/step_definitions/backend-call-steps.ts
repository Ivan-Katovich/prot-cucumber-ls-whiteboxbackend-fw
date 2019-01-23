/* tslint:disable:max-line-length */
import { defineSupportCode } from 'cucumber';
import { browser } from 'protractor';
import { getValue } from '../../../support/utils/helper';


defineSupportCode(function({ Given, When, Then }) {
  When(/^I delete '(.+)' markets$/, async function(marketName) {
    let marketId;
    if (marketName === 'current market') {
      marketId = parseInt(this.memory.marketId);
    } else {
      marketId = this.idMatcher.market[marketName];
    }
    await this.backendHelper.deletePositionsByMarketId(marketId);
  });

  When(/^I add ([Oo]rder|[Pp]osition) with parameters:$/, async function(type, table) {
    const market = table.rowsHash();
    if (market.MarketName === 'current market' ) {
      market.MarketName = this.memory.marketName;
    }
    const marketId = this.idMatcher.market[market.MarketName];
    this.memory.marketId = this.idMatcher.market[market.MarketName];
    market.Direction = market.Direction.toLowerCase();
    await this.lightstreamer.subscribe(marketId);
    const buy = await this.lightstreamer.addListener('Offer');
    console.log(`buy=${buy}`);
    // await this.lightstreamer.unsubscribe();
    await this.lightstreamer.subscribe(marketId);
    const sell = await this.lightstreamer.addListener('Bid');
    console.log(`sell=${sell}`);
    this.memory.marketName = market.MarketName;
    this.memory.prices = {
      sell: sell,
      buy: buy
    };

    if (market.Quantity) {
      market.Quantity = await getValue.call(this, market.Quantity);
    }
    if (market.StopQuantity) {
      market.StopQuantity = await getValue.call(this, market.StopQuantity);
    }
    if (market.LimitQuantity) {
      market.LimitQuantity = await getValue.call(this, market.LimitQuantity);
    }

    this.memory.sell = sell;
    this.memory.buy = buy;
    this.memory.direction = market.Direction;
    this.memory.quantity = market.Quantity;
    this.memory.amalgamatedQty = this.memory.amalgamatedQty ? this.memory.amalgamatedQty : 0;
    this.memory.amalgamatedQty += parseInt(market.Quantity);
    this.memory.qtyArray = this.memory.qtyArray ? this.memory.qtyArray : [];
    this.memory.qtyArray.push(market.Quantity);
    this.memory.price = market.Price;
    this.memory['order price'] = market.Price;
    this.memory.positionMethodId = market.PositionMethodId;
    this.memory['normal stop'] = {};
    this.memory['limit'] = {};
    const ifDone = [];
    const oppositeDirection = market.Direction.match(/[Bb]uy/) ? 'sell' : 'buy';

    if (market.StopPrice || market.LimitPrice) {
      market.StopPrice = market.StopPrice === 'buy' ? this.memory.buy :
                         market.StopPrice === 'sell' ? this.memory.sell :
                         market.StopPrice;
      market.LimitPrice = market.LimitPrice === 'buy' ? this.memory.buy :
                          market.LimitPrice === 'sell' ? this.memory.sell :
                          market.LimitPrice;

      const marketInformation = await this.backendHelper.getMarketInformation(this.memory.marketId);
      this.memory.marketPriceDemicals = marketInformation.PriceDecimalPlaces;
      if (market.StopPrice) {
        this.memory['normal stop']['price'] =
          parseFloat(market.StopPrice).toLocaleString(undefined, {minimumFractionDigits: this.memory.marketPriceDemicals});
      }
      if (market.LimitPrice) {
        this.memory['limit']['price'] =
          parseFloat(market.LimitPrice).toLocaleString(undefined, {minimumFractionDigits: this.memory.marketPriceDemicals});
      }

      const stopLimitObj = {
        Stop: null,
        Limit: null
      };
      if (market.LimitPrice) {
        stopLimitObj.Limit = {
          OrderId: null,
          Direction: oppositeDirection,
          TrailingDistance: null,
          Quantity: market.LimitQuantity ? market.LimitQuantity : market.Quantity,
          Applicability: 'gtc',
          TriggerPrice: market.LimitPrice,
          Guaranteed: false,
          ExpiryDateTimeUTC: null
        };
      }
      if (market.StopPrice) {
        stopLimitObj.Stop = {
          OrderId: null,
          Direction: oppositeDirection,
          TrailingDistance: null,
          Quantity: market.StopQuantity ? market.StopQuantity : market.Quantity,
          Applicability: 'gtc',
          TriggerPrice: market.StopPrice,
          Guaranteed: false,
          ExpiryDateTimeUTC: null
        };
      }
      ifDone.push(stopLimitObj);
    }
    const orderType = type === 'position' ? 'TradeOrder' : 'StopLimitOrder';

    if (type === 'position') {
      await this.backendHelper.addNewPosition(market.MarketName, market.Direction, market.Quantity, this.memory.sell, this.memory.buy, ifDone, this.memory.positionMethodId);
    } else {
      await this.backendHelper.addNewOrder(market.MarketName, market.Direction, market.Price, market.Quantity, this.memory.sell, this.memory.buy, ifDone, this.memory.positionMethodId);
    }
  });

  When(/^I delete '([Oo]rder|[Pp]osition)' '(.+)'$/, async function(ticketType, marketName) {
    let marketId;
    if (marketName === 'current market') {
      marketId = parseInt(this.memory.marketId);
    } else {
      marketId = this.idMatcher.market[marketName];
    }

    if (ticketType.toLowerCase().includes('position')) {
      await this.backendHelper.deletePositionsByMarketId(marketId);
    } else {
      await this.backendHelper.deleteOrdersByMarketId(marketId);
    }
  });

  When(/^I get '([Oo]rder|[Pp]osition)' History for '(DFT|CFD|Spread)'$/, async function(ticketType, accType) {
    accType = accType === 'Spread' ? 'DFT' : accType;
    if (ticketType.toLowerCase() === 'position') {
      await this.backendHelper.getPositionHistory(1, accType).then((data) => {
        this.memory.history = data[0];
      });
    } else {
      await this.backendHelper.getOrderHistory(1, accType).then((data) => {
        this.memory.history = data[0];
      });
    }
  });

  Then(/^trading account ID in activeorder responce should be the same as (CFD|Spread) account in ClientAndTradingAccount responce$/, async function(accountType) {
    const tradingAccountId = (await this.backendHelper.getActiveOrders()).ActiveOrders
      .map((item) => item.TradeOrder.TradingAccountId)[0];

    const accountId = (await this.backendHelper.getClientAndTradingAccount()).TradingAccounts
      .filter((item) => item.TradingAccountType.includes(accountType))[0].TradingAccountId;

    this.expect(tradingAccountId).to.equal(accountId);
  });
});
