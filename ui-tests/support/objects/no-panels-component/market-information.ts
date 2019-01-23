import { browser, by, element, ElementFinder } from 'protractor';


export class MarketInformation {
  private container;
  private name: string;
  private data = {
    iframeRoot: by.tagName('iframe'),
    marketName: by.tagName('header > h1'),
    sections: {
      'key information document': by.css('[ng-controller="KIDCtrl"]'),
      'margin factor': by.css('[ng-controller="MarginFactorCtrl"]'),
      time: by.css('[ng-controller="HoursCtrl"]'),
      dealing: by.css('[ng-controller="DealingCtrl"]'),
      orders: by.css('[ng-controller="OrdersCtrl"]'),
      preferences: by.id('settings'),
      notes: by.css('[ng-controller="NotesCtrl"]'),
      version: by.css('.pull-right')
    }
  };

  constructor(container: ElementFinder) {
    this.container = container;
    this.name = 'Market information';
  }

  async getMarketName() {
    await this.container.element(this.data.iframeRoot).waitReady(15000);
    await browser.switchTo().frame(this.container.element(this.data.iframeRoot).getWebElement());
    await element(this.data.marketName).waitReady(20000);
    const text = (await element(this.data.marketName).getText()).trim();
    await browser.switchTo().defaultContent();

    return text;
  }

  async getSize() {
    return this.container.getSize();
  }

  async isElementPresent(name) {
    await this.container.element(this.data.iframeRoot).waitReady(15000);
    await browser.switchTo().frame(this.container.element(this.data.iframeRoot).getWebElement());
    await element(this.data.sections[name]).scrollIntoView();
    const visibility = element(this.data.sections[name]).waitReady(3000)
      .then(() => true, () => false);
    await browser.switchTo().defaultContent();

    return visibility;
  }
}
