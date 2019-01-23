import { browser, by, element, ElementFinder } from 'protractor';

import { Panel } from './panel';


export class EconomicCalendarPanel extends Panel {
  private data = {
    iframeRoot: by.tagName('iframe'),
    html: by.tagName('html'),
    parts: {
      header: by.id('fxst_filter'),
      body: by.id('fxst_grid'),
      noResults: by.css('.fxst-msg-noresult'),
      bodyContent: {
        dateRow: by.css('.fxst-dateRow>td'),
        eventRow: by.css('.fxit-eventrow'),
        eventDetailRow: by.css('.fxst-eventDetails')
      },
      'filter panel': by.id('fxst-advfilter')
    },
    elementToSwitch: by.css('.news-economic__toggle')
  };

  constructor(panelRoot: ElementFinder) {
    super(panelRoot);
    this.name = 'Economic Calendar';
  }

  async isElementVisible(elementName, eventNumber) {
    let el;

    await browser.switchTo().frame(this.container.element(this.data.iframeRoot).getWebElement());

    if (elementName.includes('bodyContent')) {
      elementName = elementName.split(' ')[1];
      if (typeof eventNumber !== 'undefined') {
        el = (await element.all(this.data.parts.bodyContent[elementName]))[eventNumber];
      } else {
        el = element(this.data.parts.bodyContent[elementName]);
      }
    } else {
      el = element(this.data.parts[elementName]);
    }

    const state = await el.waitReady(10000)
      .then(() => true, () => false);

    await browser.switchTo().defaultContent();

    return state;
  }

  switchToEconomicCalendar() {
    return element.all(this.data.elementToSwitch).get(1).click();
  }

  async expandEvent(eventNumber) {
    await browser.switchTo().frame(this.container.element(this.data.iframeRoot).getWebElement());

    const events = await element.all(this.data.parts.bodyContent.eventRow);
    const eventDetails = await element.all(this.data.parts.bodyContent.eventDetailRow);
    if (eventDetails[eventNumber]) {
      const state = await eventDetails[eventNumber].isDisplayed();
      if (!state) {
        if (process.env.npm_config_browser === 'safari') {
          await browser.executeScript(`$(arguments[0]).click()`, events[eventNumber].getWebElement());
        } else {
          await events[eventNumber].click();
        }
      } else {
        console.log(`Event number ${eventNumber} has already expanded`);
      }
    } else {
      console.log(`There is no event details for event number ${eventNumber}`);
    }

    await browser.switchTo().defaultContent();
  }

  async collapseEvent(eventNumber) {
    await browser.switchTo().frame(this.container.element(this.data.iframeRoot).getWebElement());

    const events = await element.all(this.data.parts.bodyContent.eventRow);
    const eventDetails = await element.all(this.data.parts.bodyContent.eventDetailRow);
    if (eventDetails[eventNumber]) {
      const state = await eventDetails[eventNumber].isDisplayed();
      if (state) {
        if (process.env.npm_config_browser === 'safari') {
          await browser.executeScript(`$(arguments[0]).click()`, events[eventNumber].getWebElement());
        } else {
          await events[eventNumber].click();
        }
      } else {
        console.log(`Event number ${eventNumber} has already collapsed`);
      }
    } else {
      console.log(`There is no event details for event number ${eventNumber}`);
    }

    await browser.switchTo().defaultContent();
  }

  async switchFilter(filterName: string) {
    await this.container.element(this.data.iframeRoot).waitReady(15000);
    await browser.switchTo().frame(this.container.element(this.data.iframeRoot).getWebElement());

    const filterButton = await element(by.id('fxst-calendar-filter-dateshortcuts')).all(by.tagName('a'))
      .filter((opt) => {
        return opt.getText()
          .then((text) => {
            return text.toLowerCase().trim().includes(filterName.toLowerCase());
          });
      }).first();

    if (process.env.npm_config_browser === 'edge') {
      await filterButton.scrollIntoView();
    }
    await filterButton.waitReady(2000);
    await filterButton.click();
    await browser.switchTo().defaultContent();
  }

  async isScrollingAvailable() {
    await browser.switchTo().frame(this.container.element(this.data.iframeRoot).getWebElement());
    const events = await element.all(this.data.parts.bodyContent.eventRow);

    if (events.length <= 11) {
      await browser.switchTo().defaultContent();

      return true;
    }

    const stateBeforeScroll = await element(this.data.html).getAttribute('scrollTop');
    await events[events.length - 1].scrollIntoView();

    const stateAfterScroll = await element(this.data.html).getAttribute('scrollTop');
    await events[0].scrollIntoView();

    await browser.switchTo().defaultContent();

    return stateBeforeScroll !== stateAfterScroll;
  }

  async getEventDates() {
    await this.container.element(this.data.iframeRoot).waitReady(15000);
    await browser.switchTo().frame(this.container.element(this.data.iframeRoot).getWebElement());
    const textArr: any = await element.all(this.data.parts.bodyContent.dateRow).getText();
    await browser.switchTo().defaultContent();

    return textArr.map(t => t.trim());
  }
}
