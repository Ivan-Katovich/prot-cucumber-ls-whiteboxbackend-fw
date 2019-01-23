import { browser, element, by, ElementFinder } from 'protractor';
import { Panel } from './panel';
import { MarketRow } from '../elements/market';
import { helper } from '../../utils/helper';


export class PositionsAndOrdersPanel extends Panel {
  private curList: List;
  private data = {
    header: {
      root: by.css('.workspace-panel-header'),
      items: {
        root: by.tagName('app-positions-and-orders-header'),
        contents: by.tagName('div'),
        'header contents': by.css('.main-mode__header'),
        icon: by.css('.icon')
      },
    },
    positions: by.tagName('app-open-position-list'),
    orders: by.tagName('app-active-order-list'),
    'order history': by.tagName('app-order-history'), // to delete after 1.22
    'position history': by.tagName('app-trade-history'), // to delete after 1.22
    'price alerts': by.tagName('app-price-alert-list')
  };

  constructor(panelRoot: ElementFinder) {
    super(panelRoot);
    this.curList = this.getList('Positions');
    this.name = 'Positions And Orders';
  }

  get currentList() {
    return this.curList;
  }

  async getHeaderItemNames() {
    const textArr: any = await element(this.data.header.items.root).all(this.data.header.items['header contents']).getText();
    if (process.env.npm_config_browser.includes('safari')) {
      const upperCaseRegexp = new RegExp(/[^^\s][A-Z]/);

      return textArr.map((str) => {
        const matchRez = str.match(upperCaseRegexp);
        if (!matchRez) {
          return str;
        }
        const letterIndex = matchRez.index + 1;

        return [
          str.slice(0, letterIndex),
          str.slice(letterIndex)
        ].join(' ');
      });
    } else {
      return textArr.map(t => t.trim().replace(/ *\n */g, ' '));
    }
  }

  getList(listName) {
    listName = listName.toLowerCase();
    const root = this.container.element(this.data[listName]);
    this.curList = new List(listName, root);

    return this.curList;
  }

  async isItemActive(item) {
    const root = element(this.data.header.items.root);
    const listBtn = root.all(this.data.header.items.contents).filter((ls) => {
      return ls.getText()
        .then((text) => {
          return text.toLowerCase().trim().replace(/ ?\n ?| /g, '') === item.toLowerCase().replace(' ', '');
        });
    }).first();
    const cls = await listBtn.getAttribute('class');

    return cls.includes('main-mode__header--active');
  }

  isListVisible(listName) {
    listName = listName.toLowerCase();

    return this.container.element(this.data[listName]).waitReady(3000)
      .then(() => true, () => false);
  }

  async refreshList() {
    const root = element(this.data.header.items.root);
    const activeLabel = root.all(this.data.header.items.contents).filter((ls) => {
      return ls.getAttribute('class')
        .then((cls) => {
          return cls.trim().includes('active');
        });
    }).first();
    const listName = (await activeLabel.getText()).trim().toLowerCase();
    const priceAlertLabel = root.all(this.data.header.items.contents).get(2);
    if (process.env.npm_config_browser === 'edge') {
      await browser.executeScript(`$(arguments[0]).click()`, priceAlertLabel.getWebElement());
    } else {
      await priceAlertLabel.click();
    }
    await helper.sleep(500);
    await root.all(this.data.header.items.contents).filter((ls) => {
      return ls.getText()
        .then((text) => {
          return text.toLowerCase().trim().replace(/ ?\n ?| /g, '')
            .includes(listName.replace(/ ?\n ?| /g, ''));
        });
    }).first().click();
  }

  async clickActiveList() {
    const root = element(this.data.header.items.root);
    const activeListBtn = root.all(this.data.header.items.contents).filter((ls) => {
      return ls.getAttribute('class')
        .then((cls) => {
          return cls.trim().includes('active');
        });
    }).first();
    await activeListBtn.click();
  }

  async selectList(listName) {
    listName = listName.toLowerCase();
    const root = element(this.data.header.items.root);
    const listBtn = root.all(this.data.header.items.contents).filter((ls) => {
      return ls.getText()
        .then((text) => {
          return text.toLowerCase().trim().replace(/ ?\n ?| /g, '') === (listName.replace(' ', ''));
        });
    }).first();

    let cls: string;
    try {
      cls = (await listBtn.getAttribute('class')).trim();
      if (!cls.includes('main-mode__header--active')) {
        await listBtn.click();
      } else {
        console.log(' List was already selected');
      }
    } catch (err) {
      await helper.sleep(500);
      cls = (await listBtn.getAttribute('class')).trim();
      if (!cls.includes('main-mode__header--active')) {
        await listBtn.click();
      } else {
        console.log(' List was already selected');
      }
    }

    return this.getList(listName);
  }

  async selectView(view) {
    view = view.toLowerCase();
    const root = element(this.data.header.items.root);
    const cls = (await root.element(this.data.header.items.icon).getAttribute('class')).trim();
    if (view === 'history') {
      if (cls.includes('icon-clock-white')) {
        await root.element(this.data.header.items.icon).click();
      } else {
        console.log(' History view is already opened');
      }
    } else {
      if (cls.includes('icon-clock-black')) {
        await root.element(this.data.header.items.icon).click();
      } else {
        console.log(' Current view is already opened');
      }
    }
  }
}

export class ReportsPanel extends Panel {
  private curList: List;
  private data = {
    header: {
      root: by.css('.workspace-panel-header'),
      items: {
        root: by.tagName('app-reports-header'),
        contents: by.tagName('div'),
        'header contents': by.css('.main-mode__header'),
        icon: by.css('.icon')
      },
    },
    'position history': by.tagName('app-trade-history'),
    'order history': by.tagName('app-order-history'),
    'more history': by.tagName('.position-history-iframe')
  };

  constructor(panelRoot: ElementFinder) {
    super(panelRoot);
    this.curList = this.getList('Position History');
    this.name = 'Reports';
  }

  get currentList() {
    return this.curList;
  }

  async selectList(listName) {
    listName = listName.toLowerCase();
    const root = element(this.data.header.items.root);
    const listBtn = root.all(this.data.header.items.contents).filter((ls) => {
      return ls.getText()
        .then((text) => {
          return text.toLowerCase().trim().replace(/ ?\n ?| /g, '') === (listName.replace(' ', ''));
        });
    }).first();

    let cls: string;
    try {
      cls = (await listBtn.getAttribute('class')).trim();
      if (!cls.includes('main-mode__header--active')) {
        await listBtn.click();
      } else {
        console.log(' List was already selected');
      }
    } catch (err) {
      await helper.sleep(500);
      cls = (await listBtn.getAttribute('class')).trim();
      if (!cls.includes('main-mode__header--active')) {
        await listBtn.click();
      } else {
        console.log(' List was already selected');
      }
    }

    return this.getList(listName);
  }

  getList(listName) {
    listName = listName.toLowerCase();
    const root = this.container.element(this.data[listName]);
    this.curList = new List(listName, root);

    return this.curList;
  }

  async isItemActive(item) {
    const root = element(this.data.header.items.root);
    const listBtn = root.all(this.data.header.items.contents).filter((ls) => {
      return ls.getText()
        .then((text) => {
          return text.toLowerCase().trim().replace(/ ?\n ?| /g, '') === item.toLowerCase().replace(' ', '');
        });
    }).first();
    const cls = await listBtn.getAttribute('class');

    return cls.includes('main-mode__header--active');
  }

  isListVisible(listName) {
    listName = listName.toLowerCase();

    return this.container.element(this.data[listName]).waitReady(3000)
      .then(() => true, () => false);
  }
}

class List {
  private name;
  private container;
  private data = {
    tabHeader: {
      root: by.xpath('.//*[contains(@class,"list__header") or contains(@class,"history-header")]'),
      columns: by.css('div:not(.market-information):not(.delete)')
    },
    items: {
      root: by.xpath('.//*[contains(@class,"list__body") or contains(@class,"history-body")]'),
      firstHistoryItem: by.css('li:first-of-type div'),
    },
    markets: {
      root: null,
      name: by.css('.market-name')
    }
  };

  constructor(name, container) {
    this.name = name;
    this.container = container;
    switch (this.name) {
      case 'positions':
        this.data.markets.root = by.tagName('app-open-position-market');
        break;
      case 'orders':
        this.data.markets.root = by.tagName('app-active-order-market');
        break;
      case 'order history':
        this.data.markets.root = by.css('.at-market-row');
        break;
      case 'position history':
        this.data.markets.root = by.css('.at-market-row');
        break;
      case 'price alerts':
        this.data.markets.root = by.css('.price-alert-market');
        break;
      default:
        this.data.markets.root = by.tagName('app-open-position-market');
    }
  }

  async clickList() {
    await this.container.click();
  }

  async getColumnsName() {
    const textArray: any = await this.container.element(this.data.tabHeader.root).all(this.data.tabHeader.columns).getText();

    return textArray.map(t => t.trim());
  }

  async scrollElementIntoView(elementName) {
    const tabHeaders = {
      'limit tab column': by.css('.limit'),
      'market name column': by.css('.market-information'),
      'realised p&l column': by.css('.realised'),
      'last edit column': by.css('.last-edit')
    }
    await this.container.element(tabHeaders[elementName]).scrollIntoView();
  }

  async getFirstRowData() {
    const textArray: any = await this.container.element(this.data.items.root).all(this.data.items.firstHistoryItem).getText();

    return textArray.map(t => t.trim());
  }

  getClassName() {
    return this.container.getAttribute('class');
  }

  getMarket(nameOrNumber, marketId?: number) {
    let marketRoot: ElementFinder;
    if (typeof nameOrNumber === 'number') {
      marketRoot = this.container.all(this.data.markets.root).get(nameOrNumber);
    } else {
      marketRoot = element.all(this.data.markets.root).filter((el) => {
        if (marketId) {
          return el.getAttribute('marketid').then((id) => {
            return id === String(marketId);
          });
        } else {
          return el.all(this.data.markets.name).get(0).getText()
            .then((text) => {
              return text.toLowerCase().trim().includes(nameOrNumber.toLowerCase());
            }, async() => {
              await helper.sleep(1000);
              const text = await el.all(this.data.markets.name).get(0).getText();

              return text.toLowerCase().trim().includes(nameOrNumber.toLowerCase());
            });
        }
      }).first();
    }

    return new MarketRow(marketRoot);
  }

  getListName() {
    return this.name;
  }

  getMarketsCount(name: string) {
    name = name.toLowerCase();

    return this.container.all(this.data.markets.root).filter((el) => {
      return el.element(this.data.markets.name).getText()
        .then((text) => {
          return text.toLowerCase().trim().includes(name);
        });
    }).count();
  }

  getMarketsNames() {
    return this.container.all(this.data.markets.root).map((el) => {
      return el.element(this.data.markets.name).getText()
        .then((text) => {
          return text.trim();
        });
    });
  }

  async doesMarketExist(name) {
    name = name.toLowerCase();
    // await this.container.waitReady(3000);

    /* return browser.wait(() => {
      return this.container.all(this.data.markets.root).filter((el) => {
        return el.element(this.data.markets.name).getText()
          .then((text) => {
            return text.toLowerCase().trim().includes(name);
          });
      }).count()
        .then((count) => helper.sleepIfFalse(count > 0), 500);
    }, 10000)
      .then(() => true, () => false); */

    return this.container.all(this.data.markets.root).filter((el) => {
      return el.element(this.data.markets.name).getText()
        .then((text) => {
          return text.toLowerCase().trim().includes(name);
        });
    })
      .then((arr) => {
        return !!arr.length;
      });
  }

  async doesMarketAbsent(name) {
    name = name.toLowerCase();
    // await this.container.waitReady(3000);

    /* return browser.wait(() => {
      return this.container.all(this.data.markets.root).filter((el) => {
        return el.element(this.data.markets.name).getText()
          .then((text) => {
            return text.toLowerCase().trim().includes(name);
          }, () => {
            return false;
          });
      }).count()
        .then((count) => helper.sleepIfFalse(count === 0, 500));
    }, 10000)
      .then(() => true, () => false); */

    return this.container.all(this.data.markets.root).filter((el) => {
      return el.element(this.data.markets.name).getText()
        .then((text) => {
          return text.toLowerCase().trim().includes(name);
        });
    })
      .then((arr) => {
      return !arr.length;
    });
  }
}
