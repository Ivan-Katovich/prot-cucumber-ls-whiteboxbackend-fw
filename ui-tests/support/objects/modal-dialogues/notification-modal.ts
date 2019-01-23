import { browser, element, by, ElementFinder } from 'protractor';


export class NotificationModal {
  protected container: ElementFinder;
  protected data = {
    header: by.css('.notifications-drawer__header-title'),
    'close button': by.css('.notifications-drawer__close-button-text'),
    'no messages row': by.css('.notifications-drawer__no-messages'),
    dialogue: by.css('.notifications-drawer__notification-group-list')
  };

  constructor(container = element(by.css('app-notifications-panel'))) {
    this.container = container;
  }

  isVisible() {
    return this.container.isDisplayed()
      .then((is) => is, () => false);
  }

  async getHeader() {
    return (await this.container.element(this.data.header).getText()).trim();
  }

  close() {
    return this.container.element(this.data['close button']).click();
  }

  isElementVisible(elementName) {
    elementName = elementName.toLowerCase();

    return this.container.element(this.data[elementName]).isDisplayed()
      .then((is) => is, () => false);
  }

}
