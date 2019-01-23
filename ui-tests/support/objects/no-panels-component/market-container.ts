import { browser, by, ElementFinder } from 'protractor';
import { MarketRow } from '../elements/market';


export class MarketContainer {
  private container;
  private name: string;
  private data = {
    marketsName: by.css('.market-name'),
    marketsListItem: by.css('app-markets-list-item'),
    'more icon': by.css('.icon-more'),
    'markets dropdown': by.css('.more-dropdown__content'),
    marketsNameInDropdown: by.css('.more-dropdown__content__item')
  };

  constructor(container: ElementFinder) {
    this.container = container;
    this.name = 'Market container';
  }

  isVisible() {
    return this.container.waitReady(2000)
      .then(() => true, () => false);
  }

  async isElementPresent(elementName) {
    return this.container.element(this.data[elementName]).isPresent();
  }

  async getNameMarket(positionNumber: number, isFromDropdown?: string) {
    if (!process.env.npm_config_browser.includes('safari')) {
      await this.container.all(this.data.marketsListItem).get(positionNumber).element(this.data.marketsName).waitReady(15000);
    }
    if (isFromDropdown) {
      return (await this.container.all(this.data.marketsNameInDropdown).get(positionNumber).getText()).trim();
    } else {
      return (await this.container.all(this.data.marketsListItem).get(positionNumber).element(this.data.marketsName).getText()).trim();
    }
  }

  getMarket(marketNameOrNumber, isFromDropdown?: string) {
    let marketRoot: ElementFinder;
    if (typeof marketNameOrNumber === 'number') {
      if (isFromDropdown) {
        marketRoot = this.container.all(this.data.marketsNameInDropdown).get(marketNameOrNumber);
      } else {
        marketRoot = this.container.all(this.data.marketsListItem).get(marketNameOrNumber);
      }
    } else {
      marketRoot = this.container.all(this.data.marketsListItem).filter((elem) => {
        return elem.getText()
          .then((text) => {
            return text.trim() === marketNameOrNumber;
          });
      }).first();
    }

    return new MarketRow(marketRoot);
  }

  async getAllMarketsNames(isFromDropdown?: string) {
    let textArr;
    if (isFromDropdown) {
      textArr = await this.container.all(this.data.marketsNameInDropdown).getText();
    } else {
      textArr = await this.container.all(this.data.marketsName).getText();
    }

    return textArr.map(t => t.trim());
  }

  async selectMarketFromDropdown(positionNumber) {
    if (process.env.npm_config_browser === 'edge') {
      const marketElement = this.container.all(this.data.marketsNameInDropdown).get(positionNumber);
      await browser.executeScript(`$(arguments[0]).click()`, marketElement.getWebElement());
    } else {
      const marketElement = await this.container.all(this.data.marketsNameInDropdown).get(positionNumber).waitReady(20000);
      await marketElement.click();
    }
  }

  async clickOnElement(elementName) {
    const el = await this.container.element(this.data[elementName]).waitReady(2000);
    // const el = this.container.element(this.data[elementName]);
    await el.click();
  }
}
