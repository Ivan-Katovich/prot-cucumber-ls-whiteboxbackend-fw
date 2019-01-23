process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

import { backendHelper } from './backend-helper';
import { browser } from 'protractor';
// import * as ls from 'lightstreamer-client';
const ls = require(`${process.cwd()}/ui-tests/lib/lightstreamer/lightstreamer.min.js`);

const PRICE_ITEM_GROUP = [
  'MarketId',
  'TickDate',
  'Bid',
  'Offer',
  'Price',
  'High',
  'Low',
  'Change',
  'Delta',
  'ImpliedVolatility',
  'Direction',
  'Status',
  'StatusSummary',
  'PriceEngine',
  'Row_Update_Version',
  'AuditId'
];

const TRADE_MARGIN_ITEM_GROUP = [
  'ClientAccountId',
  'DirectionId',
  'MarginRequirementConverted',
  'MarginRequirementConvertedCurrencyId',
  'MarginRequirementConvertedCurrencyISOCode',
  'MarketId',
  'MarketTypeId',
  'Multiplier',
  'OrderId',
  'OTEConverted',
  'OTEConvertedCurrencyId',
  'OTEConvertedCurrencyISOCode',
  'PriceCalculatedAt',
  'PriceTakenAt',
  'PriceCalculatedAtInTicks',
  'PriceTakenAtInTicks',
  'Quantity'
];


const lsAdapter = 'STREAMINGALL';

let lsClient;
let mySubscription;
let lsUrl: string;

export function getLsStatus() {
  try {
    return lsClient.getStatus();
  } catch (err) {
    return null;
  }
}

export function setLsUrl() {
  lsUrl = browser.params.lightStreamerUrl;
}

export async function connectLS() {
  const parsedSession = await backendHelper.getSession();

  const promise = new Promise((resolve, reject) => {
    if (lsClient && lsClient.getStatus().indexOf('CONNECTED') !== -1 && lsClient.getStatus().indexOf('DIS') === -1) {
      resolve();

      return;
    }
    const user = parsedSession['username'];
    const token = parsedSession['sessionKey'];

    lsClient = new ls.LightstreamerClient(lsUrl, lsAdapter);
    lsClient.connectionDetails.setUser(user);
    lsClient.connectionDetails.setPassword(token);
    lsClient.addListener({
      onServerError: function(errorCode, errorMessage) {
        reject();
      },
      onStatusChange: function(status) {
        console.log(status);

        if (status === 'CONNECTED:HTTP-STREAMING') {
          resolve();
        }
      },
      onListenStart: function() {
        console.log('start LS');
        console.log(lsUrl);
        // resolve();
      }
    });
    lsClient.connect();
  });

  return promise;
}

export function disconnectLS() {
  const subscriptions = lsClient.getSubscriptions();
  subscriptions.forEach(subscription => {
    lsClient.unsubscribe(subscription);
  });
  lsClient.disconnect();
}

export function subscribe(marketId) {
  if (typeof marketId !== 'number') {
    marketId = parseInt(marketId);
  }

  const subscriptions = lsClient.getSubscriptions();
  const targetSubscriptions = subscriptions.filter((subscription) => {
    if (subscription.getItems()[0].match(/\d+/)) {
      return parseInt(subscription.getItems()[0].match(/\d+/)[0]) === marketId;
    }
  });
  if (targetSubscriptions.length > 1) {
    throw new Error(`too many subscriptions for market:${marketId}`);
  } else if (targetSubscriptions.length === 1) {
    console.log(`subscription for market:${marketId} exists`);
    mySubscription = targetSubscriptions[0];
  } else {
    console.log(`new subscription for market:${marketId}`);
    mySubscription = new ls.Subscription('MERGE', `PRICE.${marketId}`, PRICE_ITEM_GROUP);
    mySubscription.setDataAdapter('PRICES');
    lsClient.subscribe(mySubscription);
  }
  console.log(lsClient.getStatus());
}

export function subscribeMargin() {
  const subscriptions = lsClient.getSubscriptions();
  const targetSubscriptions = subscriptions.filter((subscription) => {
    return subscription.getItems()[0] === 'TRADEMARGIN';
  });
  if (targetSubscriptions.length > 1) {
    throw new Error(`too many subscriptions for TRADEMARGIN`);
  } else if (targetSubscriptions.length === 1) {
    console.log(`subscription for TRADEMARGIN exists`);
    mySubscription = targetSubscriptions[0];
  } else {
    console.log(`new subscription for TRADEMARGIN`);
    mySubscription = new ls.Subscription('MERGE', 'TRADEMARGIN', TRADE_MARGIN_ITEM_GROUP);
    mySubscription.setDataAdapter('TRADEMARGIN');
    lsClient.subscribe(mySubscription);
  }
  console.log(lsClient.getStatus());
}

export function unsubscribe() {
  lsClient.unsubscribe(mySubscription);
}

export async function addListener(item) {
  let marketItem;
  mySubscription.addListener({
    onItemUpdate: function(obj) {
      marketItem = obj.getValue(item);
    }
  });
  await browser.wait(() => !!marketItem, 60000);
  // TODO: find a way how to awoid unsubscription when LS for all markets work correctly
  unsubscribe();
  console.log(marketItem);

  return marketItem;
}

export async function addMarginListener(item) {
  let marginItem;
  mySubscription.addListener({
    onItemUpdate: function(obj) {
      marginItem = obj.Dbi[parseInt(item)];
    }
  });
  await browser.wait(() => !!marginItem, 80000);
  // TODO: find a way how to awoid unsubscription when LS for all markets work correctly
  unsubscribe();

  return marginItem;
}
