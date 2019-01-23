import * as _ from 'lodash';
import { protractor, browser, by, element, ElementFinder } from 'protractor';
import { Panel } from './panel';
import { helper } from '../../utils/helper';
import { ActionMenu, Dropdown } from '../elements/dropdown';


export class ChartPanel extends Panel {
  private data = {
    iframeRoot: by.css('app-chart-wrapper iframe'),
    // draggableButtons: by.tagName('.tv-floating-toolbar__drag.js-drag'),
    'chart table': by.css('.layout__area--center'),
    chartBody: by.css('.chart-markup-table.pane'),
    marketSearchInput: by.css('#header-toolbar-symbol-search [class*="input"]'),
    marketSearchResults: by.css('table.symbol-edit-popup'),
    marketNameLabel: by.css('span.pane-legend-line.apply-overflow-tooltip.main'),
    'price axis': by.css('.chart-markup-table.price-axis'),
    'add icon': by.css('.pane-controls.toppane'),
    menu: {
      'close chart': by.css('.menu__item.close'),
      'add to workspace': by.cssContainingText('.menu__item > div > div', 'Add to Workspace'),
      'add to watchlist': by.cssContainingText('.menu__item > div > div', 'Add to Watchlist'),
      'new watchlist': by.css('.menu .new-watchlist'),
      'workspace dropdown': by.css('.workspaces__item-name'),
      'watchlist dropdown': by.css('.dropdown__content:not(.hide) .watchlist-item'),
      'market 360': by.css('.menu__item.product-page'),
      'price alert': by.css('.menu__item.alert'),
      'squares icon': by.css('.icon-productpage')
    },
    buttons: {
      sell: by.css('.button-sell'),
      buy: by.css('.button-buy'),
      floatingsell: by.css('div[class*="button--sell"]'),
      floatingbuy: by.css('div[class*="button--buy"]'),
      price: by.css('.button-dealticket__value')
    },
    hideBtn: by.css('.icon-left-arrows')
  };

  constructor(panelRoot: ElementFinder) {
    super(panelRoot);
    this.name = 'Chart';
  }

  async getLocation(elementName) {
    const location = await element(this.data[elementName]).getLocation();

    return location;
  }

  async clickInsideChart() {
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    await element(this.data.chartBody).click();
    await browser.switchTo().defaultContent();
  }

  async getText(chartElement) {
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    chartElement = chartElement.includes('button')
      ? await element(this.data.buttons[`${chartElement.trim().split(' ')[0]}`])
      : await element(this.data[`${chartElement.trim()}`]);
    const text = await chartElement.getText();
    await browser.switchTo().defaultContent();

    return text;
  }

  async isChartVisible() {
    // await element(this.data.iframeRoot).waitReady(3000);
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    // await element(this.data.chartBody).waitReady(10000);
    const is = await element(this.data.chartBody).isPresent();
    await browser.switchTo().defaultContent();

    return is;
  }

  async switchMarket(marketName: string) {
    await element(this.data.iframeRoot).waitReady(5000);
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    await element(this.data.marketSearchInput).waitReady(10000);
    await element(this.data.marketSearchInput).clear();
    await element(this.data.marketSearchInput).sendKeys(marketName);
    // on vm marketSearchResults do not appear
    if (process.env.npm_config_browser !== 'edge') {
      await element(this.data.marketSearchResults).waitReady(15000);
    }
    await element(this.data.marketSearchInput).sendKeys(protractor.Key.DOWN);
    await element(this.data.marketSearchInput).sendKeys(protractor.Key.ENTER);
    await browser.switchTo().defaultContent();
  }

  async hide() {
    await element(this.data.hideBtn).click();
  }

  async getMarketNameLabelText(isOnIframe?: string) {
    if (isOnIframe) {
      // await element(this.data.iframeRoot).waitReady(5000);
      await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    } else {
      // await this.container.element(this.data.iframeRoot).waitReady(5000);
      await browser.switchTo().frame(this.container.element(this.data.iframeRoot).getWebElement());
    }
    // await helper.sleep(2000);
    const text = (await element(this.data.marketNameLabel).getText()).trim();
    await browser.switchTo().defaultContent();

    return text;
  }

  async isChartElementVisibleOnMouseHover(chartElement: string) {
    chartElement = chartElement.trim();
    await element(this.data.iframeRoot).waitReady(6000);
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    await element(this.data.chartBody).waitReady(2000);
    await element(this.data.chartBody).hover();
    const is = await element(this.data[chartElement]).isPresent();
    await browser.switchTo().defaultContent();

    return is;
  }

  async isElementEnable(chartElement) {
    await element(this.data.iframeRoot).waitReady(6000);
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    await element(this.data.chartBody).waitReady(2000);
    chartElement = chartElement.includes('button')
      ? await element(this.data.buttons[`${chartElement.trim().split(' ')[0]}`])
      : await element(this.data[`${chartElement.trim()}`]);
    const is = await chartElement.isEnabled();
    await browser.switchTo().defaultContent();

    return is;
  }

  async getButtonBackground(buttonName) {
    buttonName = buttonName.trim().split(' ')[0];
    // await element(this.data.iframeRoot).waitReady(6000);
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    // await element(this.data.chartBody).waitReady(2000);
    const color = await element(this.data.buttons[buttonName]).getCssValue('background-color');
    await browser.switchTo().defaultContent();

    return color;
  }

  async isElementInsideChart(includedElement) {
    // await element(this.data.iframeRoot).waitReady(6000);
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    // await element(this.data.chartBody).waitReady(2000);

    includedElement = includedElement.includes('button')
      ? await element(this.data.buttons[`${includedElement.trim().split(' ')[0]}`])
      : await element(this.data[`${includedElement.trim()}`]);
    const coordinates = await this.getCoordinates(includedElement, await element(this.data['chart table']));
    await browser.switchTo().defaultContent();

    return this.isValueBetween(coordinates.x) && this.isValueBetween(coordinates.y);
  }

  private async getCoordinates(includedElement: ElementFinder, containerElement: ElementFinder) {
    const includedElementLocation = await includedElement.getLocation();
    const containerLocation = await containerElement.getLocation();
    const containerSize = await containerElement.getSize();

    return {
      x: {
        value: includedElementLocation.x,
        lowerValue: containerLocation.x,
        upperValue: containerLocation.x + containerSize.width
      },
      y: {
        value: includedElementLocation.y,
        lowerValue: containerLocation.y,
        upperValue: containerLocation.y + containerSize.height
      }
    };
  }

  private isValueBetween({value, lowerValue, upperValue}) {
    return value >= lowerValue && value <= upperValue;
  }
/*
  async moveSellBuyButtons() {
    await element(this.data.iframeRoot).waitReady(6000);
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    await element(this.data.chartBody).waitReady(2000);
    const sellBuyButtons = await element(this.data.draggableButtons);
    sellBuyButtons.waitReady(2000);
    await this.dragAndDropBasedOnChart(sellBuyButtons, {x: 200, y: 200 });
    await browser.switchTo().defaultContent();
  }
*/
  async dragAndDropBasedOnChart(elem: ElementFinder, location: {x, y}) {
    const chart = await element(this.data['chart table']);
    chart.waitReady(2000);

    return browser.actions().mouseMove(elem).mouseDown().mouseMove(chart, location).mouseUp().perform()
      .then(() => null, () => console.log('actions error'));
  }

  async clickOnChartPrice(direction: string, isFloating?) {
    // await element(this.data.iframeRoot).waitReady(6000);
    await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    // await element(this.data.chartBody).waitReady(2000);
    // await element(this.data['chart table']).waitReady(3000);
    await element(this.data['chart table']).click();
    const letter = direction.toLowerCase().trim() === 'sell' ? 's' : 'b';
    // workaround for clicking sell/buy in chart
    if (process.env.npm_config_browser.includes('firefox')) {
      if (isFloating) {
        direction = `floating${direction.trim()}`;
      }
      const chartElement = await element(this.data.buttons[`${direction.trim()}`]);
      // await chartElement.element(this.data.buttons.price).waitReady(10000);
      await chartElement.hover();
      await chartElement.click();
    } else {
      await browser.actions().keyDown(protractor.Key.SHIFT).sendKeys(letter).keyUp(protractor.Key.SHIFT).perform();
      console.log('Shift + s/b instead of click (chart sell/buy)');
    }
    // console.log('click through jsExecutor (chart)');
    // await browser.executeScript(`$(arguments[0]).click();`, chartElement.getWebElement());
    await browser.switchTo().defaultContent();
  }

  async clickOnElement(elem: string) {
    await element(this.data.menu[elem]).scrollToAndClick();
  }

  async addChartTo(elementNameForAdding) {
    await new ActionMenu().clickItem(elementNameForAdding);
  }

  async waitForElementDisappeared(elementName: string) {
    elementName = elementName.toLowerCase();

    if (elementName.includes('dropdown')) {
      return await new ActionMenu().waitActionMenuDisappeared();
    }
  }

  async isElementPresent(elementName) {
    const locators = {
      chart: this.data.iframeRoot
    };
    if (elementName.includes('dropdown')) {
      return await new ActionMenu().isVisible();
    } else {
      return element(locators[elementName]).isPresent();
    }
  }

  async waitForChartLoading(isWaitPrice = false) {
    // test fails without this wait
    await element(this.data.iframeRoot).waitReady(40000);

    // it was used for slow loading prices from floating buy/sell buttons
    /*await browser.switchTo().frame(element(this.data.iframeRoot).getWebElement());
    if (isWaitPrice) {
      await element(this.data.buttons.price).waitReady(40000)
        .then(() => null, (error) => console.error('Price is not displayed'));
    }
    await browser.switchTo().defaultContent();*/
  }
}
