/* tslint:disable:max-line-length */

import { browser, element, by, ElementFinder, protractor } from 'protractor';
import { Panel } from './panel';
import { LinkedOrder } from '../elements/linked-order';
import { helper } from '../../utils/helper';


export class DealTicketPanel extends Panel {
  private data = {
    hedge: {
      toggle: by.css('.hedge .slide-toggle--thumb'),
    },
    mainLabels: by.css('.ticket-type label'),
    closeDealTicketButton: by.css('.icon-close'),
    market: by.css('.market-information'),
    directions: by.css('.market-prices label'),
    marketName: by.css('.market-information__market-name'),
    mainMarketPricesArea: by.css('.ticket-form__main-order'),
    ocoMarketPricesArea: by.css('.ticket-form__oco-order'),
    sellLabel: by.css('.sell'),
    buyLabel: by.css('.buy'),
    marketSpread: by.css('.market-prices__spread'),
    ticketFormClarification: by.css('.ticket-form__clarification'),
    main: by.css('[formgroupname="mainOrder"] .market-prices'),
    oco: by.css('[formgroupname="ocoOrder"] .market-prices'),
    mainOrderArea: by.css('.main-order'),
    ocoOrderArea: by.css('.oco-order'),
    primaryArea: {
      root: by.css('.order-primary-area'),
      rows: by.css('.row'),
      quantityInput: by.css('[formcontrolname="quantity"] input'),
      quantityContainer: by.css('[formcontrolname=quantity]'),
      alertPrice: by.css('.at-alert-price-input'),
      alertPriceInput: by.css('.at-alert-price-input input'),
      orderPriceInput: by.css('[formcontrolname="price"] input'),
      goodTillDropdown: by.css('.applicability-control'),
      validation: by.css('.row__validations'),
      validationTable: by.css('.row__validations ul'),
      datePicker: by.css('.date-time-picker input'),
      datePickerInput: by.css('.date-time-picker input')
    },
    addStopLimitLink: by.css('.linked-orders-controls__add-order'),
    addStopLimitDropdown: by.css('.dropdown__content'),
    hedgingToggleBtn: by.css('.slide-toggle--status'),
    hedgeInfoIcon: by.css('.icon-info'),
    hedgeTooltip: by.css('.tooltip'),
    hedgingStatus: by.css('.order-controls__hedging-status'),
    positionInformation: by.css('.edit-form__position-info'),
    advancedTicketLink: by.css('.order-controls__mode-toggler--advanced'),
    doubleRightChevron: by.css('.icon-right-arrows'),
    standardTicketLink: by.css('.order-controls__mode-toggler--standard'),
    doubleLeftChevron: by.css('.icon-left-arrows'),
    ocoLink: by.css('.oco-toggle'),
    marginCalculator: {
      root: by.css('.margin-calculator'),
      risks: by.css('.margin-calculator__calculated-risks'),
      margin: by.css('.margin-calculator__calculated-margin'),
      details: by.css('.margin-calculator__calculated-margin-details'),
      'red triangle': by.css('.icon-suspended'),
      'margin tooltip': by.css('.margin-calculator__tooltip-body-item')
    },
    editLabel: by.css('.edit-form__collapse-header .at-edit-stops-and-limits-rb'),
    closeSection: {
      radioButton: by.css('.at-close-rb'),
      quantityInput: by.css('.at-close-quantity-input>input'),
      maxAvailableQty: by.css('.edit-form__collapse-header span'),
      info: by.css('.edit-form__close-info'),
      label: by.css('.edit-form__collapse-header .at-close-rb')
    },
    confirmationSection: {
      confirmationArea: by.css('.item-body-container'),
      confirmation: by.css('.at-confirmation-bot'),
      upConfirmation: by.css('.at-confirmation-top'),
      failure: by.css('.ticket-failure'),
      header: by.css('.ticket-confirmation-item__header'),
      message: by.css('.ticket-confirmation-item__body'),
      'ticket failure': by.css('.ticket-failure'),
      error: by.css('.ticket-confirmation-list__error-message'),
      'attached order confirmation': by.css('.body__row--attached-order')
    },
    marketStatus: {
      root: by.tagName('app-market-status'),
      closedMarketIcon: by.css('.icon-closedmarket'),
      callToTradeMarketIcon: by.css('.icon-calltotrade'),
      title: by.css('.market-status__title'),
      description: by.css('.market-status__description'),
      createAnOrderLink: by.css('.market-status__order-link')
    },
    orders: by.css('.linked-orders'),
    controls: by.css('.linked-orders-controls'),
    closeRadioBtn: by.css('.at-close-rb'),
    editRadioBtn: by.css('.at-edit-stops-and-limits-rb'),
    submitBtn: by.css('.ticket-footer__submit'),
    okBtn: by.css('.submit-button')
  };

  constructor(panelRoot: ElementFinder) {
    super(panelRoot);
    this.name = 'Deal Ticket';
  }

  isRadiobuttonSelected(name) {
    const self = this;
    name = name.toLowerCase();
    const radiobuttons = {
      close: self.data.closeSection.radioButton,
      edit : self.data.editRadioBtn
    };

    return this.container.element(radiobuttons[name]).element(by.tagName('input')).isSelected();
  }

  async isTypeSelected(type) {
    type = type.toLowerCase();
    const label = this.container.all(this.data.mainLabels).filter((lab) => {
      return lab.getText()
        .then((text) => {
          return text.toLowerCase().trim().includes(type.toLowerCase());
        });
    }).first();
    await label.waitReady(3000);
    const cls = await label.getAttribute('class');

    return cls.includes('selected');
  }

  async getDirection(type = '') {
    const cont = type === '' ? this.container : this.container.element(this.data[`${type}MarketPricesArea`]);
    await cont.element(this.data.buyLabel).waitReady(15000);
    const clsExt = await cont.all(this.data.directions).filter((direction) => {
      return direction.getAttribute('class')
        .then((cls) => cls.includes('selected'));
    }).first().getAttribute('class');
    const arr = clsExt.split(' ');

    return arr[0];
  }

  getLinkedOrder(num) {
    const linkedOrderRoot = this.container.all(by.css('.linked-orders > li')).get(num);

    return new LinkedOrder(linkedOrderRoot);
  }

  getMainLinkedOrder(num) {
    const linkedOrderRoot = this.container.element(this.data.mainOrderArea).all(by.css('.linked-orders > li')).get(num);

    return new LinkedOrder(linkedOrderRoot);
  }

  getOCOLinkedOrder(num) {
    const linkedOrderRoot = this.container.element(this.data.ocoOrderArea).all(by.css('.linked-orders > li')).get(num);

    return new LinkedOrder(linkedOrderRoot);
  }

  getAnyLinkedOrder(ticketType, orderNumber) {
    const value = ticketType === 'main' ? this.getMainLinkedOrder(orderNumber) :
                  ticketType === 'oco' ? this.getOCOLinkedOrder(orderNumber) :
                                        this.getLinkedOrder(orderNumber);

    return value;
  }

  getInputValue(name, type = '') {
    name = name.toLowerCase();
    const self = this;
    const order = type === '' ? self.container : self.container.element(this.data[`${type}OrderArea`]);
    const inputs = {
      'order price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      quantity: order.all(self.data.primaryArea.quantityInput).get(0),
      'close quantity': order.element(self.data.closeSection.quantityInput),
      'primary area quantity': order.element(self.data.primaryArea.quantityInput),
      'stop price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      'limit price': order.all(self.data.primaryArea.orderPriceInput).get(1),
      'date picker': order.element(self.data.primaryArea.datePickerInput),
      'alert price': order.element(self.data.primaryArea.alertPriceInput)
    };

    return inputs[name].getAttribute('value');
  }

  getInputMaxLength(name, type = '') {
    name = name.toLowerCase();
    const self = this;
    const order = type === '' ? self.container : self.container.element(self.data[`${type}OrderArea`]);
    const inputs = {
      'order price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      quantity: order.all(self.data.primaryArea.quantityInput).get(0),
      'close quantity': order.element(self.data.closeSection.quantityInput),
      'primary area quantity': order.element(self.data.primaryArea.quantityInput),
      'stop price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      'limit price': order.all(self.data.primaryArea.orderPriceInput).get(1)
    };

    return inputs[name].getAttribute('maxlength');
  }

  async getLocation(name) {
    name = name.toLowerCase();
    const self = this;

    const elements = {
      'up confirmation': self.container.element(self.data.confirmationSection.upConfirmation),
      'down confirmation': self.container.element(self.data.confirmationSection.confirmation),
      'market name': self.container.element(self.data.market)
    };
    // 30000 due to processing edit/remove of multiple extra stops and limits
    const el = await elements[name].waitReady(30000);
    const location = await el.getLocation();

    return location;
  }

  async getConfirmationMessage(orderNumber, ticketType = '') {
    const self = this;
    const confirmationAreas = await self.container.all(self.data.confirmationSection.confirmationArea);
    const confirmationArea = (ticketType === '' || ticketType === 'main') ? confirmationAreas[0] : confirmationAreas[1];
    const el = await confirmationArea.all(self.data.confirmationSection['attached order confirmation']).get(orderNumber).waitReady(2000);

    return (await el.getText()).trim();
  }

  async getElementText(elementName, ticketType = '') {
    elementName = elementName.toLowerCase();
    const self = this;
    const orderArea = (ticketType.trim() === 'main') ?
      await self.container.element(self.data.mainOrderArea) :
        (ticketType.trim() === 'oco') ?
          await self.container.element(self.data.ocoOrderArea) :
          this.container;
    const stopOrder = self.getLinkedOrder(0);
    const limitOrder = self.getLinkedOrder(1);
    const linkedOrder = self.getLinkedOrder(2);
    const elements = {
      'trade label': self.container.all(self.data.mainLabels).get(0),
      'order label': self.container.all(self.data.mainLabels).get(1),
      'set alert label': self.container.all(self.data.mainLabels).get(2),
      'ticket label': self.container.element(self.data.mainLabels),
      'market info': self.container.element(self.data.marketName),
      'position info': orderArea.element(self.data.positionInformation),
      'submit button': self.container.element(self.data.submitBtn),
      'close label': orderArea.element(self.data.closeSection.label),
      'close info': orderArea.element(self.data.closeSection.info),
      'max available quantity info': orderArea.element(self.data.closeSection.maxAvailableQty),
      confirmation: orderArea.element(self.data.confirmationSection.confirmation),
      failure: orderArea.element(self.data.confirmationSection.failure),
      'market name': orderArea.element(self.data.confirmationSection.header),
      'hedging status': orderArea.element(self.data.hedgingStatus),
      'margin calculator': self.container.element(self.data.marginCalculator.root),
      risks: self.container.element(self.data.marginCalculator.risks),
      margin: self.container.element(self.data.marginCalculator.margin),
      details: self.container.element(self.data.marginCalculator.details),
      'margin tooltip': self.container.element(self.data.marginCalculator['margin tooltip']),
      'confirmation message': self.container.element(self.data.confirmationSection.message),
      'confirmation message 1': self.container.all(self.data.confirmationSection.message).get(0),
      'confirmation message 2': self.container.all(self.data.confirmationSection.message).get(1),
      'confirmation message 3': self.container.all(self.data.confirmationSection.message).get(2),
      'delete message': linkedOrder.getField('delitionMessage'),
      'stop validation': stopOrder.getField('validation'),
      'limit validation': limitOrder.getField('validation'),
      'oco link': orderArea.element(self.data.ocoLink),
      'ticket form clarification': orderArea.element(self.data.ticketFormClarification),
      'main good till dropdown': orderArea.element(self.data.mainOrderArea).element(self.data.primaryArea.goodTillDropdown),
      'oco good till dropdown': orderArea.element(self.data.ocoOrderArea).element(self.data.primaryArea.goodTillDropdown),
      'market status title': orderArea.element(self.data.marketStatus.title),
      'ticket failure': orderArea.element(self.data.confirmationSection['ticket failure']),
      'error message': orderArea.element(self.data.confirmationSection.error),
      'attached order confirmation': orderArea.element(self.data.confirmationSection['attached order confirmation'])
    };

    const el = await elements[elementName].waitReady(2000);
    try {
      return (await el.getText()).trim();
    } catch (err) {
      await helper.sleep(500);

      return (await el.getText()).trim();
    }

  }

  async getMaxAvailableQty() {
    const maxAvailableQty = (await this.container.element(this.data.closeSection.maxAvailableQty).getText()).trim();

    return parseFloat(maxAvailableQty.replace(/\,/g, '').replace('of ', ''));
  }

  async clearField(name: string, type = '') {
    name = name.toLowerCase();
    const self = this;
    const area = type === '' ? self.container : self.container.element(self.data[`${type}OrderArea`]);
    let inputs;
    inputs = {
      'order price': area.all(self.data.primaryArea.orderPriceInput).get(0),
      quantity: area.all(self.data.primaryArea.quantityInput).get(0),
      'alert price': area.element(self.data.primaryArea.alertPriceInput)
    };
    const el = await inputs[name].waitReady(1000);
    if (process.env.npm_config_browser.includes('firefox') || process.env.npm_config_browser === 'safari') {
      await browser.wait(async() => {
        await el.sendKeys(protractor.Key.BACK_SPACE);
        const val = await el.getAttribute('value');

        return val === '';
      }, 10000);
    } else {
      await el.sendKeys(protractor.Key.chord(protractor.Key.CONTROL, 'a', protractor.Key.DELETE));
    }
  }

  async modifyInputValue(name: string, key, times, type = '') {
    name = name.toLowerCase();
    const self = this;
    const order = type === '' ? self.container : self.container.element(self.data[`${type}OrderArea`]);
    const inputs = {
      'order price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      quantity: order.all(self.data.primaryArea.quantityInput).get(0)
    };
    const el = await inputs[name].waitReady(10000);
    while (times > 0) {
      await el.sendKeys(protractor.Key[key]);
      times--;
    }
  }

  async modifyInputValueByTyping(name: string, key, expection, value, type = '') {
    name = name.toLowerCase();
    const demicals = {
      quantity: 0
    };
    const self = this;
    const order = type === '' ? self.container : self.container.element(self.data[`${type}OrderArea`]);
    const inputs = {
      'order price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      quantity: order.all(self.data.primaryArea.quantityInput).get(0)
    };
    const el = await inputs[name].waitReady(10000);
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
      await browser.wait(async() => {
        await el.sendKeys(protractor.Key[key]);

        if (expection === 'below') {
          return helper.sleepIfFalse(parseFloat(await el.getAttribute('value')) < value);
        } else if (expection === 'above') {
          return helper.sleepIfFalse(parseFloat(await el.getAttribute('value')) > value);
        } else {
          return helper.sleepIfFalse((await el.getAttribute('value')) === parseFloat(value).toFixed(demicals[name]));
        }
      }, 100000);
    }
  }

  async fillInputWithValue(name: string, value, type = '') {
    name = name.toLowerCase();
    const self = this;
    let inputs;
    const order = type === '' ? self.container : self.container.element(self.data[`${type}OrderArea`]);

    inputs = {
      'order price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      quantity: order.all(self.data.primaryArea.quantityInput).get(0),
      'close quantity': order.element(self.data.closeSection.quantityInput),
      'alert price': order.element(self.data.primaryArea.alertPriceInput)
    };

    const el = await inputs[name].waitReady(1000);
    await browser.wait(async() => {
      await el.clear();

      return helper.sleepIfFalse((await el.getAttribute('value')) === '');
    }, 10000);

    await el.sendKeys(value);
  }

  async isElementActive(name: string, type = '') {
    name = name.toLowerCase();
    const self = this;
    const order = type === '' ? self.container : self.container.element(self.data[`${type}OrderArea`]);

    const elements = {
      'order price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      quantity: order.all(self.data.primaryArea.quantityInput).get(0),
      'close quantity': order.element(self.data.closeSection.quantityInput)
    };

    const el = await elements[name].waitReady(1000);
    const activeEl = await browser.driver.switchTo().activeElement();
    const elHtml = await browser.executeScript('return arguments[0].outerHTML;', el.getWebElement());
    const activeHtml = await browser.executeScript('return arguments[0].outerHTML;', activeEl);

    return elHtml === activeHtml;
  }

  async selectItemType(type) {
    type = type.toLowerCase();
    await this.container.waitReady(3000);
    const label = this.container.all(this.data.mainLabels).filter((lab) => {
      return lab.getText()
        .then((text) => {
          return text.toLowerCase().trim().includes(type);
        });
    }).first();

    await label.waitReady(5000);
    let cls = await label.getAttribute('class');
    if (!cls.includes('selected')) {
      await label.click();
    }
    await browser.wait(async() => {
      cls = await label.getAttribute('class');

      return helper.sleepIfFalse(cls.includes('selected'));
    }, 5000)
      .then(() => null, () => label.click());
  }

  async submit() {
    const prices = { sell: null, buy: null };
    const cls = await this.container.element(this.data.submitBtn).getAttribute('class');
    if (cls.includes('disabled')) {
      throw new Error(' Submit button is not active! ');
    } else {
      await this.container.element(this.data.submitBtn).click();
    }
    const button = await this.container.element(this.data.okBtn).waitReady(3000);
    await helper.sleep(50);
    prices.sell = (await this.container.element(this.data.sellLabel).element(by.css('.price__value')).getText()).trim();
    prices.buy = (await this.container.element(this.data.buyLabel).element(by.css('.price__value')).getText()).trim();
    await button.click();
    await this.container.waitMissing();

    return prices;
  }

  async isSubmitDisabled() {
    const cls = await this.container.element(this.data.submitBtn).getAttribute('class');

    return cls.includes('disabled');
  }

  async isElementEnabled(elementName, type = '') {
    const self = this;
    const order = type === '' ? self.container : self.container.element(self.data[`${type}OrderArea`]);
    const inputs = {
      'order price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      quantity: order.all(self.data.primaryArea.quantityInput).get(0)
    };

    return await inputs[elementName].isEnabled();
  }

  async getPrice(type, ticketType = '') {
    const price = ticketType === '' ?
      (await this.container.element(this.data[`${type}Label`]).element(by.css('.price__value')).getText()).trim()
    : (await this.container.all(this.data[ticketType]).get(0).element(this.data[`${type}Label`]).element(by.css('.price__value')).getText()).trim();

    return price;
  }

  async clickOnButton(buttonName, type, wait = 6000) {
    const el = await this.container.element(this.data[`${buttonName}Btn`]).waitReady(wait);
    await el.scrollIntoView();
    await browser.wait(async() => {
      const cls = await el.getAttribute('class');

      return !cls.includes('disabled');
    }, 5000);
    await el.click();
  }

  async clickOnLabel(labelName, type = '', wait = 3000) {
    const self = this;
    const order = type === '' ? self.container : self.container.element(self.data[`${type}MarketPricesArea`]);
    const el = await order.element(this.data[`${labelName}Label`]).waitReady(wait);
    await el.click();
  }

  async clickOnLink(linkName, type = '', wait = 3000) {
    const self = this;
    const order = type === '' ? self.container : self.container.element(self.data[`${type}OrderArea`]);
    const el = await order.element(this.data[`${linkName}Link`]).waitReady(wait);
    await el.click();
  }

  async clickOnElement(elementName, wait = 2000) {
    const mainOrder = this.container.element(this.data.mainOrderArea);
    const ocoOrder = this.container.element(this.data.ocoOrderArea);
    const main = this.container.all(this.data.main).get(0);
    const oco = this.container.all(this.data.oco).get(0);
    const elements = {
      'panel label': this.container.element(this.data.mainLabels),
      'main advanced ticket link': mainOrder.element(this.data.advancedTicketLink),
      'main sell label': main.element(this.data.sellLabel),
      'main buy label': main.element(this.data.buyLabel),
      quantity: mainOrder.all(this.data.primaryArea.quantityContainer).get(0),
      'oco advanced ticket link': ocoOrder.element(this.data.advancedTicketLink),
      'oco sell label': oco.element(this.data.sellLabel),
      'oco buy label': oco.element(this.data.buyLabel),
      'create an order link': mainOrder.element(this.data.marketStatus.createAnOrderLink),
      'market name': mainOrder.element(this.data.marketName),
      'hedge toggle': this.container.element(this.data.hedge.toggle)
    };

    const el = await elements[elementName].waitReady(wait);
    await el.click();
  }

  async hover(elementName, ticketType = 'main') {
    elementName = elementName.toLowerCase();
    const self = this;

    ticketType = ticketType === '' ? 'main' : ticketType;
    const order = ticketType === '' ? self.container : self.container.element(self.data[`${ticketType}OrderArea`]);
    const elements = {
      'hedging info icon': order.element(self.data.hedgeInfoIcon),
      'submit button':  self.container.element(self.data.submitBtn),
      'red triangle': self.container.element(self.data.marginCalculator['red triangle'])
    };
    await elements[elementName].waitPresent(5000);
    await elements[elementName].scrollIntoView();
    await elements[elementName].hover();
  }

  async isControlDisabled(name, ticketType = '') {
    const self = this;
    const orderArea = (ticketType.trim() === 'main') ?
      await self.container.element(self.data.mainOrderArea) :
        (ticketType.trim() === 'oco') ?
          await self.container.element(self.data.ocoOrderArea) :
          this.container;

    const control = {
      'submit button':  self.container.element(self.data.submitBtn),
      'ok button': self.container.element(self.data.okBtn),
      'standard ticket link': orderArea.element(self.data.standardTicketLink),
      'hedge toggle': orderArea.element(self.data.hedgingToggleBtn),
      'main good till dropdown': self.container.element(self.data.mainOrderArea).element(self.data.primaryArea.goodTillDropdown).element(by.xpath('.//..')),
      'oco good till dropdown': self.container.element(self.data.ocoOrderArea).element(self.data.primaryArea.goodTillDropdown).element(by.xpath('.//..')),
      'close quantity': orderArea.element(self.data.primaryArea.quantityInput),
      'date picker': orderArea.element(self.data.primaryArea.datePickerInput),
      'alert price': self.container.element(self.data.primaryArea.alertPriceInput)
    };

    const el = await control[name].waitReady(3000);
    const cls = await el.getAttribute('class');

    switch (name) {
      case 'hedge toggle':
        return cls.includes('off');
      case 'date picker':
      case 'alert price':
      case 'close quantity':
        const attribute = await el.getAttribute('disabled');

        return attribute === 'true';
      default:
        return cls.includes('disabled');
    }
  }

  getPlaceholder(name) {
    const self = this;
    const field = {
      quantity: self.container.all(self.data.primaryArea.quantityInput).get(0),
      'close quantity': self.container.element(self.data.closeSection.quantityInput)
    };

    return field[name].getAttribute('placeholder');
  }

  getColor(labelOrButtonName, colorProperty) {
    return this.container.element(this.data[labelOrButtonName]).getCssValue(colorProperty);
  }

  async isElementPresent(elementName, ticketType = 'main', state = true) {
    elementName = elementName.toLowerCase();
    const self = this;

    ticketType = ticketType === '' ? 'main' : ticketType;
    const order = ticketType === '' ? self.container : self.container.element(self.data[`${ticketType}OrderArea`]);

    const elements = {
      'trade label': self.container.all(self.data.mainLabels).get(0),
      'order label': self.container.all(self.data.mainLabels).get(1),
      'set alert label': self.container.all(self.data.mainLabels).get(2),
      'close label': self.container.element(self.data.closeDealTicketButton),
      'sell label': self.container.all(self.data[ticketType]).get(0).element(self.data.sellLabel),
      'buy label': self.container.all(self.data[ticketType]).get(0).element(self.data.buyLabel),
      'buy tick': self.container.element(self.data.buyLabel).element(by.css('.chevron')),
      'sell tick': self.container.element(self.data.sellLabel).element(by.css('.chevron')),
      'red triangle': self.container.element(self.data.marginCalculator['red triangle']),
      'margin tooltip': self.container.element(self.data.marginCalculator['margin tooltip']),
      'ticket form clarification': self.container.element(self.data.ticketFormClarification),
      'order price': order.all(self.data.primaryArea.orderPriceInput).get(0),
      quantity: order.all(self.data.primaryArea.quantityInput).get(0),
      'standard ticket link': order.element(self.data.standardTicketLink),
      'standard ticket double arrows': order.element(self.data.standardTicketLink).element(self.data.doubleLeftChevron),
      'advanced ticket link': order.element(self.data.advancedTicketLink),
      'advanced ticket double arrows': order.element(self.data.advancedTicketLink).element(self.data.doubleRightChevron),
      'oco link': self.container.element(self.data.ocoLink),
      'add stop limit dropdown link': order.element(self.data.addStopLimitLink),
      'hedging toggle': order.element(self.data.hedgingToggleBtn),
      'hedging info icon': order.element(self.data.hedgeInfoIcon),
      'hedging status': order.element(self.data.hedgingStatus),
      'good till dropdown': order.element(self.data.primaryArea.goodTillDropdown),
      'closed icon': self.container.element(self.data.marketStatus.closedMarketIcon),
      'call to trade icon': self.container.element(self.data.marketStatus.callToTradeMarketIcon),
      'status description': self.container.element(self.data.marketStatus.description),
      'create an order link': self.container.element(self.data.marketStatus.createAnOrderLink),
      'close section': self.container.element(self.data.closeSection.label),
      'edit section': self.container.element(self.data.editLabel),
      'date picker': self.container.element(self.data.primaryArea.datePicker),
      orders: self.container.element(self.data.orders),
      'validation message': self.container.element(self.data.primaryArea.validationTable),
      'error message': self.container.element(self.data.confirmationSection.error)
    };
    await elements[elementName].waitReady(4000)
      .then(() => null, () => null);

    if (state) {
      return elements[elementName].isDisplayed()
        .then(() => true, () => false);
    } else {
      return elements[elementName].isPresent();
    }
  }

  async getAttribute(elementName, attribute) {
    elementName = elementName.toLowerCase();
    attribute = attribute.toLowerCase();
    const self = this;

    const elements = {
      'buy tick': self.container.element(self.data.buyLabel).element(by.css('.chevron')),
      'sell tick': self.container.element(self.data.sellLabel).element(by.css('.chevron'))
    };

    return (await elements[elementName].getAttribute(attribute));
  }

  getNumberOfLinkedOrders(ticketType = '') {
    const order = ticketType === '' ? this.container : this.container.element(this.data[`${ticketType}OrderArea`]);

    return order.all(by.css('.linked-orders > li')).count();
  }

  isElementVisible(ticketType, elem) {
    elem = elem.toLowerCase();
    const self = this;
    let input;
    switch (ticketType) {
      case 'main': {
        const mainOrder = self.container.element(self.data.mainOrderArea);
        input = {
          'order price': mainOrder.element(self.data.primaryArea.orderPriceInput),
          'hedging tooltip': mainOrder.element(self.data.hedgeTooltip),
          quantity: mainOrder.element(self.data.primaryArea.quantityInput)
        };
        break;
      }
      case 'oco': {
        const ocoOrder = self.container.element(self.data.mainOrderArea);
        input = {
          'order price': ocoOrder.element(self.data.primaryArea.orderPriceInput),
          'hedging tooltip': ocoOrder.element(self.data.hedgeTooltip),
          quantity: ocoOrder.element(self.data.primaryArea.quantityInput)
        };
        break;
      }
      default: {
        input = {
          'ticket form clarification': self.container.element(self.data.ticketFormClarification),
          'hedging tooltip': self.container.element(self.data.hedgeTooltip),
          'red triangle': self.container.element(self.data.marginCalculator['red triangle']),
          'margin tooltip': self.container.element(self.data.marginCalculator['margin tooltip']),
        };
      }
    }

    return input[elem].waitReady(2000)
      .then(() => true, () => false);
  }

  getValidationMessage(ticketType, field) {
    const orderValidations = ticketType === '' ? this.container.all(this.data.primaryArea.validation)
      : this.container.element(this.data[`${ticketType}OrderArea`]).all(this.data.primaryArea.validation);

    if (ticketType === '' && field === 'quantity') {
      return orderValidations.get(0).getText()
        .then((text) => text.trim());
    } else {
      if (field === 'price') {
        return browser.wait(() => {
          return orderValidations.count()
            .then((count) => helper.sleepIfFalse(count > 0));
        }, 3000)
          .then(() => orderValidations.get(0).getText())
          .then((text) => text.trim());
      } else if (field === 'quantity') {
        return browser.wait(() => {
          return orderValidations.count()
            .then((count) => helper.sleepIfFalse(count > 1));
        }, 3000)
          .then(() => orderValidations.get(1).getText())
          .then((text) => text.trim());
      }
    }
  }

  async expandDropdown(dropdownName, ticketType = 'main') {
    const self = this;
    ticketType = !ticketType ? 'main' : ticketType;
    const order = self.container.element(self.data[`${ticketType}OrderArea`]);
    const dropdowns = {
      'add stop limit dropdown link': order.element(self.data.addStopLimitLink),
      'good till dropdown link': order.element(self.data.primaryArea.goodTillDropdown),
      'date picker': order.element(self.data.primaryArea.datePicker)
    };
    await dropdowns[dropdownName].waitReady(3000);

    return dropdowns[dropdownName].click();
  }

  async getMarginCalcText() {
    if ((await this.container.element(this.data.marginCalculator.root).getAttribute('class')).includes('empty')) {
      return '';
    } else {
      return (await this.container.element(this.data.marginCalculator.root).getText()).trim();
    }
  }

  async waitForConfirmationMessage(timeout = 2000) {
    await this.container.element(this.data.confirmationSection.header).waitReady(timeout);
  }

  async getCssValue(name: string, ticketType, cssProperty) {
    name = name.toLowerCase();
    const self = this;

    ticketType = ticketType === '' ? 'main' : ticketType;
    const order = ticketType === '' ? self.container : self.container.element(self.data[`${ticketType}OrderArea`]);

    const elements = {
      quantity: order.all(self.data.primaryArea.quantityInput).get(0),
      'background box': self.container.all(self.data.primaryArea.root).get(0),
      'buy tick': self.container.element(self.data.buyLabel).element(by.css('.chevron')),
      'sell tick': self.container.element(self.data.sellLabel).element(by.css('.chevron')),
      'submit button': self.container.element(self.data.submitBtn)
    };

    return (await elements[name].getCssValue(cssProperty)).trim();
  }

  async getElementPosition(name: string) {
    name = name.toLowerCase();
    const self = this;

    const elements = {
      quantity: self.container.all(self.data.primaryArea.quantityInput).get(0),
      'background box': self.container.all(self.data.primaryArea.root).get(0),
      'order price': self.container.all(self.data.primaryArea.orderPriceInput).get(0),
      'gtc dropdown': self.container.all(self.data.primaryArea.goodTillDropdown).get(0)
    };

    const location = await elements[name].getLocation();
    const size = await elements[name].getSize();

    return {
      top: location.y,
      left: location.x,
      bottom: location.y + size.height,
      right: location.x + size.width
    };
  }

}

