/* tslint:disable:max-line-length */
import { browser, element, by, ElementFinder, protractor } from 'protractor';
import { helper } from '../../utils/helper';


export class Dropdown {
  private container = element(by.css('body>div.dropdown__content'));
  private data = {
    toggle: by.css('li[class*="toggle"]'),
  };

  constructor() {}

  async select(nameOrNumber, contain = false) {
    let option;
    if (typeof nameOrNumber === 'number') {
      option = this.container.all(by.tagName('li')).get(nameOrNumber);
    } else {
      option = this.container.all(by.tagName('li')).filter((opt) => {
        return opt.getText()
          .then((text) => {
            if (contain) {
              return text.toLowerCase().trim().replace(/ *\n */g, ' ').includes(nameOrNumber.toLowerCase());
            } else {
              return text.toLowerCase().trim().replace(/ *\n */g, ' ') === nameOrNumber.toLowerCase();
            }
          });
      }).first();
    }
    // await this.container.waitReady(2000);
    console.log('click through jsExecutor (dropdown)');
    // TODO: find a way how to click using protractor methods
    await browser.executeScript(`$(arguments[0]).click();`, option.getWebElement()).then(() => null, () => {
      return helper.sleep(1000)
        .then(() => browser.executeScript(`$(arguments[0]).click();`, option.getWebElement()));
    });
  }

  async isOptionEnabled(nameOrNumber) {
    let option;
    if (typeof nameOrNumber === 'number') {
      option = this.container.all(by.tagName('li')).get(nameOrNumber);
    } else {
      option = this.container.all(by.tagName('li')).filter((opt) => {
        return opt.getText()
          .then((text) => {
            return text.toLowerCase().trim().replace(/ *\n */g, ' ') === nameOrNumber.toLowerCase();
          });
      }).first();
    }
    // await this.container.waitReady(2000);
    const cls = await option.getAttribute('class');

    return !cls.includes('link--disabled');
  }

  async getOptions() {
    // await this.container.waitReady(2000);
    const textArr: any = await this.container.all(by.tagName('li')).getText();

    return textArr.map(t => t.trim().replace(/\s+/g, ' '));
  }

  isVisible() {
    return this.container.waitReady(1000)
      .then(() => true, () => false);
  }

  async waitDropdownDisappeared() {
    await this.container.waitMissing(1000);
  }

  async waitDropdownDisplayed() {
    await this.container.waitReady(1000);
  }

  async setIncludeOptions(state: string) {
    const antiState = state.toLowerCase() === 'on' ? 'off' : 'on';
    if (state !== 'on' && state !== 'off') {
      throw new Error('Wrong state. Should be "on" or "off".');
    }
    // await this.container.waitReady(1000);
    await this.container.element(this.data.toggle).element(by.css(`.${antiState}`)).click()
      .then(null, () => {
        console.log(`Include option is already in "${state}" state`);
      });
  }

  async getToggleLabel() {
    await this.container.waitReady(1000);

    return (await this.container.element(this.data.toggle).element(by.tagName('label')).getText()).trim();
  }

  async getToggleStatus() {
    await this.container.waitReady(1000);

    return (await this.container.element(this.data.toggle).element(by.css('.on,.off')).getText()).trim().toLowerCase();
  }

  async isOptionsIncluded() {
    return (await this.getToggleStatus()) === 'on';
  }

  async getDropdownLocation() {
    return this.container.getLocation();
  }
}

export class WorkspaceDropdown {
  private container = element(by.css('body>div.dropdown__content'));
  private data = {
    buttons: by.css('.components-list__item'),
    count: by.css('.item-count'),
    buttonTitle: by.css('.item-title'),
    clearWorkspace: by.css('.clear-workspace'),
    deleteWorkspace: by.css('.remove-workspace'),
    binIcon: by.css('.remove-workspace span'),
    'component state text': by.css('.workspace-components-state span'),
    'workspace name': by.css('.workspace-info__name'),
    'list title': by.css('.components-list__title'),
    showMeButton: by.css('.at-workspace-components-state__link'),
    containerOpenedComponents: by.css('.components'),
    openedComponent: by.css('.components__item'),
    closeComponentButton: by.css('.icon-close'),
    iconForRename: by.css('.icon-edit'),
    inputForRename: by.css('.workspace-info > input'),
  };

  constructor() {}

  async addNewPan(nameOrNumber) {
    let button;
    if (typeof nameOrNumber === 'number') {
      button = element.all(this.data.buttons).get(nameOrNumber);
    } else {
      button = element.all(this.data.buttons).filter((verifiableButton) => {
        return verifiableButton.element(this.data.buttonTitle).getText()
          .then((text) => {
            return text.toLowerCase().trim().includes(nameOrNumber.toLowerCase());
          });
      }).first();
    }
    // await this.container.waitReady(1000);
    await button.click();
  }

  async isPanelActive(nameOrNumber) {
    let button;
    if (typeof nameOrNumber === 'number') {
      button = element.all(this.data.buttons).get(nameOrNumber);
    } else {
      button = element.all(this.data.buttons).filter((verifiableButton) => {
        return verifiableButton.element(this.data.buttonTitle).getText()
          .then((text) => {
            return text.toLowerCase().trim().includes(nameOrNumber.toLowerCase());
          });
      }).first();
    }
    // await this.container.waitReady(1000);

    return button.getAttribute('class').then((cls) => !cls.includes('all-components-used'));
  }

  async isElementVisible(elem: string) {
    const self = this;
    elem = elem.toLowerCase();

    const elements = {
      'component state text': self.container.element(self.data['component state text']),
      'show me button': self.container.element(self.data.showMeButton),
      'delete workspace': self.container.element(self.data.deleteWorkspace),
      'bin icon': self.container.element(self.data.deleteWorkspace),
      'clear workspace': self.container.element(self.data.clearWorkspace),
      'x button': self.container.element(self.data.closeComponentButton),
      'list of components': self.container.element(self.data.buttons),
      'grid view component': self.container.all(self.data.openedComponent).get(0),
      'grid view component close btn': self.container.all(self.data.openedComponent).get(0).element(by.css('.icon-close')),
      'icon for rename': self.container.element(self.data.iconForRename),
      'input icon for input': self.container.element(self.data.inputForRename),
    };

    return elements[elem].waitReady(2000)
      .then(() => true, () => false);
  }

  async getText(elem: string) {
    const self = this;

    return (await self.container.element(self.data[elem]).getText()).trim();
  }

  async getComponentsTitles(componentName: string, componentsState) {
    const self = this;
    const components = {
      'component list': self.data.buttons,
      'grid view': self.data.openedComponent
    };
    let textArr: any;
    if (componentsState) {
      textArr = await this.container.all(components[componentName]).filter((el) => {
        return el.getAttribute('class')
          .then((cls) => {
            return cls.includes(componentsState);
          });
      }).getText();
    } else {
      textArr = await this.container.all(components[componentName]).getText();
    }

    return textArr.filter(t => t).map(t => t.trim());
  }

  async clickPanelButton(nameOrNumber) {
    let button;
    if (typeof nameOrNumber === 'number') {
      button = this.container.all(this.data.buttons).get(nameOrNumber);
    } else {
      button = this.container.all(this.data.buttons).filter((verifiableButton) => {
        return verifiableButton.element(this.data.buttonTitle).getText()
          .then((text) => {
            return text.toLowerCase().trim().includes(nameOrNumber.toLowerCase());
          });
      }).first();
    }

    return button.click();
  }

  async clickSupportButton(name) {
    const self = this;
    const buttons = {
      'delete workspace': self.container.element(self.data.deleteWorkspace),
      'clear workspace': self.container.element(self.data.clearWorkspace),
      'show me': self.container.element(self.data.showMeButton),
      'grid view component': self.container.all(self.data.openedComponent).get(0),
      'grid view component close btn': self.container.all(self.data.openedComponent).get(0).element(by.css('.icon-close')),
      'edit icon': self.container.element(self.data.iconForRename)
    };
    await buttons[name].waitReady(2000);
    await buttons[name].click();
  }

  async typeNameAndSave(name) {
    if (process.env.npm_config_browser === 'safari') {
      await browser.wait(async() => {
        const input = this.container.element(this.data.inputForRename);
        await input.sendKeys(protractor.Key.BACK_SPACE);
        const val = await input.getAttribute('value');

        return val === '';
      }, 10000);
    } else {
      await this.container.element(this.data.inputForRename).sendKeys(protractor.Key.chord(protractor.Key.CONTROL, 'a'));
      await this.container.element(this.data.inputForRename).sendKeys(protractor.Key.DELETE);
    }
    await this.container.element(this.data.inputForRename).sendKeys(name);
    await this.container.element(this.data.inputForRename).sendKeys(protractor.Key.ENTER);
  }

  async getChartsNumber() {
    try {
      const button = this.container.all(this.data.buttons).filter((verifiableButton) => {
        return verifiableButton.element(this.data.buttonTitle).getText()
          .then((text) => {
            return text.toLowerCase().trim().includes('chart');
          });
      }).first();
      const numStr = (await button.element(this.data.count).getText()).trim();

      return parseInt(numStr);
    } catch (err) {
      if (err.name === 'NoSuchElementError') {
        return 0;
      } else {
        throw err;
      }
    }
  }

  async getPanelButtonFullText(nameOrNumber) {
    let button;
    if (typeof nameOrNumber === 'number') {
      button = this.container.all(this.data.buttons).get(nameOrNumber);
    } else {
      button = this.container.all(this.data.buttons).filter((verifiableButton) => {
        return verifiableButton.element(this.data.buttonTitle).getText()
          .then((text) => {
            return text.toLowerCase().trim().includes(nameOrNumber.toLowerCase());
          });
      }).first();
    }

    return (await button.getText()).trim();
  }

}

export class DateTimePicker {
  private container = element(by.css('body>div.flatpickr-calendar.open'));
  private data = {
    hour: by.css('.flatpickr-hour'),
    'arrows up': by.css('.arrowUp'),
    'arrows down': by.css('.arrowDown'),
    minute: by.css('.flatpickr-minute'),
    pmam: by.css('.flatpickr-am-pm'),
    'previous month': by.css('.flatpickr-prev-month'),
    day: by.css('.flatpickr-day')
  };

  constructor() {}

  async IsVisible() {
    try {
      return this.container.isDisplayed();
    } catch (err) {
      return false;
    }
  }

  isElementDisplayed(elementName) {
    elementName = elementName.toLowerCase();
    const webElement = this.container.element(this.data[elementName]);

    return webElement.isDisplayed();
  }

  isDateElementDisplayed(date: string) {
    const day = this.container.all(this.data.day).filter((elem) => {
      return elem.getAttribute('aria-label')
        .then((text) => {
          return text.trim().toLowerCase().includes(date.toLowerCase());
        });
    }).first();

    return day.getAttribute('class')
      .then((cls) => !cls.includes('disabled'));
  }

  async pickFullTime(time: string) {
    if (time.match(/\d{1,2}:\d{1,2}:[PA]M/)) {
      const timeArr = time.split(':');
      await this.container.waitReady(2000);
      await this.container.element(this.data.hour).clear();
      await this.container.element(this.data.hour).sendKeys(timeArr[0]);
      await this.container.element(this.data.minute).clear();
      await this.container.element(this.data.minute).sendKeys(timeArr[1]);
      const text = (await this.container.element(this.data.pmam).getText()).trim().toLowerCase();
      if (text !== timeArr[2].toLowerCase()) {
        await this.container.element(this.data.pmam).click();
      }
    } else {
      throw new Error('Wrong time format');
    }
  }

  async add(num: number, point: string) {
    if (point !== 'hour' && point !== 'minute' && point !== 'year') {
      throw new Error('Wrong point');
    }
    const direction = num > 0 ? 'up' : 'down';
    const arrowNumbers = {
      year: 0,
      hour: 1,
      minute: 2
    };
    for (let i = 0; i < Math.abs(num); i++) {
      await this.container.element(this.data[point]).hover();
      await this.container.all(this.data[`arrows ${direction}`]).get(arrowNumbers[point]).click();
    }
  }

  async click(name) {
    const self = this;
    const elements = {
      'hour up arrow': await this.container.all(self.data['arrows up']).get(1),
      'hour down arrow': await this.container.all(self.data['arrows down']).get(1),
      'minute up arrow': await this.container.all(self.data['arrows up']).get(2),
      'minute down arrow': await this.container.all(self.data['arrows down']).get(2),
    };

     await elements[name].click();
  }
}

export class ActionMenu {
  private container = element(by.css('body>div.dropdown__content'));
  private data = {
    'new item': by.css('div[class*="new"]'),
    'new item input': by.css('.adding-new-block input'),
    item: by.css('div[class*="item"]'),
    'confirmation icon': by.css('.icon-confirmation')
  };

  constructor() {}

  isVisible() {
    return this.container.waitReady(1000)
      .then(() => true, () => false);
  }

  isNewItemButtonVisible() {
    return this.container.element(this.data['new item']).isDisplayed();
  }

  isItemPresent(itemName) {
    itemName = itemName.toLowerCase();
    const item = this.container.all(this.data.item).filter((list) => {
      return list.getText()
        .then((text) => text.toLowerCase().trim() === itemName);
    }).first();

    return item.isDisplayed()
      .then((is) => is, async() => {
        await helper.sleep(1000);

        return item.isDisplayed();
      });
  }

  isConfirmationIconVisible(itemName) {
    itemName = itemName.toLowerCase();

    return this.container.all(this.data.item).filter((list) => {
      return list.getText()
        .then((text) => text.toLowerCase().trim() === itemName);
    }).first().element(this.data['confirmation icon']).waitReady(2000)
      .then(() => true, () => false);
  }

  async addNewItem(itemName, location?: string) {
    itemName = itemName.toLowerCase();
    let root;
    if (location && location.includes('menu')) {
      root = await element(by.css('.menu app-add-to-watchlist'));
    } else {
      root = this.container;
    }
    let itemCount: number;
    // await root.waitReady(5000);
    itemCount = await root.all(this.data.item).count();
    await root.element(this.data['new item']).click();
    await root.element(this.data['new item input']).clear();
    await root.element(this.data['new item input']).sendKeys(itemName);
    await root.element(this.data['new item input']).sendKeys(protractor.Key.ENTER);
    /* await browser.wait(() => {
      return root.all(this.data.item).count()
        .then((count) => helper.sleepIfFalse(count === itemCount + 1));
    }, 3000); */
  }

  clickItem(itemName) {
    itemName = itemName.toLowerCase();

    return this.container.all(this.data.item).filter((list) => {
      return list.getText()
        .then((text) => text.toLowerCase().trim() === itemName);
    }).first().click();
  }

  async waitActionMenuDisappeared() {
    await this.container.waitMissing(1000);
  }

  async getItems() {
    const textArr: any = await this.container.all(this.data.item).getText();

    return textArr.map(t => t.trim());
  }

}
