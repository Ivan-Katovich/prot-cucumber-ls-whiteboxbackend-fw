import { by, ElementFinder } from 'protractor';


export class WatchlistContainer {
  private container;
  private name: string;
  private data = {
    'watchlist name': by.css('.watchlist-selector'),
    'dropdown arrow': by.css('.icon-triangle-down'),
    'dropdown body': by.css('.watchlist-selector__options'),
    watchlists: by.css('.watchlist-selector__watchlist:not(.watchlist-selector__watchlist--hide), .watchlist-selector__name'),
    dropdown: by.css('.watchlist-selector'),
    marketsName: by.css('.market-name')
  };

  constructor(container: ElementFinder) {
    this.container = container;
    this.name = 'Watchlist container';
  }

  isVisible() {
    return this.container.waitReady(2000)
      .then(() => true, () => false);
  }

  isElementPresent(elementName) {
    return this.container.element(this.data[elementName]).waitReady(2000)
      .then(() => true, () => false);
  }

  async getNameMarket(positionNumber: number) {
    await this.container.all(this.data.marketsName).get(positionNumber).waitReady(3000);

    return (await this.container.all(this.data.marketsName).get(positionNumber).getText()).trim();
  }

  async clickOnElement(elementName) {
    const el = await this.container.element(this.data[elementName]).waitReady(2000);
    await el.click();
  }

  async getWatchlistDropdownOptions() {
    return this.container.all(this.data.watchlists).getText();
  }

  async switchToWatchlist(watchlistName) {
    const watchlist = this.container.all(this.data.watchlists).filter((elem) => {
      return elem.getText()
        .then((text) => {
          return text.trim() === watchlistName;
        });
    }).first();
    // watchlist.waitReady(2000);
    await watchlist.click();
  }
}
