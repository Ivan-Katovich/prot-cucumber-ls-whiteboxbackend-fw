/* tslint:disable:max-line-length */
import { browser, element, by, ElementFinder, protractor } from 'protractor';
import { helper } from '../../utils/helper';

export class LinkedOrder {
  protected container: ElementFinder;
  protected data = {
    rows: {
      root: by.css('.row'),
      checkbox: by.css('.custom-checkbox'),
      'checkbox input': by.css('.custom-checkbox__input'),
      'trash icon': by.css('.icon-trash-can'),
      label: by.css('.row__label'),
      dropdown: by.css('.linked-order__available-types'),
      'linked order types': by.css('.order-type-dropdown span'),
      link: by.css('.link'),
      price: by.css('[placeholder="price"]'),
      'price border': by.css('.at-lo-price-input'),
      ccy: by.css('.currency-label'),
      applicability: by.css('.applicability-dropdown span'),
      'applicability container': by.css('.applicability-dropdown'),
      'p/l': by.css('[placeholder="P/L"]'),
      'p/l border': by.css('.at-lo-profit-loss__input'),
      'pips/points': by.css('[placeholder="points"],[placeholder="pips"]'),
      points: by.css('[placeholder="points"],[placeholder="pips"]'), // necessary to delete and use 'pips/points' in scenarios
      pips: by.css('[placeholder="pips"],[placeholder="points"]'),   // necessary to delete and use 'pips/points' in scenarios
      'p/l currency indicator': by.css('.currency-wrapper span'),
      'pips/points away': by.css('[placeholder="points away"],[placeholder="pips"]'),
      // now some markets have points away OR pips - not working with all markets
      'points away': by.css('[placeholder="points away"],[placeholder="pips"]'),
      'pips/points border':  by.css('[formcontrolname="points"]'), // in application still used formcontrolname="points" for pips input
      'points border':  by.css('[formcontrolname="points"]'), // necessary to delete, USE 'pips/points' instead of 'pips/points border'
      quantity: by.css('[placeholder="quantity"]'),
      'quantity border': by.css('[formcontrolname="quantity"]'),
      'date picker': by.css('.date-time-picker input'),
      'date picker input': by.css('.date-time-picker input'),
      'calendar icon': by.css('.icon-mydpcalendar'),
      currentDayBtn: by.css('.markcurrday'),
      'time picker': by.css('app-timepicker'),
      time: by.css('.time-picker'),
      'undo button': by.css('.linked-orders__undo-button'),
      delitionMessage: by.css('.linked-orders__deletion-message'),
      validationContainer: by.css('.row__validations'),
      validation: by.css('app-show-errors > ul > li')
    }
  };

  constructor(container: ElementFinder) {
    this.container = container;
  }

  async getInputValue(name: string) {
    name = name.toLowerCase();

    if (name === 'applicability' || name === 'ccy') {
      return (await this.container.element(this.data.rows[name]).getText()).trim();
    }

    return (await this.container.element(this.data.rows[name]).getAttribute('value')).trim();
  }

  async getBorderColor(name: string) {
    name = name.toLowerCase();

    return (await this.container.element(this.data.rows[name]).getCssValue('border-color')).trim();
  }

  async getCssValue(name: string, cssProperty) {
    name = name.toLowerCase();

    return (await this.container.element(this.data.rows[name]).getCssValue(cssProperty)).trim();
  }

  async modifyInputValue(name: string, key, times) {
    name = name.toLowerCase();
    const el = await this.container.element(this.data.rows[name]).waitReady(10000);
    while (times > 0) {
      await el.sendKeys(protractor.Key[key]);
      times--;
    }
  }

  async modifyInputValueByTyping(name: string, key, expection, value, betPer?) {
    value = parseFloat(value);
    name = name.toLowerCase();
    const demicals = {
      'pips/points': 1,
      price: 3
    };
    const el = this.container.element(this.data.rows[name]);

    await el.waitReady(10000);
    if (process.env.npm_config_browser.includes('firefox') || process.env.npm_config_browser.includes('edge')) {
      // typing an arrow through sendKeys doesn't work properly with Firefox
      // same in Edge(seems browser.actions() work, but somehow incorrectly)
      // in both cases typing and arrow through sendKeys would make input value equal to 0.00000
      // sending any keys using javascript executor is not allowed for security reasons
      // so, both examples below are only triggers already existing event w/o typing

      /* $('input[placeholder="price"]').keypress(function (e) {
        alert(String.fromCharCode(e.which));
        console.log(e);
      });

       $('input[placeholder="price"]').trigger({
        type: 'keypress',
        which: 38
      });

      const script = `var event = document.createEvent("KeyboardEvent"); ` +
        `var initMethod = typeof event.initKeyboardEvent !== 'undefined' ? "initKeyboardEvent" : "initKeyEvent"; ` +
        `event[initMethod]("keypress", true, true, null, false, false, false, false, 8, 0); ` +
        `document.querySelector('${this.data.rows[name].value}').dispatchEvent(event);`;
      await browser.executeScript(script); */
      await browser.wait(async() => {
        await el.sendKeys(protractor.Key.BACK_SPACE);
        const val = await el.getAttribute('value');

        return val === '';
      }, 10000);
      if (expection === 'below') {
        await el.sendKeys(value * 0.99);
      } else {
        await el.sendKeys(value * 1.01);
      }
    } else {
      const willBecomeZero = parseFloat(await el.getAttribute('value')) - betPer;
      if (willBecomeZero <= 0 && expection === 'below') {
        await browser.wait(async() => {
          await el.sendKeys(protractor.Key.BACK_SPACE);
          const val = await el.getAttribute('value');

          return val === '';
        }, 10000);

        el.sendKeys(betPer * 1.01);
      }

      await browser.wait(async() => {
        await el.sendKeys(protractor.Key[key]);

        if (expection === 'below') {
          return helper.sleepIfFalse(parseFloat(await el.getAttribute('value')) < value);
        } else if (expection === 'above') {
          return helper.sleepIfFalse(parseFloat(await el.getAttribute('value')) > value);
        } else {
          return helper.sleepIfFalse((parseFloat(await el.getAttribute('value'))).toFixed(demicals[name]) === value.toFixed(demicals[name]));
        }
      }, 120000);
    }
  }

  async fillInputWithValue(name: string, value) {
    name = name.toLowerCase();
    const val = this.container.element(this.data.rows[name]);

    if (name === 'time') {
      // await val.waitReady(10000);
      await val.sendKeys(value);
    } else {
      await val.waitReady(10000);
      await browser.wait(async() => {
        await val.clear();

        return helper.sleepIfFalse((await val.getAttribute('value')) === '');
      }, 10000);
      await val.sendKeys(value);
    }
  }

  async clearField(name: string) {
    name = name.toLowerCase();
    // const el = await this.container.element(this.data.rows[name]).waitReady(1000);
    const el = this.container.element(this.data.rows[name]);
    if (process.env.npm_config_browser.includes('firefox') || process.env.npm_config_browser === 'safari') {
      await browser.wait(async() => {
        await el.sendKeys(protractor.Key.BACK_SPACE);
        const val = await el.getAttribute('value');

        return val === '';
      }, 20000);
    } else {
      await el.sendKeys(protractor.Key.chord(protractor.Key.CONTROL, 'a', protractor.Key.DELETE));
    }
  }

  isElementPresent(elementName) {
    elementName = elementName.toLowerCase();
    const webElement = this.container.element(this.data.rows[elementName]);

    return webElement.isPresent();
  }

  async isElementEnabled(elementName) {
    // const el = await this.container.element(this.data.rows[elementName]).waitPresent(5000);
    const el = this.container.element(this.data.rows[elementName]);

    return el.isEnabled();
  }

  removeLinkedOrder() {
    return this.container.element(this.data.rows['trash icon']).click();
  }

  async expandDropdown(dropdownName) {
    const el = await this.container.all(this.data.rows[dropdownName]).get(0).waitReady(5000);

    return el.click();
  }

  async selectCurrentDate() {
    await this.container.element(this.data.rows['calendar icon']).click();
    await this.container.element(this.data.rows.currentDayBtn).click();
  }

  getField(fieldName): ElementFinder {
    return this.container.element(this.data.rows[fieldName]);
  }

  checkCheckbox() {
    return this.container.element(this.data.rows.checkbox).click();
  }

  click(fieldName) {
    if (fieldName === 'price' || fieldName === 'p/l' || fieldName === 'points' || fieldName === 'pips' || fieldName === 'pips/points' || fieldName === 'quantity') {
      return this.container.element(this.data.rows[fieldName]).element(by.xpath('./..')).click();
    } else {
      return this.container.element(this.data.rows[fieldName]).click();
    }
  }

  async isChecked() {
    const el = this.container.element(this.data.rows['checkbox input']);
    const is = await el.getAttribute('checked') || await el.isSelected();
    if (is) {
      return true;
    } else {
      return false;
    }
  }

  async getValidationMessage() {
    const el = await this.container.element(this.data.rows.validation).waitReady(5000);

    return (await el.getText()).trim();
  }

  async getElementPosition(name: string) {
    name = name.toLowerCase();
    const el = await this.container.element(this.data.rows[name]);

    const location = await el.getLocation();
    const size = await el.getSize();

    return {
      top: location.y,
      left: location.x,
      bottom: location.y + size.height,
      right: location.x + size.width
    };
  }

  async getText(fieldName) {
    const el = await this.container.element(this.data.rows[fieldName]);

    return (await el.getText()).trim();
  }

  getPlaceholder(name) {
    return this.container.element(this.data.rows[name]).getAttribute('placeholder');
  }
}

