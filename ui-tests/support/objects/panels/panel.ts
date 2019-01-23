import { browser, element, by, ElementFinder } from 'protractor';
import { helper } from '../../utils/helper';


export class Panel {
  protected name: string;
  protected isOpened;
  protected container: ElementFinder;
  private commonData = {
    header: {
      root: by.css('.workspace-panel-header'),
      name: by.css('.workspace-panel-header__title'),
      closeBtn: by.css('.icon-close')
    },
    boarders: by.css('.resize-handle')
  };

  constructor(panelRoot: ElementFinder) {
    this.container = panelRoot;
  }

  close() {
    return this.container.element(this.commonData.header.closeBtn).click();
  }

  isCloseAvailable() {
    return this.container.element(this.commonData.header.closeBtn).waitReady(2000)
      .then((el) => {
        return el.isEnabled();
      }, () => false);
  }

  getPanelName() {
    return this.name;
  }

  async getPanelHeaderName() {
    return (await this.container.element(this.commonData.header.name).getText()).trim();
  }

  async getNoPanelComponentHeaderName(type: string) {
    type = type.toLocaleLowerCase();

    const componentSelector = {
      'news feed': this.container.element(by.css('.news-economic__toggle'))
    };

    return (await componentSelector[type].getText()).trim();
  }

  getProperty(propertyName) {
    const elements = {
      watchlist: this.container.element(by.css('.workspace-panel-content app-watchlists')),
      other: this.container.element(by.css('.workspace-panel-content'))
    };
    const name = this.name.toLowerCase();
    const contentElement = name === 'watchlist' ? elements[name] : elements.other;

    return browser.executeScript(`return $(arguments[0]).${propertyName}();`, contentElement.getWebElement());
  }

  isVisible() {
    return this.container.waitReady(3000)
      .then(() => true, () => false);
  }

  isPresent() {
    return this.container.isPresent();
  }

  waitReady(timeout = 3000) {
    return this.container.waitReady(timeout);
  }

  waitMissing(timeout = 5000) {
    return this.container.waitMissing(timeout)
      .then(() => true, () => false);
  }

  async setSize(height: number, width: number) {
    if (height) {
      await browser.executeScript(`$(arguments[0]).height(${height});`, this.container.getWebElement());
    }
    if (width) {
      await browser.executeScript(`$(arguments[0]).width(${width});`, this.container.getWebElement());
    }
  }

  async getSize() {
    const size = {
      height: null,
      width: null
    };
    size.height = await browser.executeScript(`return $(arguments[0]).height();`, this.container.getWebElement());
    size.width = await browser.executeScript(`return $(arguments[0]).width();`, this.container.getWebElement());

    return size;
  }

  getPosition() {
    return browser.executeScript(`return $(arguments[0]).offset();`, this.container.getWebElement());
  }

  async setPosition(corner, temporaryWindowSize?) {
    let windowSize = {
      height: null,
      width: null
    };

    if (temporaryWindowSize) {
      windowSize.height = temporaryWindowSize.height;
      windowSize.width = temporaryWindowSize.width;
    } else {
      windowSize.height = parseInt(process.env.npm_config_size.split(',')[1]),
      windowSize.width = parseInt(process.env.npm_config_size.split(',')[0])
    }

    const size = await this.getSize();
    const panelLocation = await this.container.getWebElement().getLocation();
    const position = {
      'top-right': `top:80,left:${windowSize.width - size.width - 25}`,
      'top-left': `top:80,left:5`,
      'bottom-right': `top:${windowSize.height - size.height - 135},left:${windowSize.width - size.width - 25}`,
      'bottom-left': `top:${windowSize.height - size.height - 135},left:5`,
      'bottom of the page': `top:${windowSize.height - size.height - 10},left:${panelLocation.x}`
    };

    return browser.executeScript(`$(arguments[0]).offset({${position[corner]}});`, this.container.getWebElement());
  }

  async makeActive() {
    await browser.actions()
      .mouseMove(this.container.element(this.commonData.header.closeBtn))
      .mouseMove({ x: -20, y: 5 })
      .click()
      .perform()
      .then(null, () => console.log('actions error'));
    // await helper.sleep(500);
  }

  dragAndDrop(elem: ElementFinder, target: ElementFinder) {
    return browser.actions().mouseMove(elem).mouseDown().mouseMove(target).mouseMove({x: 0, y: 3}).mouseUp().perform()
      .then(() => null, () => console.log('actions error'));
  }

  moveBoarder(boarderPosition, direction, pixels) {
    const positionClass = {
      top: ' n ',
      bot: ' s ',
      left: ' w ',
      right: ' e '
    };
    const boarder = this.container.all(this.commonData.boarders).filter((el) => {
      return el.getAttribute('class')
        .then((cls) => cls.includes(positionClass[boarderPosition]));
    }).first();

    const location = {x: 0, y: 0};
    if (boarderPosition === 'left' || boarderPosition === 'right') {
      location.y = 0;
      if (direction === 'left') {
        location.x = parseInt(`-${pixels}`);
      } else {
        location.x = parseInt(pixels);
      }
    } else {
      location.x = 0;
      if (direction === 'up') {
        location.y = parseInt(`-${pixels}`);
      } else {
        location.y = parseInt(pixels);
      }
    }

    return browser.actions().mouseMove(boarder).mouseDown().mouseMove(location).mouseUp().perform()
      .then(() => null, () => console.log('actions error'));
  }
}
