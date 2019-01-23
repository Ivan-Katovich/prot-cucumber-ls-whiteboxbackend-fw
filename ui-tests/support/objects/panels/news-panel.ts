import { Panel } from './panel';

import { by, element, ElementFinder, browser } from 'protractor';
import { helper } from '../../utils/helper';


export class NewsPanel extends Panel {
  private data = {
    listArticles: {
      body: {
        root: by.tagName('app-news-list'),
        empty: by.css('.news-list__empty-headlines'),
        loadingSpinner: by.css('.loader'),
        rows: {
          root: by.css('.news-headline'),
          timestamp: by.css('.relative-time'),
          title: by.css('.headline')
        }
      }
    },
    search: {
      input: by.css('.news-search__input input'),
      'X button': by.css('.news-search__input .icon-close'),
    },
    newsList: by.css('.news-list__view'),
    newDetail: {
      root: by.tagName('app-news-detail'),
      title: by.css('.news-detail__headline'),
      body: by.css('.news-detail__details'),
      backButton: by.css('.news-detail__back-button'),
      timestamp: by.css('.news-detail__date'),
    }
  };

  constructor(panelRoot: ElementFinder) {
    super(panelRoot);
    this.name = 'News feed';
  }

  async waitArticlesLoaded() {
    await this.container.element(this.data.listArticles.body.loadingSpinner).waitReady(1000)
      .then((el) => el.waitMissing(20000), () => null);
    await helper.sleep(200);
  }

  async isListArticlesVisible() {
    // await this.container.waitReady(2000);
    await this.waitArticlesLoaded();
    // await this.container.element(this.data.listArticles.body.root).waitReady(3000);

    return this.container.element(this.data.listArticles.body.root).all(this.data.listArticles.body.rows.timestamp).get(0).waitReady(3000)
      .then(() => true, () => false);
  }

  async scrollElementIntoView(elementName) {
    // await this.container.waitReady(2000);
    const elem = {
      'first article': this.container.all(this.data.listArticles.body.rows.root).get(0),
      'last article' : this.container.all(this.data.listArticles.body.rows.root).last(),
      'article title': this.container.element(this.data.newDetail.title),
    };
    await elem[elementName].scrollIntoView();
  }

  async getTimestampOfArticles() {
    // await this.container.waitReady(2000);
    await this.waitArticlesLoaded();
    let textArr: any;
    try {
      textArr = await this.container.element(this.data.listArticles.body.root)
        .all(this.data.listArticles.body.rows.timestamp).getText();
    } catch (err) {
      await helper.sleep(1000);
      textArr = await this.container.element(this.data.listArticles.body.root)
        .all(this.data.listArticles.body.rows.timestamp).getText();
    }

    return textArr.map(t => t.trim());
  }

  async getTitleOfArticles() {
    // await this.container.waitReady(2000);
    await this.waitArticlesLoaded();
    let textArr: any;
    try {
      textArr = await this.container.element(this.data.listArticles.body.root)
        .all(this.data.listArticles.body.rows.title).getText();
    } catch (err) {
      await helper.sleep(1000);
      textArr = await this.container.element(this.data.listArticles.body.root)
        .all(this.data.listArticles.body.rows.title).getText();
    }

    return textArr.map(t => t.trim());
  }

  async getArticlesCount() {
    // await this.container.waitReady(2000);
    await this.waitArticlesLoaded();
    // await this.container.element(this.data.listArticles.body.root).waitReady(3000);

    return this.container.element(this.data.listArticles.body.root).all(this.data.listArticles.body.rows.root).count();
  }

  async isVisibleElementDetailNews(name: string) {
    name = name.toLowerCase();
    const elements = {
      article: this.container.element(this.data.newDetail.root),
      'first article': this.container.all(this.data.listArticles.body.rows.root).get(0),
      'last article': this.container.all(this.data.listArticles.body.rows.root).last(),
      'article title': this.container.element(this.data.newDetail.title),
      'article text': this.container.element(this.data.newDetail.body),
      'button back': this.container.element(this.data.newDetail.backButton),
      timestamp: this.container.element(this.data.newDetail.timestamp),
    };

    // await this.container.waitReady(2000);

    return elements[name].waitReady(2000)
      .then(() => true, () => false);
  }

  async expandNews(numberNews: number) {
    // await this.container.waitReady(2000);
    await this.container.all(this.data.listArticles.body.rows.root).get(numberNews).click();
  }

  async clickButtonBack() {
    // await this.container.waitReady(2000);
    // const button = await this.container.element(this.data.newDetail.backButton).waitReady(2000);
    const button = this.container.element(this.data.newDetail.backButton);
    await button.click();
  }

  async clickSearchItems(item) {
    // await this.container.waitReady(2000);
    // const itemEl = await this.container.element(this.data.search[item]).waitReady(2000);
    const itemEl = this.container.element(this.data.search[item]);
    await itemEl.click();

  }

  async getSearchInputPlaceholder() {
    // await this.container.waitReady(2000);

    return (await this.container.element(this.data.search.input).getAttribute('placeholder')).trim();
  }

  async getElementLocation(elementName) {
    elementName = elementName.toLowerCase();
    const locators = {
      'news list': this.data.newsList,
      'search field': this.data.search.input
    };

    return element(locators[elementName]).getLocation();
  }

  async getEmptyText() {
    // await this.container.waitReady(2000);
    await this.waitArticlesLoaded();
    const results = {
      is: false,
      text: null
    };
    await this.container.element(this.data.listArticles.body.empty).waitReady(2000)
      .then(() => results.is = true, () => results.is = false);
    if (results.is) {
      results.text = (await this.container.element(this.data.listArticles.body.empty).getText()).trim();
    }

    return results;
  }

  async fillSearchInputWithValue(value) {
    // await this.container.waitReady(2000);
    await this.container.element(this.data.search.input).sendKeys(value);
  }
}
