import { browser } from 'protractor';
import { idMatcher } from '../enums/market-id.enum';
import * as rp from 'request-promise';
import * as request from 'request';
import * as lightstreamer from './lightstreamer-helper';
import { helper } from './helper';


export let backendHelper = {

  session: null,
  account: null,

  async getSession() {
    if (!this.session) {
      let parsedSession = null;
      parsedSession = await browser.executeScript('return window.sessionStorage.getItem("web_trader_session");');
      if (!parsedSession) {
        parsedSession = await browser.executeScript('return window.localStorage.getItem("web_trader_session");');
      }
      if (!parsedSession) {
        throw new Error(`Can't get session`);
      }
      this.session = JSON.parse(parsedSession);

      return this.session;
    } else {
      return this.session;
    }
  },

  async getAccount() {
    if (!this.account) {
      let parsedAccount = null;
      parsedAccount = await browser.executeScript('return window.sessionStorage.getItem("web_trader_account");');
      if (!parsedAccount) {
        parsedAccount = await browser.executeScript('return window.localStorage.getItem("web_trader_account");');
      }
      if (!parsedAccount) {
        throw new Error(`Can't get session`);
      }
      this.account = JSON.parse(parsedAccount);

      return this.account;
    } else {
      return this.account;
    }
  },

  async setSession() {
    let parsedSession = null;
    parsedSession = await browser.executeScript('return window.sessionStorage.getItem("web_trader_session");');
    if (!parsedSession) {
      parsedSession = await browser.executeScript('return window.localStorage.getItem("web_trader_session");');
    }
    if (!parsedSession) {
      throw new Error(`Can't get session`);
    }
    this.session = JSON.parse(parsedSession);

    return this.session;
  },

  async setAccount() {
    let parsedAccount = null;
    parsedAccount = await browser.executeScript('return window.sessionStorage.getItem("web_trader_account");');
    if (!parsedAccount) {
      parsedAccount = await browser.executeScript('return window.localStorage.getItem("web_trader_account");');
    }
    if (!parsedAccount) {
      throw new Error(`Can't get session`);
    }
    this.account = JSON.parse(parsedAccount);

    return this.account;
  },

  async getActiveOrders() {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const options = {
      method: 'POST',
      url: `${baseUrl}/order/activeorders`,
      headers: {
        Connection: 'keep-alive',
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      },
      body: `{}`
    };
    const ordersBody = await rp(options);

    return JSON.parse(ordersBody);
  },

  resetClientPreferences() {
    const baseUrl = browser.params.tradingApiUrl;
    const keysForDelete = ['MERCURY_LAYOUT', 'mercury_helptip_number', 'MARKET_QUANTITIES', 'MERCURY_RECENT_MARKETS', 'TRADE_DOUBLE_CLICK'];

    return this.getSession()
      .then((parsedSession) => {
          if (parsedSession) {
            keysForDelete.forEach((key) => {
              const options = {
                method: 'POST',
                url: `${baseUrl}/clientpreference/delete`,
                headers: {
                  'Content-Type': 'application/json',
                  UserName: parsedSession['username'],
                  Session: parsedSession['sessionKey']
                },
                body: `{ 'Key': '${key}' }`
              };
              request(options);
            });
          }
        },
        (error) => {
          console.error(error);
        }
      );
  },

  async getClientPreference(preference) {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();

    const options = {
      method: 'POST',
      url: `${baseUrl}/clientpreference/get`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      },
      body: JSON.stringify({ Key: preference })
    };

    let body;
    try {
      body = await rp(options);

      return JSON.parse(body).ClientPreference.Value;
    } catch (err) {
      console.log(err.message);

      return;
    }
  },

  setClientPreference(preference, value) {
    const baseUrl = browser.params.tradingApiUrl;

    return this.getSession()
      .then((parsedSession) => {
          if (parsedSession) {
            const options = {
              method: 'POST',
              url: `${baseUrl}/clientpreference/save`,
              headers: {
                'Content-Type': 'application/json',
                UserName: parsedSession['username'],
                Session: parsedSession['sessionKey']
              },
              body: JSON.stringify({
                ClientPreference: {
                  Key: preference,
                  Value: value
                }
              })
            };
            request(options);
          }
        },
        (error) => {
          console.error(error);
        }
      );
  },

  changePassword(oldPassword, newPassword) {
    const baseUrl = browser.params.tradingApiUrl;

    return this.getSession()
      .then((parsedSession) => {
          if (parsedSession) {
            const options = {
              method: 'POST',
              url: `${baseUrl}/session/changePassword`,
              headers: {
                'Content-Type': 'application/json',
                UserName: parsedSession['username'],
                Session: parsedSession['sessionKey']
              },
              body: JSON.stringify({
                  NewPassword: newPassword,
                  Password: oldPassword,
                  Username: parsedSession['username']
              })
            };
            if (parsedSession) {
              return rp(options);
            }
          }
        }
      )
      .then((body) => {
        return JSON.parse(body).IsPasswordChanged;
      })
      .catch((error) => {
        console.log(error);
      });
  },

  changeUserAccountEmail(email) {
    const baseUrl = browser.params.tradingApiUrl;

    return this.getSession()
      .then((parsedSession) => {
        if (parsedSession) {
          const options = {
            method: 'POST',
            url: `${baseUrl}/useraccount/Save`,
            headers: {
              'Content-Type': 'application/json',
              UserName: parsedSession['username'],
              Session: parsedSession['sessionKey']
            },
            body: JSON.stringify({
              PersonalEmailAddress: email,
              PersonalEmailAddressIsDirty: true
            })
          };
          if (parsedSession) {
            return rp(options);
          }
        }
      })
      .catch((error) => {
        console.log(error);
      });
  },

  async getClientAndTradingAccount() {
    const baseUrl = browser.params.tradingApiUrl;

    return Promise.resolve()
      .then(() => this.getSession())
      .then((parsedSession) => {
        const options = {
          method: 'GET',
          url: `${baseUrl}/useraccount/ClientAndTradingAccount`,
          headers: {
            'Content-Type': 'application/json',
            UserName: parsedSession['username'],
            Session: parsedSession['sessionKey']
          }
        };
        if (parsedSession) {
          return rp(options);
        }
      })
      .then((body) => {
        return JSON.parse(body);
      })
      .catch((error) => {
        console.log(error);
      });
  },

  async getClientApplicationMessageTranslationWithInterestingItems(
    clientApplicationId: number,
    cultureId: number,
    accountOperatorId: number,
    interestedTranslationKeys: string[]
  ) {
    const baseUrl = browser.params.tradingApiUrl;

    return Promise.resolve()
      .then(() => this.getSession())
      .then((parsedSession) => {
        const options = {
          method: 'POST',
          url: `${baseUrl}/message/translationWithInterestingItems`,
          headers: {
            'Content-Type': 'application/json',
            UserName: parsedSession['username'],
            Session: parsedSession['sessionKey']
          },
          body: JSON.stringify({
            ClientApplicationId: clientApplicationId,
            CultureId: cultureId,
            AccountOperatorId: accountOperatorId,
            InterestedTranslationKeys: interestedTranslationKeys
          })
        };
        if (parsedSession) {
          return rp(options);
        }
      })
      .then((body) => {
        return JSON.parse(body).TranslationKeyValuePairs;
      })
      .catch((error) => {
        console.log(error);
      });
  },

  async getMarketInformation(marketId: number) {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const options = {
      method: 'GET',
      url: `${baseUrl}/market/${marketId}/information`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    let body;
    try {
      body = await rp(options);

      return JSON.parse(body).MarketInformation;
    } catch (err) {
      console.log(err.message);
      await helper.sleep(5000);
      await rp(options)
        .then((body2) => {
          return JSON.parse(body2).MarketInformation;
        }, () => {
          console.log(`can't get market information`);
        });
    }

  },

  async getMarketExtendedInfo(marketId: number) {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();

    const options = {
      method: 'GET',
      url: `${baseUrl}/market/${marketId}/informationextended`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    const body = await rp(options);

    return JSON.parse(body);
  },

  async getMarginInfo() {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();

    const options = {
      method: 'GET',
      url: `${baseUrl}/margin/ClientAccountMargin`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    const body = await rp(options);

    return JSON.parse(body);
  },

  async getSimulateInformation(marketId: number, direction: string, quantity: number) {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();

    const marketTypeId = (await this.getMarketExtendedInfo(marketId)).MarketInformation.MarketSettingsTypeId;

    const parsedAccount = await this.getAccount();
    const accPosition = marketTypeId === 1 ? 1 : 0;

    lightstreamer.subscribe(marketId);

    const options = {
      method: 'POST',
      url: `${baseUrl}/order/simulate/newtradeorder`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      },
      body: JSON.stringify({
        BidPrice: await lightstreamer.addListener('Bid'),
        Direction: direction,
        IfDone: [],
        MarketId: marketId,
        OfferPrice: await lightstreamer.addListener('Offer'),
        PositionMethodId: 1,
        Quantity: quantity,
        TradingAccountId: parsedAccount.TradingAccounts[accPosition].TradingAccountId
      })
    };
    const body = await rp(options);

    return JSON.parse(body);
  },

  getMarketsNamesByTagName(tagName, num) {
    const baseUrl = browser.params.tradingApiUrl;
    let parsedSession;

    return Promise.resolve()
      .then(() => this.getSession())
      .then((ps) => {
        parsedSession = ps;
        const options = {
          method: 'GET',
          url: `${baseUrl}/market/taglookup`,
          headers: {
            'Content-Type': 'application/json',
            UserName: parsedSession['username'],
            Session: parsedSession['sessionKey']
          }
        };
        if (parsedSession) {
          return rp(options);
        }
      })
      .then((body) => {
        const bodyObj = JSON.parse(body);
        const popMarketId = bodyObj.Tags.filter((tag) => {
          return tag.Name === tagName;
        })[0].MarketTagId;
        const options2 = {
          method: 'GET',
          url: `${baseUrl}/market/fullsearchwithtags?tagId=${popMarketId}&maxResults=${num}&` +
          `query=&spreadProductType=true&cfdProductType=true&includeOptions=true`,
          headers: {
            'Content-Type': 'application/json',
            UserName: parsedSession['username'],
            Session: parsedSession['sessionKey']
          }
        };

        return rp(options2);
      })
      .then((body) => {
        const bodyObj = JSON.parse(body);

        return bodyObj.MarketInformation.map((market) => {
          return market.Name;
        });
      })
      .catch((err) => {
        console.log(err.message);
      });
  },

  getMarketsParametersByTagId(tagId, num, parameter = 'Name') {
    const baseUrl = browser.params.tradingApiUrl;

    return Promise.resolve()
      .then(() => this.getSession())
      .then((parsedSession) => {
        const options = {
          method: 'GET',
          url: `${baseUrl}/market/fullsearchwithtags?tagId=${tagId}&maxResults=${num}&` +
          `query=&spreadProductType=true&cfdProductType=true&includeOptions=true`,
          headers: {
            'Content-Type': 'application/json',
            UserName: parsedSession['username'],
            Session: parsedSession['sessionKey']
          }
        };
        if (parsedSession) {
          return rp(options);
        }
      })
      .then((body) => {
        const bodyObj = JSON.parse(body);

        return bodyObj.MarketInformation.map((market) => {
          return market[parameter];
        });
      })
      .catch((err) => {
        console.log(err.message);
      });
  },

  async getMarketsNamesByQuery(tagId, num, query, spread, cfd, includeOptions) {
    const baseUrl = browser.params.tradingApiUrl;
    let body;
    const parsedSession = await this.getSession();
    const options = {
      method: 'GET',
      url: `${baseUrl}/market/fullsearchwithtags?query=${query}&tagId=${tagId}&maxResults=${num}&` +
      `searchByMarketCode=true&searchByMarketName=true&spreadProductType=${spread}&cfdProductType=${cfd}&` +
      `quebinaryProductTypery=true&includeOptions=${includeOptions}&useMobileShortName=false`,

      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };

    if (parsedSession) {
      body = await rp(options);
    }
    try {
      const bodyObj = JSON.parse(body);

      return bodyObj.MarketInformation;
    } catch (err) {
      console.log(err.message);

      return;
    }
  },

  getMarketsInformation(tagId, num, includeOptions = 'false') {
    const baseUrl = browser.params.tradingApiUrl;

    return Promise.resolve()
      .then(() => this.getSession())
      .then((parsedSession) => {
        const options = {
          method: 'GET',
          url: `${baseUrl}/market/fullsearchwithtags?tagId=${tagId}&maxResults=${num}&` +
          `query=&spreadProductType=true&cfdProductType=true&includeOptions=${includeOptions}`,
          headers: {
            'Content-Type': 'application/json',
            UserName: parsedSession['username'],
            Session: parsedSession['sessionKey']
          }
        };
        if (parsedSession) {
          return rp(options);
        }
      })
      .then((body) => {
        const bodyObj = JSON.parse(body);

        return bodyObj.MarketInformation;
      })
      .catch((err) => {
        console.log(err.message);
      });
  },

  async getMarketsNews(tagId) {
    const baseUrl = browser.params.tradingApiUrl;
    let body;
    const parsedSession = await this.getSession();
    const options = {
      method: 'GET',
      url: `${baseUrl}/news/marketreportheadlines?marketId=${tagId}&cultureId=69&maxResults=50`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    if (parsedSession) {
      body = await rp(options);
    }
    try {
      const bodyObj = JSON.parse(body);

      return bodyObj.Headlines.map((news) => {
        // it's necessary to replace all HTML mnemonics from http-response
        return news['Headline'].trim().replace(/amp;/g, '').replace(/&apos;/g, '\'').split('&quot;').join('\"');
      });
    } catch (err) {
      console.log(err.message);

      return;
    }
  },

  async getConversionRates(fromCurrencyId, toCurrencyId) {
    const baseUrl = browser.params.tradingApiUrl;
    let body;
    const parsedSession = await this.getSession();
    const options = {
      method: 'GET',
      url: `${baseUrl}//market/conversionratefxmarkets`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    if (parsedSession) {
      body = await rp(options);
    }
    try {
      const bodyObj = JSON.parse(body);

      const conversion = bodyObj.ConversionRateFxMarkets.filter((conversionRates) => {
        return conversionRates['FromCurrencyId'] === fromCurrencyId && conversionRates['ToCurrencyId'] === toCurrencyId;
      })[0];

      return {buy: conversion['Bid'], sell: conversion['Offer']};
    } catch (err) {
      console.log(`There is not such conversion from ${fromCurrencyId} to ${toCurrencyId}`);

      return;
    }
  },

  async getAllConversionRates() {
    const baseUrl = browser.params.tradingApiUrl;
    let body;
    const parsedSession = await this.getSession();
    const options = {
      method: 'GET',
      url: `${baseUrl}//market/conversionratefxmarkets`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    if (parsedSession) {
      body = await rp(options);
    }
    try {
      const bodyObj = JSON.parse(body);

      return bodyObj.ConversionRateFxMarkets;
    } catch (err) {
      console.log(err.message);

      return;
    }
  },

  async getAllWatchlists() {
    const baseUrl = browser.params.tradingApiUrl;
    let body;
    const parsedSession = await this.getSession();
    const options = {
      method: 'GET',
      url: `${baseUrl}/watchlists`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    if (parsedSession) {
      body = await rp(options);
    }
    try {
      const allwatchlists = JSON.parse(body).ClientAccountWatchlists
        .map((watchlist) => watchlist['WatchlistDescription']);
      allwatchlists.push('Popular Markets');

      return allwatchlists;
    } catch (err) {
      console.log(err.message);
    }
  },

  async getTagLookup() {
    const baseUrl = browser.params.tradingApiUrl;
    let body;
    const parsedSession = await this.getSession();
    const options = {
      method: 'GET',
      url: `${baseUrl}/market/taglookup`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    if (parsedSession) {
      body = await rp(options);
    }
    try {
      const bodyObj = JSON.parse(body);

      return bodyObj.Tags;
    } catch (err) {
      console.log(err.message);
    }
  },

  async deleteWatchlists() {
    const baseUrl = browser.params.tradingApiUrl;
    let parsedSession;

    return Promise.resolve()
      .then(() => this.getSession())
      .then((ps) => {
        parsedSession = ps;
        const options = {
          method: 'GET',
          url: `${baseUrl}/watchlists`,
          headers: {
            'Content-Type': 'application/json',
            UserName: parsedSession['username'],
            Session: parsedSession['sessionKey']
          }
        };
        if (parsedSession) {
          return rp(options);
        }
      })
      .then((body) => {
        const arrayPromises = [];
        const bodyObj = JSON.parse(body);

        bodyObj['ClientAccountWatchlists'].forEach((watchlist) => {
          const options = {
            method: 'POST',
            url: `${baseUrl}/watchlist/delete`,
            headers: {
              'Content-Type': 'application/json',
              UserName: parsedSession['username'],
              Session: parsedSession['sessionKey']
            },
            body: `{}`
          };
          options.body = JSON.stringify({
            WatchlistId: watchlist['WatchlistId']
          });

          arrayPromises.push(rp(options));
        });

        return Promise.all(arrayPromises)
          .then(() => bodyObj['ClientAccountWatchlists'].length, (err) => console.log(err.message));
      });
  },
  // previous method name 'deletePositionsByMarketName'
  async deletePositionsByMarketId(marketId) {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const options = {
      method: 'POST',
      url: null,
      headers: {
        Connection: 'keep-alive',
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      },
      body: `{}`
    };
    const ordersBodyObj = await this.getActiveOrders();
    const activeOrdersFromBody = ordersBodyObj.ActiveOrders.filter((order) => {
      if (order.TradeOrder) {
        return order.TradeOrder.MarketId === marketId;
      }
    });
    let iterator = 0;
    const deleteAllWithChecking = async(activeOrders) => {
      const promises = [];
      const multiplier = parseFloat((Math.random() * 0.02 + 1.00).toFixed(4));

      activeOrders.forEach((order) => {
        let bidPrice;
        let offerPrice;
        if (order.TradeOrder.Direction === 'sell') {
          bidPrice = order.TradeOrder.Price;
          offerPrice = parseFloat((order.TradeOrder.Price * multiplier).toPrecision(6));
        } else {
          bidPrice = parseFloat((order.TradeOrder.Price / multiplier).toPrecision(6));
          offerPrice = order.TradeOrder.Price;
        }
        options.url = `${baseUrl}/order/newtradeorder`;
        options.body = JSON.stringify({
          MarketId: order.TradeOrder.MarketId,
          Direction: order.TradeOrder.Direction === 'sell' ? 'buy' : 'sell',
          Close: [order.TradeOrder.OrderId],
          Quantity: order.TradeOrder.Quantity,
          BidPrice: bidPrice,
          OfferPrice: offerPrice,
          TradingAccountId: order.TradeOrder.TradingAccountId
        });
        promises.push(rp(options));
      });
      await Promise.all(promises);
      const ordersBodyObjNew = await this.getActiveOrders();
      const activeOrdersFromBodyNew = ordersBodyObjNew.ActiveOrders.filter((order) => {
        if (order.TradeOrder) {
          return order.TradeOrder.MarketId === marketId;
        }
      });
      if (activeOrdersFromBodyNew.length > 0 && iterator < 5) {
        iterator += 1;
        await helper.sleep(3000);
        console.log(`Trying to delete the market attempt ${iterator + 1}`);
        await deleteAllWithChecking(activeOrdersFromBodyNew);
      }
    };
    await deleteAllWithChecking(activeOrdersFromBody);
  },
  // previous method name 'deleteOrdersByMarketName'
  async deleteOrdersByMarketId(marketId) {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const options = {
      method: 'POST',
      url: null,
      headers: {
        Connection: 'keep-alive',
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      },
      body: `{}`
    };
    const ordersBodyObj = await this.getActiveOrders();
    const activeOrdersFromBody = ordersBodyObj.ActiveOrders.filter((order) => {
      if (order.StopLimitOrder) {
        return order.StopLimitOrder.MarketId === marketId;
      }
    });
    let iterator = 0;
    const deleteAllWithChecking = async(activeOrders) => {
      for (let i = 0; i < activeOrders.length; i += 1) {
        options.url = `${baseUrl}/order/cancel`;
        options.body = JSON.stringify({
          OrderId: activeOrders[i].StopLimitOrder.OrderId,
          TradingAccountId: activeOrders[i].StopLimitOrder.TradingAccountId
        });
        await Promise.resolve()
          .then(() => rp(options))
          .catch((err) => {
            console.log(`Can't delete order. Error statuse code: ${err.message}`);
          });
      }

      const activeOrdersFromBodyNew = (await this.getActiveOrders()).ActiveOrders.filter((order) => {
        if (order.StopLimitOrder) {
          return order.StopLimitOrder.MarketId === marketId;
        }
      });
      if (activeOrdersFromBodyNew.length > 0 && iterator < 5) {
        iterator += 1;
        await helper.sleep(3000);
        console.log(`Trying to delete the order attempt ${iterator + 1}`);
        await deleteAllWithChecking(activeOrdersFromBodyNew);
      }
    };
    await deleteAllWithChecking(activeOrdersFromBody);
  },

  async getPositionHistory(maxResults: number, accType: string) {
    const parsedSession = await this.getSession();
    const parsedAccount = await this.getAccount();
    const accPosition = accType === 'DFT' ? 1 : 0;

    return Promise.resolve()
      .then(() => {
        const baseUrl = browser.params.tradingApiUrl;
        const tradingAccountId = parsedAccount.TradingAccounts[accPosition].TradingAccountId;
        const options = {
          method: 'GET',
          url: `${baseUrl}/order/tradehistory?TradingAccountId=${tradingAccountId}&MaxResults=${maxResults}`,
          headers: {
            'Content-Type': 'application/json',
            UserName: parsedSession['username'],
            Session: parsedSession['sessionKey']
          }
        };
        if (parsedSession) {
          return rp(options);
        }
      })
      .then((data) => JSON.parse(data)['TradeHistory'])
      .catch((error) => {
        console.error(error.message);
      });
  },

  async getOrderHistory(maxResults: number, accType: string) {
    const parsedSession = await this.getSession();
    const parsedAccount = await this.getAccount();
    const accPosition = accType === 'DFT' ? 1 : 0;

    return Promise.resolve()
      .then(() => {
        const baseUrl = browser.params.tradingApiUrl;
        const tradingAccountId = parsedAccount.TradingAccounts[accPosition].TradingAccountId;
        const options = {
          method: 'GET',
          url: `${baseUrl}/order/stoplimitorderhistory?TradingAccountId=${tradingAccountId}&MaxResults=${maxResults}`,
          headers: {
            'Content-Type': 'application/json',
            UserName: parsedSession['username'],
            Session: parsedSession['sessionKey']
          }
        };
        if (parsedSession) {
          return rp(options);
        }
      })
      .then((data) => JSON.parse(data)['StopLimitOrderHistory'])
      .catch((error) => {
        console.log(error.message);
      });
  },

  async addNewPosition(marketName, direction, quantity, bidPrice, offerPrice, ifDone = [], positionMethodId = 1) {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const parsedAccount = await this.getAccount();
    const tradingAccountId = parsedAccount.TradingAccounts.filter((acc) => {
      if (marketName.indexOf('DFT') !== -1 || marketName.indexOf('Spread') !== -1) {
        return acc.TradingAccountType === 'Spread Betting';
      } else {
        return acc.TradingAccountType === 'CFD';
      }
    })[0].TradingAccountId;
    const options = {
      method: 'POST',
      url: `${baseUrl}/order/newtradeorder`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      },
      body: JSON.stringify({
        MarketId: idMatcher.market[marketName],
        Direction: direction,
        Quantity: quantity,
        BidPrice: parseFloat(bidPrice),
        OfferPrice: parseFloat(offerPrice),
        TradingAccountId: tradingAccountId,
        PositionMethodId: positionMethodId,
        IfDone: ifDone
      })
    };
    await rp(options)
      .then((resp) => {
        if (JSON.parse(resp).Status !== 1) {
          console.log(`Position haven't been created form first attempt. Try again`);

          return helper.sleep(5000)
            .then(() => rp(options));
        }
      }, (err) => {
        console.error(err.message);

        return helper.sleep(5000)
          .then(() => rp(options));
      });
  },

  async addNewOrder(marketName, direction, orderPrice, quantity, bidPrice, offerPrice, ifDone = [], positionMethodId = 1) {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const parsedAccount = await this.getAccount();
    const tradingAccountId = parsedAccount.TradingAccounts.filter((acc) => {
      if (marketName.indexOf('DFT') !== -1 || marketName.indexOf('Spread') !== -1) {
        return acc.TradingAccountType === 'Spread Betting';
      } else {
        return acc.TradingAccountType === 'CFD';
      }
    })[0].TradingAccountId;
    const options = {
      method: 'POST',
      url: `${baseUrl}/order/newstoplimitorder`,
      headers: {
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      },
      body: JSON.stringify({
        Applicability: 'gtc',
        BidPrice: parseFloat(bidPrice),
        Direction: direction,
        IfDone: ifDone,
        MarketId: idMatcher.market[marketName],
        OfferPrice: parseFloat(offerPrice),
        OrderId: 0,
        PositionMethodId: positionMethodId,
        Quantity: quantity,
        TradingAccountId: tradingAccountId,
        TriggerPrice: orderPrice,
        ExpiryDateTimeUTC: null,
        OcoOrder: null
      })
    };
    await rp(options)
      .then((resp) => {
        if (JSON.parse(resp).Status !== 1) {
          console.log(`Order haven't been created form first attempt. Try again`);

          return helper.sleep(5000)
            .then(() => rp(options));
        }
      }, (err) => {
        console.error(err.message);

        return helper.sleep(5000)
          .then(() => rp(options));
      });
  },

  async getBackendMultiDataByName(marketName, param, isPosition: boolean, marketId?) {
    const orderType = isPosition ? 'TradeOrder' : 'StopLimitOrder';
    const ordersBodyObj = await this.getActiveOrders();
    const activeOrdersFromBody = ordersBodyObj.ActiveOrders.filter((order) => {
      if (order[orderType]) {
        return order[orderType].MarketId === marketId || idMatcher.market[marketName];
      }
    });
    const params = activeOrdersFromBody.map((order) => {
      return order[orderType][param];
    });

    return params;
  },

  async getPriceAlerts() {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const options = {
      method: 'GET',
      url: `${baseUrl}/pricealert`,
      headers: {
        Connection: 'keep-alive',
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    const ordersBody = await rp(options);

    return JSON.parse(ordersBody);
  },

  async deleteAlert(alertId) {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const options = {
      method: 'POST',
      url: `${baseUrl}/pricealert/delete/${alertId}`,
      headers: {
        Connection: 'keep-alive',
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      }
    };
    await rp(options);
  },

  async clearPriceAlerts() {
    const alerts = await this.getPriceAlerts();
    const ids = alerts.PriceAlerts.map((alert) => alert.AlertId);
    ids.forEach(async(id) => await this.deleteAlert(id));
  },

  async clearPositionsAndOrders() {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const options = {
      method: 'POST',
      url: null,
      headers: {
        Connection: 'keep-alive',
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      },
      body: `{}`
    };
    const ordersBodyObj = await this.getActiveOrders();

    const tradeOrdersFromBody = ordersBodyObj.ActiveOrders.map((order) => {
      if (order.TradeOrder) {
        return order.TradeOrder;
      }
    }).filter((order) => {
      return !!order;
    });
    const stopLimitOrdersFromBody = ordersBodyObj.ActiveOrders.map((order) => {
      if (order.StopLimitOrder) {
        return order.StopLimitOrder;
      }
    }).filter((order) => {
      return !!order;
    });

    tradeOrdersFromBody.forEach(async(trade) => {
      let bidPrice;
      let offerPrice;
      if (trade.Direction === 'sell') {
        bidPrice = trade.Price;
        offerPrice = parseFloat((trade.Price * 1.005).toPrecision(6));
      } else {
        bidPrice = parseFloat((trade.Price / 1.005).toPrecision(6));
        offerPrice = trade.Price;
      }
      options.url = `${baseUrl}/order/newtradeorder`;
      options.body = JSON.stringify({
        MarketId: trade.MarketId,
        Direction: trade.Direction === 'sell' ? 'buy' : 'sell',
        Close: [trade.OrderId],
        Quantity: trade.Quantity,
        BidPrice: bidPrice,
        OfferPrice: offerPrice,
        TradingAccountId: trade.TradingAccountId
      });
      await rp(options)
        .catch((err) => {
          console.error(`Can't delete Position or order. Error status code: ${err}`);
        });
    });

    stopLimitOrdersFromBody.forEach(async(order) => {
      options.url = `${baseUrl}/order/cancel`;
      options.body = JSON.stringify({
        OrderId: order.OrderId,
        TradingAccountId: order.TradingAccountId
      });
      await rp(options)
        .catch((err) => {
          console.error(`Can't delete Position or order. Error status code: ${err}`);
        });
    });
  },

  async deleteSession() {
    const baseUrl = browser.params.tradingApiUrl;
    const parsedSession = await this.getSession();
    const options = {
      method: 'POST',
      url: `${baseUrl}/session/deleteSession`,
      headers: {
        Connection: 'keep-alive',
        'Content-Type': 'application/json',
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      },
      body: JSON.stringify({
        UserName: parsedSession['username'],
        Session: parsedSession['sessionKey']
      })
    };
    await rp(options)
      .then(() => null, (err) => console.log(err.message));
  }
};
