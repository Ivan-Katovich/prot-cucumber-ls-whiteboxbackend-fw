import { defineSupportCode } from 'cucumber';
import * as moment from 'moment';


defineSupportCode(function({ Given, When, Then }) {

  When(/^I scroll to (last article|first article|article title|) in the news list$/, async function(elementName) {
    await this.basePage.currentBoard.tabBody.currentPanel.scrollElementIntoView(elementName);
  });

  Then(/^articles should be (visible|invisible)( within no panel component of New feed|)$/, async function(visibility, elementType) {
    const expectedState = visibility === 'visible';
    let actualState;
    if (elementType.includes('no panel')) {
      actualState = await this.basePage.currentBoard.tabBody.getNoPanelComponent('news feed').isListArticlesVisible();
    } else {
      actualState = await this.basePage.currentBoard.tabBody.currentPanel.isListArticlesVisible();
    }

    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^each article has timestamp$/, async function() {
    const result = await this.basePage.currentBoard.tabBody.currentPanel.getTimestampOfArticles();

    this.expect(result.length).to.not.equal(0);

    result.forEach((timestamp) => {
      this.expect(timestamp).to.match(/(^\d{1,2}?[ A-Z]{2,}(AGO|\d{4})$)|(^A FEW SECONDS AGO$)/i);
    });
  });

  Then(/^each article has title(?: with word '(.+)'|)$/, async function(expectedWord) {
    const titles = await this.basePage.currentBoard.tabBody.currentPanel.getTitleOfArticles();

    this.expect(titles.length).to.not.equal(0);

    titles.forEach((title) => {
      this.expect(title.length).to.not.equal(0);
      if (expectedWord) {
        this.expect(title.toLowerCase()).to.include(expectedWord);
      }
    });
  });

  Then(/^articles are shown in descending order based on timestamp$/, async function() {
    const results = await this.basePage.currentBoard.tabBody.currentPanel.getTimestampOfArticles();

    this.expect(results.length).to.not.equal(0);

    let current: number;
    let next: number;

    for (let i = 0; i < results.length - 1; i++) {
      if (results[i + 1]) {
        if ((results[i].includes('MIN') && results[i + 1].includes('MIN')) ||
          (results[i].match(/\d{1,2}H/) && results[i + 1].match(/\d{1,2}H/))) {
          current = parseInt(results[i].replace(/^(\d{1,2})[ A-Z]{2,}(AGO|\d{4})$/, '$1'));
          next = parseInt(results[i + 1].replace(/^(\d{1,2})[ A-Z]{2,}(AGO|\d{4})$/, '$1'));
          this.expect(current).to.be.at.most(next);
        } else if (results[i].match(/\d{1,2}H/) && results[i + 1].includes('MIN')) {
          this.expect('MINS before HOURS').to.equal('MINS after HOURS');
        } else if (results[i] !== 'A FEW SECONDS AGO' && results[i + 1] === 'A FEW SECONDS AGO') {
          this.expect('SECONDS before OTHER').to.equal('SECONDS after OTHER');
        } else if (results[i].match(/\d{4}/) && results[i + 1].match(/\d{1,2}H/)) {
          this.expect('HOURS before DATES').to.equal('HOURS after DATES');
        } else if (results[i].match(/\d{4}/) && results[i + 1].match(/\d{4}/)) {
          current = parseInt(moment(results[i], 'D MMM YYYY').format('x'));
          next = parseInt(moment(results[i + 1], 'D MMM YYYY').format('x'));
          this.expect(current).to.be.at.least(next);
        } else {
          this.expect(true).to.equal(true);
        }
      }
    }
  });

  Then(/^'(.+)' should be (visible|invisible)$/, async function(name, visibility) {
    const expectedState = visibility === 'visible';
    const actualState = await this.basePage.currentBoard.tabBody.currentPanel.isVisibleElementDetailNews(name);

    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^search input placeholder should be '(.+)'$/, async function(expectedPlaceholder) {
    const actualPlaceholder = await this.basePage.currentBoard.tabBody.currentPanel.getSearchInputPlaceholder();

    this.expect(actualPlaceholder).to.equal(expectedPlaceholder);
  });

  Then(/^news list is displayed under search field$/, async function() {
    const newsListLocation = await this.basePage.currentBoard.tabBody.currentPanel.getElementLocation('news list');
    const searchFieldLocation = await this.basePage.currentBoard.tabBody.currentPanel.getElementLocation('search field');

    this.expect(newsListLocation.y).to.be.above(searchFieldLocation.y);
  });

  Then(/^articles count should be '(.+)'$/, async function(expectedNumber) {
    expectedNumber = parseInt(expectedNumber);
    const actualNumber = await this.basePage.currentBoard.tabBody.currentPanel.getArticlesCount();

    this.expect(actualNumber).to.equal(expectedNumber);
  });

  Then(/^displayed news should be related to '(.+)' market$/, async function(marketName) {
    if (marketName === 'current') {
      marketName = this.memory.marketName;
    }
    const marketId = this.idMatcher.market[marketName];
    const expectedHeadlines = await this.backendHelper.getMarketsNews(marketId);
    const actualHeadlines = await this.basePage.currentBoard.tabBody.currentPanel.getTitleOfArticles();
    this.expect(actualHeadlines.sort()).to.deep.equal(expectedHeadlines.sort());
  });

  Then(/^empty message should be (visible|invisible)(?: and contain text '(.+)'|)$/, async function(visibility, expectedText) {
    const expectedState = visibility === 'visible';
    const actualResults = await this.basePage.currentBoard.tabBody.currentPanel.getEmptyText();
    expectedText = expectedState ? expectedText : null;

    this.expect(actualResults.is).to.equal(expectedState);
    this.expect(actualResults.text).to.equal(expectedText);
  });

  When(/^I click on '(.+)'(?:st|th|nd|rd|) article in the list$/, async function(numberNews) {
    await this.basePage.currentBoard.tabBody.currentPanel.expandNews(parseInt(numberNews) - 1);
  });

  When(/^I click on Button back$/, async function() {
    await this.basePage.currentBoard.tabBody.currentPanel.clickButtonBack();
  });

  When(/^I click search '(.+)'$/, async function(item) {
    await this.basePage.currentBoard.tabBody.currentPanel.clickSearchItems(item);
  });

  When(/^I fill search input with value '(.+)'$/, async function(value) {
    await this.basePage.currentBoard.tabBody.currentPanel.fillSearchInputWithValue(value);
  });
});
