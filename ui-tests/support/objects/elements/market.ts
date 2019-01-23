/* tslint:disable:max-line-length */
import { browser, element, by, ElementFinder, protractor } from 'protractor';
import { helper } from '../../utils/helper';

export class MarketRow {
  protected container: ElementFinder;
  protected data = {
    direction: by.css('.direction'),
    'direction icon': by.css('.direction-icon--buy,.direction-icon--sell'),
    'distance away': by.css('.distance-away'),
    name: by.css('.market-name,.name'),
    nameValue: by.css('.market-name,.name__value'),
    position: by.css('.position'),
    unrealised: by.css('.unrealised'),
    'bid price': by.xpath('.//td[contains(@class,"price")][1]'),
    'ask price': by.xpath('.//td[contains(@class,"price")][2]'),
    date: by.css('.date'),
    'date set': by.css('.date-set'),
    expiry: by.css('.expiry'),
    price: by.css('.price'),
    type: by.css('.type'),
    status: by.css('.status'),
    'realised profit/loss': by.css('.realised'),
    'pip/point pl': by.css('.pip-point-pl'),
    'last-edit': by.css('.last-edit'),
    'opening price': by.css('.opening-price'),
    'current price': by.css('.current-price'),
    'order price': by.css('.trigger-price'),
    'trigger price': by.css('.trigger-price'),
    'stop price': by.css('.stop'),
    'limit price': by.css('.limit'),
    delete: by.css('.delete'),
    'remove icon': by.css('.icon-trash-can'),
    close: by.css('.close-market'),
    'delete confirm': by.css('.delete .close-single-confirm'),
    'delete cancel': by.css('.delete .close-market-cancel'),
    'sell hover container': by.css('.sell>.hover-container'),
    'buy hover container': by.css('.buy>.hover-container'),
    sell: by.css('.sell'),
    'sell on browse': by.css('.price--sell.clickable-price'),
    buy: by.css('.buy'),
    'buy on browse': by.css('.price--buy.clickable-price'),
    change: by.css('.change'),
    high: by.css('.high'),
    low: by.css('.low'),
    spread: by.css('.spread'),
    quantity: by.css('.quantity'),
    '1-click quantity': by.css('.quantity input'),
    'quantity border': by.css('.quantity__field'),
    'dropdown arrow': by.css('.icon-triangle-down'),
    'squares icon': by.css('.icon-productpage'),
    'dropdown menu': by.css('body>div.dropdown__content'),
    row: by.css('.watchlist-market-row'),
    actions: by.css('.actions'),
    'edit icon': by.css('app-active-order-market .icon-edit'),
    multi: {
      'plus icon': by.css('.expand'),
      'close icon': by.css('.collapse'),
      submarkets: by.css('.open-position-market__sub-item-row,.active-order-market__sub-item-row')
    },
    'plus icon': by.css('.icon-plus')
  };

  constructor(container: ElementFinder) {
    this.container = container;
  }

  async getPlaceholder(name) {
    return (await this.container.element(this.data[name]).getAttribute('placeholder')).trim();
  }

  async getId() {
    return (await this.container.getAttribute('marketid')).trim();
  }

  async clickMarketContainerElement() {
    await this.container.click();
  }

  async contextClick(on: string) {
    on = on.toLocaleLowerCase();
    await this.container.scrollIntoView();
    await this.container.hover();
    await this.container.all(this.data[on]).get(0).contextClick();
  }

  async click(on: string) {
    on = on.toLocaleLowerCase();
    try {
      await this.container.scrollIntoView();
      await this.container.hover();
      if (process.env.npm_config_browser === 'edge') {
        const el = this.container.all(this.data[on]).get(0);
        if (on === 'dropdown arrow') {
          await browser.actions().mouseMove(el).mouseDown().mouseUp().perform();
        } else {
          await browser.executeScript(`$(arguments[0]).click()`, el.getWebElement());
        }
      } else {
        await this.container.all(this.data[on]).get(0).click();
      }
    } catch (err) {
      await helper.sleep(500);
      await this.container.scrollIntoView();
      await this.container.hover();
      if (process.env.npm_config_browser === 'edge') {
        const el = this.container.all(this.data[on]).get(0);
        if (on === 'dropdown arrow') {
          await browser.actions().mouseMove(el).mouseDown().mouseUp().perform();
        } else {
          await browser.executeScript(`$(arguments[0]).click()`, el.getWebElement());
        }
      } else {
        await this.container.all(this.data[on]).get(0).click();
      }
    }
  }

  async getMarketElement() {
    await this.container.waitPresent(5000);

    return this.container.element(this.data.row);
  }

  async getName(scroll = true) {
    // await this.container.waitPresent(5000);
    if (scroll) {
      await this.container.scrollIntoView();
    }

    return (await this.container.all(this.data.nameValue).get(0).getText()).trim();
  }

  async getText(on) {
    await this.container.waitPresent(5000);
    await this.container.scrollIntoView();
    /* await browser.wait(() => {
      return this.container.all(this.data[on]).get(0).getText()
        .then((text) => text.trim() !== '—', () => false)
        .then((is) => helper.sleepIfFalse(is, 1000));
    }, 20000); */

    return (await this.container.all(this.data[on]).get(0).getText()).trim();
  }

  async getLocation(type) {
    return await this.container.all(this.data[type]).get(0).getLocation();
  }

  async getPrice(type) {
    /* await this.container.waitPresent(5000);
    await browser.wait(() => {
      return this.container.all(this.data[type]).get(0).getText()
        .then((text) => text.trim() !== '—', () => false)
        .then((is) => helper.sleepIfFalse(is, 1000));
    }, 20000); */

    return (await this.container.all(this.data[type]).get(0).getText()).trim();
  }

  async getUnrealisedColor() {
    await this.container.all(this.data.unrealised).get(0).element(by.css('.open-position-market__currency')).waitReady(15000);

    return this.container.all(this.data.unrealised).get(0).element(by.css('.open-position-market__currency')).getCssValue('color');
  }

  getPositionColor() {
    // await this.container.element(by.css('.rectangle')).waitReady(3000);

    return this.container.element(by.css('.rectangle')).getCssValue('background-color');
  }

  getDirectionColor() {
    return this.container.element(this.data['direction icon']).getCssValue('background-color');
  }

  async hover() {
    // await this.container.waitPresent(5000);
    await this.container.scrollIntoView();
    await this.container.hover();
  }

  async scrollTo() {
    // await this.container.waitPresent(15000);
    await this.container.scrollIntoView();
  }

  hoverElement(type) {
    type = type.toLowerCase();

    return this.container.element(this.data[type]).hover();
  }

  async getRowColor() {
    const cls = (await this.container.getAttribute('class')).trim();
    const tagName = (await this.container.getTagName()).trim();
    if (cls.includes('history-body__item')) {
      return this.container.getCssValue('background-color');
    } else if (tagName === 'app-market-search-table-row') {
      return this.container.element(by.css('.table__row-body')).getCssValue('background-color');
    } else {
      return this.container.element(by.css('.at-market-row,.watchlist-market-row')).getCssValue('background-color');
    }
  }

  getSubItemRowColor() {
    return this.container.getCssValue('background-color');
  }

  getElementColor(type: string) {
    type = type.toLowerCase();

    const input = {
      sell: this.data['sell hover container'],
      'sell on browse': this.data['sell on browse'],
      buy: this.data['buy hover container'],
      'buy on browse': this.data['buy on browse'],
    };

    return this.container.element(input[type]).getCssValue('background-color');
  }

  async getCssValue(name: string, cssProperty) {
    return (await this.container.element(this.data[name]).getCssValue(cssProperty)).trim();
  }

  isElementVisible(name) {
    return this.container.all(this.data[name]).get(0).waitReady(2000)
      .then(() => true, () => false);
  }

  async expandDropdown() {
    if (process.env.npm_config_browser.includes('firefox') || process.env.npm_config_browser.includes('safari')) {
      const innerHtml: string = (await browser.executeScript('return arguments[0].innerHTML;', this.container.getWebElement())).toString();
      if (innerHtml.includes('table__row-body')) {
        await browser.executeScript(`$(arguments[0]).attr("class","table__row-body table__row-body--selected");`, this.container.element(by.tagName('tr')).getWebElement());
      } else {
        await this.hover();
      }
    } else {
      await this.hover();
    }
    try {
      await this.container.element(this.data['dropdown arrow']).click();
      // await element(this.data['dropdown menu']).waitReady(2000);
    } catch (err) {
      await helper.sleep(500);
      await this.container.element(this.data['dropdown arrow']).click();
      // await element(this.data['dropdown menu']).waitReady(2000);
    }
  }

  async isMulti() {
    let isMult = false;
    const plusIcon = await this.container.element(this.data.multi['plus icon']).isPresent();
    const closeIcon = await this.container.element(this.data.multi['close icon']).isPresent();
    const submarketsCount = await this.container.all(this.data.multi.submarkets).count();
    if (plusIcon || closeIcon || submarketsCount > 0) {
      isMult = true;
    }

    return isMult;
  }

  async expand() {
    await this.container.element(this.data.multi['plus icon']).click()
      .then(null, (err) => {
        console.log('Market is not amalgamated or has been already expanded');
      });
  }

  async collapse() {
    await this.container.element(this.data.multi['close icon']).click()
      .then(null, (err) => {
        console.log('Market is not amalgamated or has been already collapsed');
      });
  }

  async isExpanded() {
    const isMulti = await this.isMulti();
    if (isMulti) {
      return this.container.element(this.data.multi['close icon']).isPresent();
    }
  }

  getSubMarket(num) {
    const marketRoot = this.container.all(this.data.multi.submarkets).get(num);

    return new MarketRow(marketRoot);
  }

  getSubMarketsCount() {
    return this.container.all(this.data.multi.submarkets).count();
  }

  async getSubMarketsText(on) {
    const textArr: any = await this.container.all(this.data.multi.submarkets).all(this.data[on]).getText();

    return textArr.map(t => t.trim());
  }

  async getInputValue(name: string, value) {
    name = name.toLowerCase();
    const el = this.container.element(this.data[name]);
    await el.waitReady(10000);

    return await el.getAttribute('value');
  }

  async fillInputWithValue(name: string, value) {
    name = name.toLowerCase();
    const el = this.container.element(this.data[name]);
    await el.waitReady(10000);
    await browser.wait(async() => {
      await el.clear();

      return helper.sleepIfFalse((await el.getAttribute('value')) === '');
    }, 10000);

    await el.sendKeys(value);
  }
}

