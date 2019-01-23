import { browser, element, by, ElementFinder, protractor } from 'protractor';

export class MyAccount {
  private data = {
    closeTab: by.css('.icon-close'),
  // 'account menu'
    'icon container': by.css('.icon-container'),
    username: by.css('.username'),
    clientAccount: by.css('.client-account'),
    tradingAccountNumber: by.css('.trading-account-number'),
    email: by.css('.email'),
    funding: by.css('div[routerlink="funding"]'),
    statements: by.css('div[routerlink="statements"]'),
    settings: by.css('div[routerlink="settings"]'),
    details: by.css('div[routerlink="details"]'),

  // 'account funding'
    'funding header': by.css('.funding-header'),
    'funding description': by.css('.funding-description'),
    'add funds link': by.css('.funding-link--funding'),
    'withdraw funds link': by.css('.funding-link--withdrawal'),
    'add payment method link': by.css('.funding-link--add-payment'),
    'remove payment method link': by.css('.funding-link--remove-payment'),

  // 'statemetns and contracts'
    'statements and contracts header': by.css('.statements__header'),
    'statements checkbox': by.css('input[formcontrolname="statements"]'),
    'contract notes checkbox': by.css('input[formcontrolname="contracts"]'),
    'select dates label': by.css('.statements-form__date-mode-select'),
    'select dates': by.css('select[formcontrolname="dateMode"]'),
    months: by.css('.date-input__list-item > span'),
    'month radio button': by.css('input[formcontrolname="month"]'),
    'other dates link': by.css('.date-input__toggle'),
    'search button': by.cssContainingText('button', 'Search'),
    'date input control': by.css('.date-input__control'),
    'date picker input': by.css('.selection'),
    'date picker label': by.css('.label'),
    'date picker buttons': by.css('.selbtngroup'),
    'previous month': by.css('button[aria-label="Previous Month"]'),
    'next month': by.css('button[aria-label="Next Month"]'),
    'statements and contract notes header': by.css('.statements-notes__header'),
    'statements placeholder': by.css('.statements-notes__placeholder'),
    'statements items': by.css('.statements-notes__list-item'),
    date: by.css('.statements-notes__item--date'),
    range: by.css('.statements-notes__item--range'),
    type: by.css('.statements-notes__item--type'),
    'download link': by.css('.contract-download-link'),
    pdf: by.css('embed[type="application/pdf"]'),

  // 'platform settings'
    'settings header': by.css('.settings-header'),
    icon: by.css('.icon-chart'),
    column: by.css('.form-column'),
    label: by.css('.form-section__label'),
    toggle: by.css('.hedge'),
    hedgeDescription: by.css('.form__item__description'),
    description:  by.css('.form-section__description'),
    'session timeout': by.css('select[formcontrolname="sessionTimeout"]'),
    'time zone': by.css('select[formcontrolname="timezone"]'),
    'date format': by.css('select[formcontrolname="dateFormat"]'),

  // 'account details'
    'details header': by.css('.form-header'),
    'current email': by.css('.form__current-email'),
    'new email': by.css('.form-control__new-email'),
    're-enter email': by.css('.form-control__re-enter-email'),
    buttons: by.css('button'),
    'password description': by.css('.form-description'),
    'old password': by.css('.form-control__old-password'),
    'new password': by.css('.form-control__new-password'),
    're-enter password': by.css('.form-control__re-enter-new-password'),
    'error message': by.css('.form-container__error-message')
  };

  async isSectionActive(sectionName: string) {
    // await element(this.data[sectionName]).waitReady(5000);
    const is = await element(this.data[sectionName]).getAttribute('class');

    return is.includes('active');
  }

  async click(elementName: string) {
    const self = this;
    const elements = {
      'update email button': element.all(this.data.buttons).get(0),
      'update now button': element.all(this.data.buttons).get(1),
      'search button': element(this.data['search button']),
      from: element.all(this.data['date picker buttons']).get(0),
      to: element.all(this.data['date picker buttons']).get(1),
      'close icon': element.all(this.data.closeTab)
    };

    if (elements[elementName]) {
      // await browser.wait(protractor.ExpectedConditions.elementToBeClickable(elements[elementName]), 10000);
      return elements[elementName].click();
    } else {
      // await browser.wait(protractor.ExpectedConditions.elementToBeClickable(element(this.data[elementName])), 10000);
      return element(this.data[elementName]).click();
    }
  }

  async getParentText(elementName) {
    elementName = elementName.toLowerCase();
    const self = this;
    const elements = {
      'hedge label': element(self.data.column).get(0).element(self.data.label)
    };
    const parentText = await elements[elementName].getText();

    return parentText.split('\n')[0].trim();
  }

  async isElementPresentAndVisible(elementName: string, elementState: string) {
    elementName = elementName.toLowerCase();
    const self = this;

    const elements = {
      'cfd account': await self.getElementByText('cfd account'),
      'spread account': await self.getElementByText('spread account'),
      'full username': element(self.data.username),
      'logged username': element(self.data.clientAccount),
      'hedge label': element.all(self.data.column).get(0).element(self.data.label),
      'hedge toggle': element.all(self.data.column).get(0).element(self.data.toggle),
      'hedge description': element(self.data.hedgeDescription),
      'session timeout label': element.all(self.data.column).get(1)
                                      .all(self.data.label).get(0),
      'session timeout dropdown': element(self.data['session timeout']),
      'timezone label': element.all(self.data.column).get(1).all(self.data.label).get(1),
      'timezone dropdown': element(self.data['time zone']),
      'timezone description': element.all(self.data.description).get(0),
      'date format label': element.all(self.data.column).get(1).all(self.data.label).get(2),
      'date format dropdown': element(self.data['date format']),
      'date format description': element.all(self.data.description).get(1),
      'current email': element(self.data['current email']),
      'new email input': element(self.data['new email']),
      're-enter email input': element(self.data['re-enter email']),
      'update email button': element.all(self.data.buttons).get(0),
      'password description': element(self.data['password description']),
      'old password input': element(self.data['old password']),
      'new password input': element(self.data['new password']),
      're-enter password input': element(self.data['re-enter password']),
      'update now button': element.all(self.data.buttons).get(1),
      'from date': element.all(self.data['date input control']).get(0),
      'to date': element.all(self.data['date input control']).get(1)
    };

    if (!elements[elementName]) {
      if (elementState === 'should') {
        /* await element(self.data[elementName]).waitReady(5000)
          .then(() => null, () => null); */

        return element(self.data[elementName]).isDisplayed();
      } else {
        return element(self.data[elementName]).isPresent();
      }
    } else {
      if (elementState === 'should') {
        /* await elements[elementName].waitReady(5000)
          .then(() => null, () => null); */

        return elements[elementName].isDisplayed();
      } else {
        return elements[elementName].isPresent();
      }
    }

  }

  async getElementByText(containingText) {
    return element.all(this.data.tradingAccountNumber).filter((elem) => {
      return elem.getText()
        .then((text) => {
          return text.trim().toLowerCase().includes(containingText);
        });
    }).first();
  }

  async getSelectedOption(dropdownName: string) {
    dropdownName = dropdownName.toLowerCase();
    let optionSelected = await element(this.data[dropdownName]).element(by.css('option:checked')).waitReady(10000);
    optionSelected = await optionSelected.getText();

    return optionSelected.trim();
  }

  async isHedgeOn() {
    // const is = await element(this.data.toggle).getAttribute('class');
    //
    // return is.includes('active');
    return element(this.data.toggle).waitText('on', 1000)
      .then(() => true, () => false);
  }

  async getElementText(elementName: string) {
    // await element(this.data[elementName]).waitReady(5000);
    let content = await element(this.data[elementName]);
    // in Edge text from child "option" elements is not taken
    if (process.env.npm_config_browser === 'edge' && (await content.all(by.tagName('option')).count()) > 0) {
      content = await content.all(by.tagName('option')).map((elem) => elem.getText());
   } else {
      content = (await content.getText()).split('\n');
    }

    return content.map(t => t.trim()).filter(t => t);
  }

  async getDescription(description) {
    description = description.toLowerCase();
    const self = this;

    const elements = {
      hedge: element(self.data.hedgeDescription),
      'time zone': element.all(self.data.description).get(0),
      'date format': element.all(self.data.description).get(1),
      'error message': element(self.data['error message']),
      'account funding': element.all(self.data['funding description']),
      'full username': element(self.data.username),
      'logged username': element(self.data.clientAccount),
      email: element(self.data.email)
    };
    // await elements[description].waitReady(10000);
    if (description === 'account funding') {
      return elements[description].map(async(elem) => (await elem.getText()).replace(/\\n*/g, '\n'));
    } else {
      return elements[description].getText();
    }
  }

  async getTooltip() {
    return element(this.data['email']).getAttribute('title');
  }

  async selectDropdownOption(sectionName: string, dropdownName: string, optionNameOrNumber) {
    if (typeof optionNameOrNumber === 'number') {
      return element(this.data[dropdownName]).all(by.tagName('option')).get(optionNameOrNumber).click();
    } else {
      return element(by.cssContainingText('option', optionNameOrNumber)).click();
    }
  }

  async enterText(inputField: string, text: string) {
    await element(this.data[inputField]).clear();

    return element(this.data[inputField]).sendKeys(text);
  }

  async clearText(inputField: string) {
    return element(this.data[inputField]).clear();
  }

  async isElementActive(elementName) {
    elementName = elementName.toLowerCase();
    const self = this;

    const elements = {
      'update email button': element.all(self.data.buttons).get(0),
      'update now button': element.all(self.data.buttons).get(1),
      'search button': element(self.data['search button'])
    };

    return !(await elements[elementName].getAttribute('disabled'));
  }

  async isElementSelected(elementName) {
    return element(this.data[elementName]).isSelected();
  }

  async selectMonth(nameOrNumber) {
    if (typeof nameOrNumber === 'number') {
      return element.all(this.data['month radio button']).get(nameOrNumber).click();
    } else {
      return element.all(this.data.months).filter((m) => {
        return m.getText()
          .then((text) => {
            return text.trim() === nameOrNumber;
          });
      }).click();
    }
  }

  async isMonthSelected(nameOrNumber) {
    if (typeof nameOrNumber === 'number') {
      await element.all(this.data['month radio button']).get(nameOrNumber).waitReady(3000);

      return element.all(this.data['month radio button']).get(nameOrNumber).isSelected();
    } else {
      await element.all(this.data['month radio button']).get(0).waitReady(3000);

      return element.all(this.data['month radio button']).filter((m) => {
        return m.element(by.xpath('following-sibling::span')).getText()
          .then((text) => {
            return text.trim() === nameOrNumber;
          });
      }).first().isSelected();
    }
  }

  async getStatementsAndContractsValue(itemNumber, itemName) {

    return element.all(this.data['statements items']).get(itemNumber)
      .element(this.data[itemName]).getText();
  }

  async getStatementsData(itemName) {
    const itemsList = await element.all(this.data['statements items']).all(this.data[itemName]).getText();

    return itemsList;
  }

  async getDatePickerValue(date) {
    const self = this;
    const dates = {
      from: element.all(self.data['date picker input']).get(0),
      to: element.all(self.data['date picker input']).get(1)
    };
    await dates[date].waitReady(5000);

    return dates[date].getAttribute('value');
  }

  async selectDate(day) {
    await element.all(by.cssContainingText('.currmonth', day)).get(0).waitReady(3000);
    await element.all(by.cssContainingText('.currmonth', day)).get(0).click();
  }
}
