import { browser, by, element, protractor } from 'protractor';
import { WatchlistPanel } from '../panels/watchlist-panel';
import { PositionsAndOrdersPanel, ReportsPanel } from '../panels/positions-and-orders-panel';
import { DealTicketPanel } from '../panels/deal-ticket-panel';
import { DetailsPanel } from '../panels/details-panel';
import { NewsPanel } from '../panels/news-panel';
import { EconomicCalendarPanel } from '../panels/economic-calendar-panel';
import { ChartPanel } from '../panels/chart-panel';
import { WatchlistContainer } from '../no-panels-component/watchlist-container';
import { MarketContainer } from '../no-panels-component/market-container';
import { MarketInformation } from '../no-panels-component/market-information';
import { BrowseTab } from './browse-tab';
import { MyAccount } from './account-tab';
import { helper } from '../../utils/helper';
import { WorkspaceDropdown } from '../elements/dropdown';


const constructors = {
  watchlist: WatchlistPanel,
  'positions and orders': PositionsAndOrdersPanel,
  reports: ReportsPanel,
  'deal ticket': DealTicketPanel,
  details: DetailsPanel,
  'history detail': DetailsPanel,
  'news feed': NewsPanel,
  'economic calendar': EconomicCalendarPanel,
  chart: ChartPanel,
  'watchlist container': WatchlistContainer,
  'market container': MarketContainer,
  'market information': MarketInformation
};


export class WorkspaceBoard {
  private currentPan;
  private browseTab;
  private myAccountItem;
  private data = {
    header: {
      root: by.tagName('app-workspace-header'),
      tabs: {
        root: by.css('.workspace__item'),
        closeButton: by.css('.icon-close'),
        name: by.css('.workspace-name'),
        tabHeader: by.css('.dropdown-container'),
        tabMenuBtn: by.css('.icon-dots-vertical'),
        tabMenu: {
          root: by.css('body>div.dropdown__content'),
          buttons: by.css('.components-list__item'),
          count: by.css('.item-count'),
          buttonTitle: by.css('.item-title'),
          clearWorkspace: by.css('.clear-workspace'),
          deleteWorkspace: by.css('.remove-workspace'),
          showMeButton: by.css('.at-workspace-components-state__link'),
          containerOpenedComponents: by.css('.components'),
          openedComponent: by.css('.components__item'),
          closeComponentButton: by.css('.icon-close'),
          iconForRename: by.css('.icon-edit'),
          inputForRename: by.css('.workspace-info > input'),
        }
      },
      iconCreateNewWorkspace: by.css('.create-new-workspace > .icon-plus'),
      plusBtn: by.css('.create-new-workspace')
    },
    tabBody: {
      root: by.css('.panel-container'),
      panels: by.tagName('app-workspace-panel'),
      noPanelComponent: {
        news: by.css('.news-economic'),
        watchlistContainer: by.tagName('app-product-page-watchlist'),
        // marketsContainer: by.css('.markets-list-container'),
        marketsContainer: by.tagName('app-markets-list'),
        marketInformation: by.tagName('app-ci-market-information'),
        chart: by.css('.chart-placeholder'),
        economicCalendar: by.css('.news-economic')
      }
    },
    productPage: {
      root: by.tagName('app-full-screen-panel')
    },
    balance: {
      root: by.css('.balance-bar')
    }
  };

  get header() {
    const self = this;

    return {

      async addNewTab() {
        let tabsCount = 0;
        const el = await element(self.data.header.plusBtn).waitReady(3000);
        /* await browser.wait(() => {
          return this.getTabsNumber()
            .then((num) => {
              tabsCount = num;

              return el.click()
                .then(() => null, () => {
                  console.log('plusBtn is not attached to the DOM');
                });
            })
            .then(() => this.getTabsNumber())
            .then((num) => helper.sleepIfFalse(num > tabsCount, 300));
        }, 10000); */

        this.getTabsNumber()
          .then((num) => {
            tabsCount = num;

            return el.click()
              .then(() => null, () => {
                console.log('plusBtn is not attached to the DOM');
              });
          });
      },

      getTabsNumber() {
        return element.all(self.data.header.tabs.root).count();
      },

      isCreateNewWorkspaceVisible() {
        return element(self.data.header.iconCreateNewWorkspace).waitReady(2000)
          .then(() => true, () => false);
      },

      getTab(nameOrNumber) {
        let tab;
        if (typeof nameOrNumber === 'number') {
          tab = element.all(self.data.header.tabs.root).get(nameOrNumber);
        } else {
          tab = element.all(self.data.header.tabs.root).filter((t) => {
            return t.element(self.data.header.tabs.name).getText()
              .then((text) => {
                return text.trim().toLowerCase() === nameOrNumber.toLowerCase(); // to test how it will be with lowerCase
              });
          }).first();
        }

        return {

          async getName() {
            return tab.element(self.data.header.tabs.name).getText()
              .then((text) => text.trim(), () => {
                return helper.sleep(500)
                  .then(() => {
                    return tab.element(self.data.header.tabs.name).getText();
                  })
                  .then((text) => text.trim());
              });
          },

          async getLocation() {
            return tab.getLocation();
          },

          async getSize() {
            return tab.getSize();
          },

          async getButtonName(nameOrNum) {
            return new WorkspaceDropdown().getPanelButtonFullText(nameOrNum);
          },

          clickButton(nameOrNum) {
            return new WorkspaceDropdown().clickPanelButton(nameOrNum);
          },

          async getChartsNumber() {
            return new WorkspaceDropdown().getChartsNumber();
          },

          async closeTab() {
            await this.expandDropdown();
            await new WorkspaceDropdown().clickSupportButton('delete workspace');
          },

          async expandDropdown() {
            // await tab.element(self.data.header.tabs.tabMenuBtn).waitReady(3000);
            await tab.element(self.data.header.tabs.tabMenuBtn).click();
            const isMenuVisible = await element(self.data.header.tabs.tabMenu.root).waitReady(2000)
              .then(() => true, () => false);
            if (!isMenuVisible) {
              await tab.element(self.data.header.tabs.tabMenuBtn).click();
              // await element(self.data.header.tabs.tabMenu.root).waitReady(2000);
            }
          },

          async switchTo() {
            const tabHeaderOrName = process.env.npm_config_browser === 'safari' ? self.data.header.tabs.tabHeader
                                                                                : self.data.header.tabs.name;
            // await tab.element(tabHeaderOrName).waitReady(5000);
            const cls = await tab.getAttribute('class')
              .then(null, () => {
                return helper.sleep(500)
                  .then(() => tab.getAttribute('class'));
              });
            if (!cls.includes('active')) {
              await tab.element(tabHeaderOrName).click()
                .then(() => {}, () => {
                  return helper.sleep(500)
                    .then(() => {
                      return tab.element(tabHeaderOrName).click();
                    });
                });
            }
            await tab.element(self.data.header.tabs.tabMenuBtn).waitReady(2000)
              .then(null, (err) => {
                return tab.element(tabHeaderOrName).click()
                  .then(() => null, () => null);
              });
          },

          isActive() {
            if (process.env.npm_config_browser === 'edge') {
              return browser.wait(() => {
                return tab.getAttribute('class')
                  .then((cls) => {
                    return cls.includes('active');
                  })
                  .then((is) => is, () => false)
                  .then((is) => helper.sleepIfFalse(is));
              }, 2000)
                .then(() => true, () => false);
            } else {
              return tab.getAttribute('class')
                .then((cls) => {
                  return cls.includes('active');
                })
                .then((is) => is, () => false);
            }
          },

          async addNewPan(nameOrNum) {
            /* await tab.element(self.data.header.tabs.tabMenuBtn).waitReady(5000);
            await browser.wait(() => {
              return element(self.data.header.tabs.tabMenu.root).isPresent()
                .then((is) => {
                  if (!is) {
                    return tab.element(self.data.header.tabs.tabMenuBtn).click()
                      .then(() => element(self.data.header.tabs.tabMenu.root).waitReady(2000))
                      .then(() => is);
                  } else {
                    return is;
                  }
                });
            }, 10000); */
            await element(self.data.header.tabs.tabMenu.root).isPresent()
              .then((is) => {
                if (!is) {
                  tab.element(self.data.header.tabs.tabMenuBtn).click();
                }
              });

            await new WorkspaceDropdown().addNewPan(nameOrNum);
            await tab.click();
          },

          async isPanelActive(nameOrNum, needClose = false) {
            /* await tab.element(self.data.header.tabs.tabMenuBtn).waitReady(5000);
            await browser.wait(() => {
              return element(self.data.header.tabs.tabMenu.root).isPresent()
                .then((is) => {
                  if (!is) {
                    return tab.element(self.data.header.tabs.tabMenuBtn).click()
                      .then(() => element(self.data.header.tabs.tabMenu.root).waitReady(2000))
                      .then(() => is, () => false);
                  } else {
                    return is;
                  }
                });
            }, 10000); */
            await element(self.data.header.tabs.tabMenu.root).isPresent()
              .then((is) => {
                if (!is) {
                  tab.element(self.data.header.tabs.tabMenuBtn).click();
                }
              });

            const isActive = await new WorkspaceDropdown().isPanelActive(nameOrNum);
            if (needClose) {
              await tab.click();
            }

            return isActive;
          }
        };
      }
    };
  }

  get tabBody() {
    const self = this;

    return {

      get browse() {
        if (!self.browseTab) {
          self.browseTab = new BrowseTab();
        }

        return self.browseTab;
      },

      get myAccount() {
        if (!self.myAccountItem) {
          self.myAccountItem = new MyAccount();
        }

        return self.myAccountItem;
      },

      getCountSamePanel(type) {
        type = type.toLocaleLowerCase();
        let typeName = type;
        if (type.includes('position')) {
          typeName = 'position';
        } else if (type.includes('news')) {
          typeName = 'news';
        } else if (type === 'deal ticket') {
          typeName = '';
        } else if (type === 'chart') {
          typeName = /chart|dft|cfd|\//;
        }
        if (type.includes('detail')) {
          typeName = 'detail';
        }

        return element.all(self.data.tabBody.panels).filter((pan) => {
          return pan.element(by.css('.workspace-panel-header__title')).getText()
            .then((text) => {
              if (type === 'chart') {
                return !!text.toLowerCase().trim().match(typeName);
              } else if (typeName) {
                return text.toLowerCase().trim().includes(typeName);
              } else {
                return text.trim() === typeName;
              }
            });
        }).count();
      },

      getPanel(type) {
        type = type.toLocaleLowerCase();
        let typeN = type;
        if (type.includes('positions and orders')) {
          typeN = 'positions';
        } else if (type.includes('reports')) {
          typeN = 'history';
        } else if (type.includes('news')) {
          typeN = 'news';
        } else if (type === 'deal ticket') {
          typeN = '';
        } else if (type === 'chart') {
          typeN = /chart|dft|cfd|\//;
        }
        if (type.includes('detail')) {
          typeN = 'detail';
        }

        const rootEl = element.all(self.data.tabBody.panels).filter((pan) => {
          return pan.element(by.css('.workspace-panel-header__title')).getText()
            .then((text) => {
              if (type === 'chart') {
                return !!text.toLowerCase().trim().match(typeN);
              } else if (typeN) {
                return text.toLowerCase().trim().includes(typeN);
              } else {
                return text.trim() === typeN;
              }
            });
        }).first();
        if (self.currentPan) {
          if (self.currentPan.name.toLowerCase() === type) {
            return self.currentPan;
          }
        }
        self.currentPan = new constructors[type](rootEl);

        return self.currentPan;
      },

      get currentPanel() {
        return self.currentPan;
      },

      set currentPanel(panel) {
        self.currentPan = panel;
      },

      getNoPanelComponent(type) {
        type = type.toLocaleLowerCase();

        const componentSelector = {
          'news feed': self.data.tabBody.noPanelComponent.news,
          'watchlist container': self.data.tabBody.noPanelComponent.watchlistContainer,
          'market container': self.data.tabBody.noPanelComponent.marketsContainer,
          'market information': self.data.tabBody.noPanelComponent.marketInformation,
          chart: self.data.tabBody.noPanelComponent.chart,
          'economic calendar': self.data.tabBody.noPanelComponent.economicCalendar
        };

        const rootEl = element(componentSelector[type]);
        self.currentPan = new constructors[type](rootEl);

        return self.currentPan;
      },

      getElementLocation(elemToCompare) {
        elemToCompare = elemToCompare.toLowerCase();

        const workspaceBoardElements = {
          'news feed': element(self.data.tabBody.noPanelComponent.news),
          'watchlist container': element(self.data.tabBody.noPanelComponent.watchlistContainer),
          'market container': element(self.data.tabBody.noPanelComponent.marketsContainer),
          'market information': element(self.data.tabBody.noPanelComponent.marketInformation),
          chart: element(self.data.tabBody.noPanelComponent.chart),
          'economic calendar': element(self.data.tabBody.noPanelComponent.economicCalendar)
        };

        return workspaceBoardElements[elemToCompare].getLocation();
      }

    };
  }
}
