import { element, by, ElementFinder, protractor, browser } from 'protractor';
import { Panel } from './panel';
import { MarketRow } from '../elements/market';
import { helper } from '../../utils/helper';


export class WatchlistPanel extends Panel {
  private curList: List;
  private data = {
    confirmationMessage: by.css('.quantity__message'),
    addWatchlistButton: by.css('.add-watchlist'),
    tabHeader: {
      root: by.css('.watchlists-header'),
      columns: by.css('.watchlists-header__column-header:not(.market-information)'),
      'spread column': by.css('.watchlists-header__column-header:not(.market-information).spread')
    },
    popularMarkets: by.css('.watchlists-body-curated'),
    allLists: by.tagName('app-watchlist'),
    listsTitle: by.css('app-watchlist div[title]'),
    customLists: by.css('.watchlists-body__custom app-watchlist'),
    addWatchlist: {
      link: by.css('.add-watchlist'),
      input: by.css('.rename-watchlist>input'),
      clear: by.css('.clear-search'),
      errorMessage: by.css('.watchlist-header__validation')
    }
  };

  constructor(panelRoot: ElementFinder) {
    super(panelRoot);
    this.name = 'Watchlist';
  }

  get currentList() {
    return this.curList;
  }

  get tabHeader() {
    const self = this;

    return {
      async getColumnsNames() {
        const textArr: any = await element.all(self.data.tabHeader.columns).getText();

        return textArr.map(t => t.trim());
      },

      async scrollElementIntoView(elementName) {
        await self.container.element(self.data.tabHeader[elementName]).scrollIntoView();
      }
    };
  }

  async createNewWatchlist() {
    await element(this.data.addWatchlistButton).click();
  }

  async getElementText(elementName) {
    const items = {
      'create watchlist button': this.container.element(this.data.addWatchlistButton),
      'confirmation message': element(this.data.confirmationMessage),
      'error message': this.container.element(this.data.addWatchlist.errorMessage)
    };

    return (await items[elementName].getText()).trim();
  }

  getList(nameOrNumber) {
    let rootEl: ElementFinder;

    if (typeof nameOrNumber === 'number') {
      rootEl = element.all(this.data.allLists).get(nameOrNumber);
    } else {
      rootEl = element.all(this.data.allLists).filter((el) => {
        return el.element(by.css('.watchlist-header__title')).getText()
          .then((text) => {
            return text.toLowerCase().trim().includes(nameOrNumber.toLowerCase());
          });
      }).first();
    }

    this.curList = new List(rootEl);

    return this.curList;
  }

  async getWatchlistsNames() {
    const textArr: any = await this.container.all(this.data.listsTitle).getText();

    return textArr.map((t) => {
      if (t.includes('Popular Markets')) {
        t = 'Popular Markets';
      }

      return t.trim();
    });
  }

  getWatchlistCount() {
    return this.container.all(this.data.allLists).count();
  }
}

class List {
  private container: ElementFinder;
  private data = {
    header: by.css('.watchlist-header__title'),
    head: {
      root: by.css('.watchlist-header'),
      editIcon: by.css('.icon-edit'),
      trash: by.css('.icon-trash-can'),
      renameInput: by.css('.rename-watchlist > input'),
      undo: by.css('.icon-undo'),
      errorMessage: by.css('.watchlist-header__validation')
    },
    chevron: by.css('[class*="icon-chevron"]:not(.chevron-wrapper)'),
    marketsTab: {
      root: by.css('.watchlist-markets-container'),
      markets: {
        root: by.tagName('app-watchlist-market'),
        rows: by.css('.watchlist-market-row'),
        name: by.css('.market-name'),
        '1-click quantity': by.css('.quantity input'),
        '1-click quantity border': by.css('.quantity__field')
      },
      emptyContainer: by.css('.watchlist__empty-result-container')
    },
    addMarket:
      {
        input: by.css('.add-market>input'),
        searchResults: {
          root: by.css('.add-market__search-results'),
          rows: by.css('.add-market__search-result-item')
        },
        undoContainer: by.css('.watchlist-undo-container')
      },
    confirmationMessage: by.css('.quantity__message')

  };

  constructor(container: ElementFinder) {
    this.container = container;
  }

  getListElement() {
    return this.container;
  }

  getHead() {
    return this.container.element(this.data.head.root);
  }

  getEmptyContainer() {
    return this.container.element(by.css('.watchlist-markets-container--list'));
  }

  waitReady() {
    return this.container.waitReady(5000);
  }

  async refreshList() {
    console.log('empty');
  }

  async hover() {
    // await this.waitReady();
    await this.container.element(this.data.header).hover();
  }

  startEditingName() {
    return this.container.element(this.data.head.editIcon).click();
  }

  endEditingName() {
    return this.container.element(this.data.head.renameInput).sendKeys(protractor.Key.ENTER);
  }

  async undoDeleting() {
    await this.container.element(this.data.head.undo).click();

    return browser.actions().mouseMove(element(by.css('body')), { x: 0, y: 0 }).click().perform()
      .then(() => null, () => console.log('actions error'));
  }

  async putName(name: string, actionToCompleteEdit: string) {
    // const input = await element(this.data.head.renameInput).waitReady(3000);
    const input = element(this.data.head.renameInput);
    if (name !== 'default') {
      if (process.env.npm_config_browser === 'safari') {
        await browser.wait(async() => {
          await input.sendKeys(protractor.Key.BACK_SPACE);
          const val = await input.getAttribute('value');

          return val === '';
        }, 10000);
      } else {
        await input.sendKeys(protractor.Key.chord(protractor.Key.CONTROL, 'a'));
        await input.sendKeys(protractor.Key.DELETE);
      }
      await input.sendKeys(name);
    } else {
      // await helper.sleep(500);
    }
    if (actionToCompleteEdit === 'key enter') {
      return input.sendKeys(protractor.Key.ENTER);
    } else if (actionToCompleteEdit === 'do not complete') {
      return;
    } else {
      return browser.actions().mouseMove(element(by.css('body')), { x: 0, y: 0 }).click().perform()
        .then(() => null, () => console.log('actions error'));
    }
  }

  async editName(newName: string, actionToCompleteEdit: string) {
    await this.hover();
    // const icon = await this.container.element(this.data.head.editIcon).waitReady(2000);
    const icon = this.container.element(this.data.head.editIcon);
    await icon.click();
    // const input = await element(this.data.head.renameInput).waitReady(2000);
    const input = element(this.data.head.renameInput);
    if (process.env.npm_config_browser === 'safari') {
      await browser.wait(async() => {
        await input.sendKeys(protractor.Key.BACK_SPACE);
        const val = await input.getAttribute('value');

        return val === '';
      }, 10000);
    } else {
      await input.sendKeys(protractor.Key.chord(protractor.Key.CONTROL, 'a'));
      await input.sendKeys(protractor.Key.DELETE);
    }
    await input.sendKeys(newName);
    if (actionToCompleteEdit === 'key enter') {
      return input.sendKeys(protractor.Key.ENTER);
    } else if (actionToCompleteEdit === 'do not complete') {
      return;
    } else {
      return browser.actions().mouseMove(element(by.css('body')), { x: 0, y: 0 }).click().perform()
        .then(() => null, () => console.log('actions error'));
    }
  }

  isVisible(elem?: string) {
    const input = {
      'edit button': this.data.head.editIcon,
      'add to watch list text field': this.data.addMarket.input,
      'trash icon': this.data.head.trash,
      'edit input': this.data.head.renameInput,
      'undo icon': this.data.head.undo,
      'market from dropdown': this.data.addMarket.searchResults.rows,
      '1-click quantity': this.data.marketsTab.markets['1-click quantity'],
      'error message': this.data.head.errorMessage,
      'confirmation message': this.data.confirmationMessage
    };

    if (elem) {
      elem = elem.toLowerCase();

      if (elem === 'confirmation message') {
        return element(input[elem]).waitReady(2000)
          .then(() => true, () => false);
      }

      return this.container.element(input[elem]).waitReady(2000)
        .then(() => true, () => false);
    }

    return this.container.waitReady(2000)
      .then(() => true, () => false);
  }

  async getCssValue(name: string, cssProperty) {
    const input = {
      '1-click quantity': this.data.marketsTab.markets['1-click quantity'],
      '1-click quantity border': this.data.marketsTab.markets['1-click quantity border']
    };

    return (await this.container.element(input[name]).getCssValue(cssProperty)).trim();
  }

  async isListMarketsVisible() {
    // await this.container.waitReady(3000);

    return this.container.element(this.data.marketsTab.markets.root).isPresent();
  }

  async getName() {
    // await this.container.waitReady(3000);

    return (await this.container.element(this.data.header).getText()).trim();
  }

  async addMarketFromDropdown(num: number) {
    // await this.container.element(this.data.addMarket.searchResults.rows).waitReady(5000);
    await this.container.all(this.data.addMarket.searchResults.rows).get(num).click();
  }

  async getMarketFromDropdown(num: number) {
    // await this.container.element(this.data.addMarket.searchResults.rows).waitReady(5000);

    return (await this.container.all(this.data.addMarket.searchResults.rows).get(num).getText()).trim();
  }

  async isDeleteAvailable() {
    await this.container.waitReady(3000);
    await this.container.hover();
    const count = await this.container.all(this.data.head.trash).count();

    return count > 0;
  }

  async expand() {
    await this.container.waitReady(3000);
    const cls = await this.container.element(this.data.chevron).getAttribute('class');
    if (cls.includes('right')) {
      await this.container.element(this.data.chevron).click();
    } else {
      console.log('watchlist was already expanded');
    }
    await this.container.element(this.data.marketsTab.root).waitPresent(3000);
  }

  async collapse() {
    const cls = await this.container.element(this.data.chevron).getAttribute('class');
    if (cls.includes('down')) {
      await this.container.element(this.data.chevron).click();
    } else {
      console.log('watchlist was already collapsed');
    }
    await this.container.element(this.data.marketsTab.root).waitMissing();
  }

  async isExpanded() {
    const cls = await this.container.element(this.data.chevron).getAttribute('class');

    return cls.includes('down');
  }

  getMarketsCount() {
    return this.container.all(this.data.marketsTab.markets.rows).count();
  }

  async deleteWatchlist() {
    // await this.container.waitReady(3000);
    await this.container.hover();
    await this.container.element(this.data.head.trash).click();
  }

  async getAllMarketsTitles() {
    const textArr: any = await this.container.all(this.data.marketsTab.markets.name).getText();

    return textArr.map(t => t.trim());
  }

  async getAllMarketsIds() {
    const idArr: any = await this.container.all(this.data.marketsTab.markets.root).getAttribute('marketid');

    return idArr.map(t => parseInt(t.trim()));
  }

  async getLastAddedMarketId(num: number) {
    const idArr: any = await this.container.all(this.data.marketsTab.markets.root).getAttribute('marketid');

    return idArr.map(t => parseInt(t.trim()))[idArr.length - 1];
  }

  async addMarket(name: string) {
    await this.container.waitReady(3000);
    await this.container.hover();
    await this.container.element(this.data.addMarket.input).waitReady(3000);
    await this.container.element(this.data.addMarket.input).sendKeys(name);
    await this.container.element(this.data.addMarket.searchResults.rows).waitReady(5000);
    await this.container.element(this.data.addMarket.input).sendKeys(protractor.Key.DOWN);
    await this.container.element(this.data.addMarket.input).sendKeys(protractor.Key.ENTER);
  }

  async typeNameOfMarket(name: string, wait: boolean = true) {
    // await this.container.waitReady(3000);
    await this.container.hover();
    // await this.container.element(this.data.addMarket.input).waitReady(3000);
    await this.container.element(this.data.addMarket.input).click();
    await this.container.element(this.data.addMarket.input).clear();
    await this.container.element(this.data.addMarket.input).sendKeys(name);
    if (wait) {
      await this.container.element(this.data.addMarket.searchResults.rows).waitReady(10000);
    } else {
      // await helper.sleep(1000);
    }
  }

  getMarket(nameOrNumber, marketId?: number) {
    let marketRoot: ElementFinder;
    if (typeof nameOrNumber === 'number') {
      marketRoot = this.container.all(this.data.marketsTab.markets.root).get(nameOrNumber);
    } else {
      marketRoot = this.container.all(this.data.marketsTab.markets.root).filter((el) => {
        if (marketId) {
          return el.getAttribute('marketid').then((id) => {
            return id === String(marketId);
          });
        } else {
          return el.element(this.data.marketsTab.markets.name).getText()
            .then((text) => {
              return text.toLowerCase().trim() === nameOrNumber.toLowerCase();
            });
        }
      }).first();
    }

    return new MarketRow(marketRoot);
  }

  async getMarketPosition(marketName, num) {
    const positions = await this.container.all(this.data.marketsTab.markets.root).reduce(async(arr, el, i) => {
      const text = await el.element(this.data.marketsTab.markets.name).getText();
      if (text.toLowerCase().trim() === marketName.toLowerCase()) {
        arr.push(i);
      }

      return arr;
    }, []);

    return positions[num] + 1;
  }

  isMarketPresent(marketName) {
    return browser.wait(() => {
      return this.container.all(this.data.marketsTab.markets.root).filter((el) => {
        return el.element(this.data.marketsTab.markets.name).getText()
          .then((text) => {

            return text.toLowerCase().trim() === marketName.toLowerCase();
          });
      }).count()
        .then((count) => helper.sleepIfFalse(count > 0));
    }, 4000)
      .then(() => true, () => false);
  }

  async getEmptyText() {
    return (await this.container.element(this.data.marketsTab.emptyContainer).getText()).trim();
  }

  async clickList() {
    console.log('empty');
  }
}
