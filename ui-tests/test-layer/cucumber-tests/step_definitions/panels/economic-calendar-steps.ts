import { defineSupportCode } from 'cucumber';


defineSupportCode(function({ Given, When, Then }) {
  When(/^I switch '(.+)' filter within economic calendar$/, async function(filterName) {
    this.memory.filterName = filterName;
    await this.basePage.currentBoard.tabBody.currentPanel.switchFilter(filterName);
  });

  When(/^I (expand|hide) filters within economic calendar$/, async function(action) {
    const filterName = (action === 'expand') ? 'Show Filters' : 'Hide Filters';
    await this.basePage.currentBoard.tabBody.currentPanel.switchFilter(filterName);
  });

  When(/^I (expand|collapse) '(.+)'(?:st|th|nd|rd|) event within economic calendar$/, async function(action, event) {
    if (parseInt(event)) {
      event--;
    }
    await this.basePage.currentBoard.tabBody.currentPanel[`${action}Event`](event);
  });

  Then(/^event details for '(\d+)'(?:st|th|nd|rd|) event within economic calendar is (visible|invisible)$/, async function(event, state) {
    if (parseInt(event)) {
      event--;
    }
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isElementVisible('bodyContent eventDetailRow', event);
    const expectedState = (state === 'visible') ? true : false;

    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^'(.+)' is (visible|invisible) within economic calendar$/, async function(element, state) {
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isElementVisible(element);
    const expectedState = (state === 'visible') ? true : false;

    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^all the panels parts should be loaded$/, async function() {
    const isHeaderVisible = await this.basePage.currentBoard.tabBody.currentPanel.isElementVisible('header');
    const isBodyVisible = await this.basePage.currentBoard.tabBody.currentPanel.isElementVisible('body');
    const isAnyEventVisible = await this.basePage.currentBoard.tabBody.currentPanel.isElementVisible('bodyContent eventRow');

    this.expect(isHeaderVisible).to.equal(true);
    this.expect(isBodyVisible).to.equal(true);
    if (await this.basePage.currentBoard.tabBody.currentPanel.isElementVisible('noResults')) {
      this.expect(isAnyEventVisible).to.equal(false);
    } else {
      this.expect(isAnyEventVisible).to.equal(true);
    }
  });

  Then(/^scrolling through corresponding events should be available$/, async function() {
    // unable to verify scroll action due to
    // scrollTop attribute always contains 0 for iFrame in safari
    if (process.env.npm_config_browser !== 'safari') {
      const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isScrollingAvailable();
      this.expect(actualState).to.equal(true);
    }
  });
});
