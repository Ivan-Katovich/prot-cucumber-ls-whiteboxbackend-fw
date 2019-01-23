import { browser, element, by, ElementFinder, protractor } from 'protractor';


export class HelpModal {
  protected container: ElementFinder;
  protected data = {
    header: by.css('.header'),
    sections: by.css('.help-menu__section'),
    'section headers': by.css('.help-menu__section--header'),
    items: by.css('.help-menu__section--item'),
    description: by.css('.help-item'),
    'back button': by.css('.close-page'),
    'close button': by.css('.close-help__button'),
    'charts provided by': by.css('.help-menu__tv-logo'),
     chartsLink: by.css('.help-menu__tv-logo-link')
  };

  constructor(container = element(by.tagName('app-help'))) {
    this.container = container;
  }

  getSection(nameOrNumber) {
    let section: ElementFinder;
    if (typeof nameOrNumber === 'number') {
      section = this.container.all(this.data.sections).get(nameOrNumber);
    } else {
      section = this.container.all(this.data.sections).filter((sect) => {
        return sect.element(this.data['section headers']).getText()
          .then((text) => {
            return text.toLowerCase().trim() === nameOrNumber.toLowerCase();
          });
      }).first();
    }

    const self = this;

    return {
      async getItemsNames() {
        const textArr: any = await section.all(self.data.items).getText();

        return textArr.map(t => t.trim());
      },

      async getHeader() {
        return (await section.element(self.data['section headers']).getText()).trim();
      }
    };
  }

  getItem(nameOrNumber) {
    let item: ElementFinder;
    if (parseInt(nameOrNumber)) {
      item = this.container.all(this.data.items).get(nameOrNumber);
    } else if (nameOrNumber = 'charts provided by link') {
      item = this.container.element(this.data.chartsLink);
    } else {
      item = this.container.all(this.data.items).filter((i) => {
        return i.getText()
          .then((text) => {
            return text.toLowerCase().trim() === nameOrNumber.toLowerCase();
          });
      }).first();
    }

    return {
      click() {
        return item.click();
      },
      scrollTo() {
        return item.scrollTo();
      }
    };
  }

  isVisible() {
    return this.container.isDisplayed()
      .then((is) => is, () => false);
  }

  close() {
    return this.container.element(this.data['close button']).click();
  }

  clickBack() {
    return this.container.element(this.data['back button']).click();
  }

  async getHeader() {
    return (await this.container.element(this.data.header).getText()).trim();
  }

  async getSectionNames() {
    const textArr: any = await this.container.all(this.data['section headers']).getText();

    return textArr.map(t => t.trim());
  }

  isElementVisible(elementName) {
    elementName = elementName.toLowerCase();

    return this.container.element(this.data[elementName]).isDisplayed()
      .then((is) => is, () => false);
  }

}

