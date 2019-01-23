import { browser } from 'protractor';
import { readFileSync, createWriteStream, writeFileSync } from 'fs';
import { results } from '../../test-layer/results';
import * as moment from 'moment';
import * as sendConstructor from 'gmail-send';
import { environment } from './../../configs/data/environment';


export let helper = {
  async browserClearing() {
    await browser.executeScript('window.sessionStorage.clear();');
    await browser.executeScript('window.localStorage.clear();');
    await browser.manage().deleteAllCookies();
  },

  createScreenshot(name) {
    const fullName = `${name}-${Math.round(Math.random() * 899 + 100)}.png`;
    console.log(fullName);

    return browser.takeScreenshot().then(function(png) {
      const stream = createWriteStream(`ui-tests/reports/${fullName}`);
      stream.write(new Buffer(png, 'base64'));
      stream.end();
    });
  },

  specsBuilder() {
    let specs = [];
    if (process.env.npm_config_rerun) {
      const text = readFileSync(`${process.cwd()}/ui-tests/@rerun.txt`, `utf8`);
      const arrOfPathes = text.split('\n');
      specs = arrOfPathes.filter((path) => {
        if (path) {
          return path;
        }
      }).map((path) => {
        if (process.env.npm_config_browser === 'safari') {
          return `${process.cwd()}/${path}`;
        } else {
          return `${process.cwd()}\\${path}`;
        }
      });
      console.log('Rerun specs:', specs);
    } else {
      specs = [
        `${process.cwd()}/ui-tests/test-layer/cucumber-tests/features/*.feature`,
        `${process.cwd()}/ui-tests/test-layer/cucumber-tests/features/**/*.feature`,
        `${process.cwd()}/ui-tests/test-layer/cucumber-tests/features/**/**/*.feature`
      ];
    }

    return specs;
  },

  reportBuilder() {
    try {
      const rerunJson = readFileSync(`${process.cwd()}/ui-tests/results-rerun.json`, 'utf8');
      const rerunArr = JSON.parse(rerunJson);
      const reportJson = readFileSync(`${process.cwd()}/ui-tests/results.json`, 'utf8');
      const reportArr = JSON.parse(reportJson);
      rerunArr.forEach((featureRerun) => {
        featureRerun.elements.forEach((scenarioRerun) => {
          scenarioRerun.name = `${scenarioRerun.name} (RERUN)`;
        });
      });
      rerunArr.forEach((featureRerun) => {
        featureRerun.elements.forEach((scenarioRerun) => {
          reportArr.forEach((feature, i) => {
            feature.elements.forEach((scenario, j) => {
              if (scenarioRerun.id === scenario.id && scenarioRerun.line === scenario.line) {
                reportArr[i].elements[j] = scenarioRerun;
              }
            });
          });
        });
      });
      writeFileSync(`${process.cwd()}/ui-tests/results.json`, JSON.stringify(reportArr, null, 2));
    } catch (err) {}
  },

  smallResultsBuilder() {
    const fileName = process.env.npm_config_rerun ? 'small-results-data-rerun.json' : 'small-results-data.json';
    const path = `${process.cwd()}/ui-tests/${fileName}`;
    if (process.env.npm_config_rerun) {
      results.tags = this.getSmallResults('run').tags;
    } else {
      results.tags = process.env.npm_config_tags;
    }
    try {
      writeFileSync(path, JSON.stringify(results, null, 2));
    } catch (err) {}
  },

  getSmallResults(type) {
    try {
      const fileName = type === 'rerun' ? 'small-results-data-rerun.json' : 'small-results-data.json';
      const smallResults = readFileSync(`${process.cwd()}/ui-tests/${fileName}`, 'utf8');

      return JSON.parse(smallResults);
    } catch (err) {
      return {
        version: null,
        tags: '',
        passed: 0,
        failed: 0,
        start: moment(),
        duration: 0,
        time: ''
      };
    }
  },

  sleep(timeout) {
    return new Promise(function(resolve, reject) {
      setTimeout(() => {
        resolve();
      }, timeout);
    });
  },

  async sleepIfFalse(is: boolean, time: number = 200) {
    if (!is) {
      return this.sleep(time)
        .then(() => is);
    } else {
      return is;
    }
  },

  /**
   * Generate random 10 char string
   */
  getRandomString(): string {
    let str = '';

    while (str.length !== 10) {
      str = Math.random().toString(32).slice(2);
    }

    return str;
  },

  alertsReset() {
    return browser.executeScript(`window.alert = function(){};
        Window.prototype.alert = function(){};`);
  },

  constructMailReportData() {
    const res = this.getSmallResults('run');
    if (process.env.npm_config_rerun) {
      const rerunRes = this.getSmallResults('rerun');
      res.passed = res.passed + rerunRes.passed;
      res.failed = res.failed - rerunRes.passed;
      res.rerunTime = rerunRes.time;
    }

    return res;
  },

  sendMail() {
    const envFullName = {
      local: 'LOCAL',
      ppe: 'PRE PRODUCTION',
      stg: 'STAGING',
      qat: 'QAT',
      live: 'LIVE',
      dev: 'DEVELOPMENT'
    };
    const smallReport = this.constructMailReportData();
    const send = sendConstructor({
      user: 'gainmercury2018@gmail.com',
      pass: 'Dadgolol433!',
      to: ['ivan.katovich@itechart-group.com',
        'ihar.stsepkin@itechart-group.com',
        'yuliya.antipirovich@itechart-group.com',
        'Praveen.Chadalavada@GAINCapital.com',
        'anton.mianshutkin@itechart-group.com',
        'denis.podgorny@itechart-group.com',
        'maksim.marasanau@itechart-group.com',
        'Sergey.Bondar@itechart-group.com'
        ],
      subject: 'Test report',
      text: `
          Mercury Webtrader Test Automation Report
      =================================================
      global tags: ${smallReport.tags}
      tested environment: ${envFullName[process.env.npm_config_env]}
      app version: ${smallReport.version}
      tested browser: ${process.env.npm_config_browser}
      account: ${environment[process.env.npm_config_env].login}
      starts: ${moment(smallReport.start).format('MMMM Do YYYY, h:mm:ss a')}
      tests passed: ${smallReport.passed}
      tests failed: ${smallReport.failed}
      execution time: ${smallReport.time}
      rerun execution time: ${smallReport.rerunTime ? smallReport.rerunTime : ''}
      =================================================
      `,
      files: './ui-tests/reports/cucumber-alternative/cucumber_report.html',
    });

    return new Promise((resolve, reject) => {
      send({}, function(err, res) {
        console.log('sendMail executed err:', err, '; res:', res);
        resolve();
      });
    });
  },

  windowCount(count) {
    return async() => {
      const tabs = await browser.getAllWindowHandles();

      return tabs.length === count;
    };
  },

  // should recieve 2 objects with top, bottom, left and right properties
  isInside(obj, rootObj) {
    let is = true;
    if (obj.top < rootObj.top || obj.bottom > rootObj.bottom || obj.left < rootObj.left || obj.right > rootObj.right) {
      is = false;
    }

    return is;
  }
};

export async function getValue(value) {
  // if (!isNaN(parseFloat(value))) {
  if (!value.match(/[A-z\s]+/)) {
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
