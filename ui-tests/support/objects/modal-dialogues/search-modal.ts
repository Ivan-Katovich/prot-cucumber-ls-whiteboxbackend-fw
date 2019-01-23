import { browser, element, by, ElementFinder, protractor } from 'protractor';
import { MarketRow } from '../elements/market';
import { helper } from '../../utils/helper';
import { Dropdown } from '../elements/dropdown';


export class SearchModal {
  protected container: ElementFinder;
  protected data = {
    header: by.css('.market-search-modal__showing-panel'),
    markets: by.tagName('app-market-search-table-row'),
    'market names': by.tagName('app-market-search-table-row .name__value'),
    'browse markets': by.css('.market-search-modal__footer'),
    'loading spinner': by.css('.loader'),
    'result header': by.css('.search-results__column--header'),
    'product type list': by.css('.product-types__list span'),
    'product type filter': {
      root: by.tagName('app-product-type-filter'),
      label: by.css('.product-types__list span'),
      dropdown: by.css('.product-types__dropdown'),
      items: by.css('.product-types__dropdown-item'),
      toggle: by.css('.product-types__dropdown-options-toggle')
    },
    dropdown: by.css('body>div.dropdown__content'),
    'filter items': by.css('.market-filters__item'),
    'active market filter item': by.css('.market-filters__item--active'),
    'empty result': by.css('.empty-result')
  };

  constructor(container = element(by.css('.market-search-modal'))) {
    this.container = container;
  }

  async getHeaderBackground() {
    // await this.container.element(this.data.header).waitReady(3000);

    return this.container.element(this.data.header).getCssValue('background-color');
  }

  isVisible() {
    return this.container.waitReady(3000)
      .then(() => true, () => false);
  }

  async getResultMessage(name) {
    return (await this.container.element(this.data[name]).getText()).trim();
  }

  async isElementVisible(name) {
    return this.container.element(this.data[name]).waitReady(3000)
      .then(() => true, () => false);
  }

  async getElementText(name) {
    const el = await this.container.element(this.data[name]).waitReady(3000);

    return (await el.getText()).trim();
  }

  getMarket(nameOrNumber, marketId?) {
    let marketRoot: ElementFinder;
    if (typeof nameOrNumber === 'number') {
      marketRoot = this.container.all(this.data.markets).get(nameOrNumber);
    } else {
      marketRoot = element.all(this.data.markets).filter((el) => {
        if (marketId) {
          return el.getAttribute('marketid')
            .then((id) => {
              return id === String(marketId);
            });
        } else {
          return el.element(by.css('.name')).getText()
            .then((text) => {
              return text.toLowerCase().trim() === nameOrNumber.toLowerCase();
            });
        }
      }).first();
    }

    return new MarketRow(marketRoot);
  }

  getMarketsCount() {
    return this.container.all(this.data.markets).count();
  }

  async getAllMarketsTitles() {
    const textArr: any = await this.container.all(this.data['market names']).getText();

    return textArr.map(t => t.trim());
  }

  async getAllMarketsIds() {
    const idArr: any = await this.container.all(this.data.markets).getAttribute('marketid');

    return idArr.map(t => parseInt(t.trim()));
  }

  async click(on: string) {
    on = on.toLowerCase();
    // const el = await this.container.element(this.data[on]).waitReady(3000);
    const el = this.container.element(this.data[on]);
    await el.click();
  }

  async waitForMarketsLoading() {
    try {
      const el = await this.container.element(this.data['loading spinner']).waitReady(2000);
      await el.waitMissing(30000);
    } catch (err) {}
    await helper.sleep(200);
  }

  async selectProductTypeFilter(optionName) {
    optionName = optionName.toLowerCase();
    await this.container.element(this.data['product type filter'].label).click();

    return new Dropdown().select(optionName);
  }

  async isElementPresent(elementName) {
    const elements = {
      'market dropdown': element(this.data.dropdown),
    };

    return elements[elementName].waitReady(10000).then(() => true, () => false);
  }

  async setIncludeOptions(state: string) {
    await this.container.element(this.data['product type filter'].label).click();
    await new Dropdown().setIncludeOptions(state);
  }

  selectMarketFilter(optionName) {
    optionName = optionName.toLowerCase();

    return this.container.all(this.data['filter items']).filter((item) => {
      return item.getText()
        .then((text) => text.toLowerCase().trim() === optionName);
    }).first().click();
  }

  async getProductTypeFilterOption() {
    return await this.container.element(this.data['product type filter'].label).getText();
  }

  async getMarketFilterOption() {
    const el = this.container.element(this.data['active market filter item']);
    const cls = await el.getAttribute('class');

    return cls.includes('disabled') ? false : await el.getText();
  }

  async getIncludeOptionsToggleStatus() {
    await this.container.element(this.data['product type filter'].label).click();

    return await new Dropdown().getToggleStatus();
  }
}

