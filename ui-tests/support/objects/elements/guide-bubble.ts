import { browser, element, by, ElementFinder, protractor } from 'protractor';


export class GuideBubble {
  protected container: ElementFinder;
  protected data = {
    'back later link': by.css('.tip__back-later'),
    'button next': by.css('.tip__next-button'),
    'button previous': by.css('.tip__previous-button'),
    'finish button': by.css('.tip__finish-button'),
    description: by.css('.tip__description'),
    name: by.css('.tip__name'),
    counter: by.css('.tip__counter')
  };

  constructor(container = element(by.tagName('app-helptip'))) {
    this.container = container;
  }

  isVisible() {
    /* return browser.wait(() => {
      return this.container.isDisplayed()
        .then((is) => is, () => false);
    }, 1000)
      .then(() => true, () => false); */

    return this.container.isDisplayed()
      .then((is) => is, () => false);
  }

  isElementVisible(elementName) {
    elementName = elementName.toLowerCase();

    return this.container.element(this.data[elementName]).isDisplayed()
      .then((is) => is, () => false);
  }

  async getElementText(elementName) {
    elementName = elementName.toLowerCase();

    return (await this.container.element(this.data[elementName]).getText()).trim();
  }

  clickElement(elementName) {
    elementName = elementName.toLowerCase();

    return this.container.element(this.data[elementName]).click();
  }

}

