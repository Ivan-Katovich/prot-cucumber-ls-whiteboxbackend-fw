import { browser, element, by, ElementFinder, protractor } from 'protractor';
import { WorkspaceBoard } from '../boards/workspace-board';
import { BrowseTab } from '../boards/browse-tab';
import { SearchModal } from '../modal-dialogues/search-modal';
import { MyAccount } from '../boards/account-tab';
import { HelpModal } from '../modal-dialogues/help-modal';
import { NotificationModal } from '../modal-dialogues/notification-modal';
import { GuideBubble } from '../elements/guide-bubble';
import { ActionMenu, Dropdown, DateTimePicker, WorkspaceDropdown } from '../elements/dropdown';
import { helper } from '../../utils/helper';

const constructors = {
  browse: BrowseTab,
  workspace: WorkspaceBoard,
  myaccount: MyAccount
};

export class BasePage {
  private curBoard = new WorkspaceBoard();
  private searchModalItem = null;
  private helpModalItem = null;
  private notificationModalItem = null;
  private guideBubbleItem = null;
  private data = {
    version: by.css('.version'),
    'loading spinner': by.css('.loader-overlay .spinner'),
    'loading overlay': by.css('.loader-overlay'),
    header: {
      root: by.tagName('app-header'),
      logo: by.css('.logo-container'),
      'balance bar': by.css('.balance-bar'),
      'add funds button': by.tagName('app-add-funds'),
      'one click trading toggle': by.css('.one-click-trading-toggle'),
      searchDiv: by.css('.market-search__button'),
      searchInput: by.css('.market-search__search-input'),
      searchIcon: by.css('.market-search__search-icon'),
      feedbackBtn: by.css('.feedback'),
      'help button': by.css('.icon-bar .toggle-help .icon-question'),
      'close help modal': by.css('.icon-question-filled'),
      userPan: by.tagName('app-user-menu'),
      'user account': by.css('.user-menu'),
      userIcon: by.css('.icon-user-black,.icon-user-white'),
      notifications: by.css('.toggle-notifications'),
      logoutLogo: by.css('.utility-nav__logo'),
      'one click trading': {
        root: by.css('.slide-toggle--bar'),
        'one click trading message': by.css('.notification__content'),
        cancelBtn: by.css('.notification__contextual-menu *:nth-child(1)'),
        okBtn: by.xpath(`//button[contains(@class, 'notification__contextual-button')][contains(text(), 'Ok')]`)
        // okBtn: by.css('.notification__contextual-menu *:nth-child(2)')
      },
      'reset button': by.css('.icon-close'),
      'search button': by.css('.icon-search')
    },
    balanceBar: {
      root: by.css('.balance-bar'),
      balanceItem: by.css('.balance-bar__item'),
      'available to trade': by.css('.balance-bar__item--available-to-trade'),
      'net equity': by.css('.balance-bar__item--net-equity'),
      cash: by.css('.balance-bar__item--cash'),
      'unrealised p&l': by.css('.balance-bar__item--unrealised'),
      'total margin': by.css('.balance-bar__item--margin'),
      'margin indicator': by.css('.balance-bar__item--margin-indicator'),
      balanceNumber: by.css('.balance-bar__item-number'),
      balanceCurrency: by.css('.balance-bar__item-number--account-currency')
    },
    searchModel: by.css('.market-search-modal'),
    userMenu: {
      root: by.css('user-menu__dropdown'),
      myAccLink: by.css('.link--my-account'),
      logOutLink: by.css('.link--log-out>a')
    },
    feedback: {
      root: by.css('.feedback-panel'),
      feedbackLink: by.css('.feedback-panel__link'),
      feedbackList: by.css('.feedback-panel__list'),
      feedbackItem: by.css('.feedback-panel__item-link'),
      feedbackText: by.css('.feedback-panel__textarea'),
      feedbackMessage: by.css('.feedback-panel__message'),
      submitBtn: by.css('.submit-button') // by.css('.feedback-panel__submit')
    }
  };

  get currentBoard() {
    return this.curBoard;
  }

  getVersion() {
    return browser.executeScript(`return $(arguments[0]).text();`, element(this.data.version).getWebElement());
  }

  async waitLoading() {
    await this.header.logo.waitReady(40000);
    await element(this.data['loading overlay']).waitReady(1000).then(() => null, () => null);
    await element(this.data['loading spinner']).waitMissing(40000);
    await element(this.data['loading overlay']).waitMissing(10000);
  }

  get header() {
    const self = this;
    const root = element(self.data.header.root);

    return {

      get logo(): ElementFinder {
        return element(self.data.header.logo);
      },

      get userIcon(): ElementFinder {
        return element(self.data.header.userIcon);
      },

      async selectBoard(board: string) {
        board = board.toLowerCase();
        const targetBoard = element(self.data.header[board]);
        const strClass = await targetBoard.getAttribute('class');
        if (!strClass.includes('mode-toggle-container--active')) {
          await targetBoard.click();
        } else {
          console.log('Board has been already selected');
        }
        self.curBoard = new constructors[board]();

        return self.curBoard;
      },

      isBoardActive(board: string) {
        board = board.toLowerCase();
        const targetBoard = element(self.data.header[board]);

        /* return browser.wait(() => {
          return targetBoard.getAttribute('class')
            .then((strClass) => strClass.includes('mode-toggle-container--active'));
        }, 3000)
          .then(() => true, () => false); */
        return targetBoard.getAttribute('class')
          .then((strClass) => strClass.includes('mode-toggle-container--active'));
      },

      async clickSearch() {
        const el = await element(self.data.header.searchInput).waitReady(2000);

        if (process.env.npm_config_browser.includes('firefox') || process.env.npm_config_browser.includes('safari')) {
          await el.click();
          // FF workaround: Search modal is not displayed on first click
          if (process.env.npm_config_browser.includes('firefox') && !(await element(by.css('.market-search-modal')).isPresent())) {
            console.log('2nd click FF');
            await el.click();
          }
        } else {
          browser.actions().mouseMove(el).mouseDown().mouseUp().perform()
            .then(() => null, () => console.log('actions error'));
        }
      },

      async clickLogo() {
        // const el = await element(self.data.header.logo).waitReady(2000);
        const el = element(self.data.header.logo);
        await el.click();
      },

      async addSearchValue(value: string) {
        // const el = await element(self.data.header.searchInput).waitReady(2000);
        const el = element(self.data.header.searchInput);
        await el.clear();
        await el.sendKeys(value);
      },

      async getSearchText(textType: string) {
        // const el = await element(self.data.header.searchInput).waitReady(2000);
        const el = element(self.data.header.searchInput);

        return el.getAttribute(textType);
      },

      async clearSearchInput() {
        // const el = await element(self.data.header.searchInput).waitReady(2000);
        const el = element(self.data.header.searchInput);
        await el.clear();
      },

      async isElementPresent(elementName: string) {
        const headerElements = {
          'one click trading message': self.data.header['one click trading']['one click trading message']
        };

        let el = await element(self.data.header[elementName]).waitReady(1000)
          .catch(() => false);

        if (!el) {
          el = element(headerElements[elementName]);
        }

        return el.isDisplayed();
        },

      async getSize(elementName: string) {
        // const el = await element(self.data.header[elementName]).waitReady(5000);
        const el = element(self.data.header[elementName]);

        return el.getSize();
      },

      async click(elementName: string) {
        const headerElements = {
          'one click trading': self.data.header['one click trading'].root
        };

        let el = await element(self.data.header[elementName]).waitReady(1000)
          .catch(() => false);

        if (!el) {
          el = element(headerElements[elementName]);
        }
        await el.click();
        },

      async getElementLocation(elemToCompare) {
        elemToCompare = elemToCompare.toLowerCase();
        const locators = {
          header: self.data.header.root,
          'search field': self.data.header.searchInput
        };

        return element(locators[elemToCompare]).getLocation();
      },

      async setOneClickTrading(status: boolean) {
        const el = element(self.data.header['one click trading'].root);
        const okBtn = element(self.data.header['one click trading'].okBtn);
        const actualStatus = (await el.getAttribute('class')).includes('active');
        if (actualStatus !== status) {
          await el.click();
          if (status) {
            await okBtn.click();
          }
        }
      },

      async isOneClickTradingON() {
        return (await element(self.data.header['one click trading'].root).getAttribute('class')).includes('active');
      },

      async getBackgroundColor(elementName) {
        const headerElements = {
          'one click trading': self.data.header['one click trading'].root
        };

        return element(headerElements[elementName]).getCssValue('background-color');
      },

      async closeOneClickTradingMessage(action) {
        await element(self.data.header['one click trading'][`${action}Btn`]).click();
      }
    };
  }

  get balanceBar() {
    const self = this;
    const root = element(self.data.header.root);

    return {
      async getElementText(elementName: string) {
        return element(self.data.balanceBar[elementName]).getText();
      },

      async getElementItemValue(elementName: string) {
        return element(self.data.balanceBar[elementName]).element(by.css('.balance-bar__item-number')).getText();
      }
    };
  }

  get searchModal() {
    if (!this.searchModalItem) {
      this.searchModalItem = new SearchModal();
    }

    return this.searchModalItem;
  }

  get helpModal() {
    if (!this.helpModalItem) {
      this.helpModalItem = new HelpModal();
    }

    return this.helpModalItem;
  }

  get notificationModal() {
    if (!this.notificationModalItem) {
      this.notificationModalItem = new NotificationModal();
    }

    return this.notificationModalItem;
  }

  get guideBubble() {
    if (!this.guideBubbleItem) {
      this.guideBubbleItem = new GuideBubble();
    }

    return this.guideBubbleItem;
  }

  get feedbackModal() {
    const self = this;

    return {
      get feedbackLink() {
        return element(self.data.feedback.feedbackLink);
      },

      async redirect(to) {
        const elements = {
          'contact us': element(self.data.feedback.feedbackLink),
          'client management': element.all(self.data.feedback.feedbackItem).get(0),
          phone: element.all(self.data.feedback.feedbackItem).get(1),
          chat: element.all(self.data.feedback.feedbackItem).get(2)
        };
        const appWindow = await browser.getWindowHandle();
        await elements[to].click();

        await browser.wait(helper.windowCount(2), 10000);
        await browser.getAllWindowHandles().then((handles) => {
          let handleNumber = handles.length - 1;
          if (process.env.npm_config_browser === 'safari') {
            handleNumber = handles.indexOf(appWindow) === 0 ? handleNumber : handles.length - handleNumber - 1;
          }
          browser.switchTo().window(handles[handleNumber]);
        });
        // await browser.waitForAngularEnabled(false);
      },

      async isElementPresent(elementName: string) {
        const elements = {
          'contact us': element(self.data.feedback.feedbackLink),
          'client management': element.all(self.data.feedback.feedbackItem).get(0),
          phone: element.all(self.data.feedback.feedbackItem).get(1),
          chat: element.all(self.data.feedback.feedbackItem).get(2),
          'feedback text area': element(self.data.feedback.feedbackText),
          'submit button': element(self.data.feedback.submitBtn)
        };

        return elements[elementName].waitReady(2000)
          .then(() => true, () => false);
      },

      async getElementHref(elementName: string) {
        const elements = {
          'contact us': element(self.data.feedback.feedbackLink),
          'client management': element.all(self.data.feedback.feedbackItem).get(0),
          phone: element.all(self.data.feedback.feedbackItem).get(1),
          chat: element.all(self.data.feedback.feedbackItem).get(2)
        };
        // const el = await elements[elementName].waitReady(2000);
        const el = elements[elementName];

        return (await el.getAttribute('href')).trim();
      },

      async getElementText(elementName: string) {
        const elements = {
          'contact us': element(self.data.feedback.feedbackLink),
          'client management': element.all(self.data.feedback.feedbackItem).get(0),
          phone: element.all(self.data.feedback.feedbackItem).get(1),
          chat: element.all(self.data.feedback.feedbackItem).get(2),
          'feedback message': element(self.data.feedback.feedbackMessage)
        };
        // const el = await elements[elementName].waitReady(2000);
        const el = elements[elementName];

        return (await el.getText()).trim();
      },

      async isSubmitActive() {
        // const el = await element(self.data.feedback.submitBtn).waitReady(2000);
        const el = element(self.data.feedback.submitBtn);
        const cls = await el.getAttribute('class');

        return cls.includes('disabled');
      },

      async fillInputWithValue(value) {
        // const input = await element(self.data.feedback.feedbackText).waitReady(2000);
        const input = element(self.data.feedback.feedbackText);
        await input.clear();
        await input.sendKeys(value);
      },

      async click(elementName: string) {
        // const el = await element(self.data.feedback[elementName]).waitReady(5000);
        const el = element(self.data.feedback[elementName]);
        await el.click();
      }
    };
  }

  get userMenu() {
    const self = this;

    return {

      get logOutLink() {
        return element(self.data.userMenu.logOutLink);
      },

      get myAccLink() {
        return element(self.data.userMenu.myAccLink);
      },

      isAccountActive() {
        /* return browser.wait(() => {
          return element(self.data.userMenu.myAccLink).getAttribute('class')
            .then((strClass) => strClass.includes('link--active'));
        }, 10000)
          .then(() => true, () => false); */
        return element(self.data.userMenu.myAccLink).getAttribute('class')
          .then((strClass) => strClass.includes('link--active'));
      },

      isElementPresent(elementName: string) {
        return element(self.data.userMenu[elementName]).waitReady(3000)
          .then(() => true, () => false);
      },

      async click(elementName: string) {
        // const el = await element(self.data.userMenu[elementName]).waitReady(2000);
        const el = element(self.data.userMenu[elementName]);
        await el.click();
      }
    };
  }

  get dropdown() {
    return new Dropdown();
  }

  get workspaceDropdown() {
    return new WorkspaceDropdown();
  }

  get dateTimePicker() {
    return new DateTimePicker();
  }

  get actionsMenu() {
    return new ActionMenu();
  }

  async logOut() {
    await this.header.userIcon.click();
    await this.userMenu.logOutLink.click();
  }
}

