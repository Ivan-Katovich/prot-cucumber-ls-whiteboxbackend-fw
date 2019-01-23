import { defineSupportCode } from 'cucumber';
import { browser, element, by, ExpectedConditions } from 'protractor';


defineSupportCode(function({Given, When, Then}) {

  When(/^I open '(.+)'(?:st|th|nd|rd|) item$/, async function(itemNameOrNumber) {
    await this.basePage.helpModal.getItem(itemNameOrNumber).click();
  });

  When(/^I go back$/, async function() {
    await this.basePage.helpModal.clickBack();
  });

  When(/^I close help dialogue$/, async function() {
    await this.basePage.helpModal.close();
  });

  When(/^I click on '(.+)' help modal element$/, async function(elementName) {
    const url = {
      'charts provided by link': 'https://www.tradingview.com/?utm_source=mercury&utm_medium=248946339'
    };
    if (elementName.includes('link')) {
      this.memory[elementName] = url[elementName];
    }
    await this.basePage.helpModal.getItem(elementName).click();
  });

  Then(/^'(.+)'(?:st|th|nd|rd|) section should contain items:$/, async function(sectionNameOrNumber, table) {
    if (parseInt(sectionNameOrNumber)) {
      sectionNameOrNumber = sectionNameOrNumber - 1;
    }
    const actualArray = await this.basePage.helpModal.getSection(sectionNameOrNumber).getItemsNames();
    const actualFixedArray = actualArray.map(t => t.toLowerCase());
    const expectedArray = table.raw().map((el) => {
      return el[0].toLowerCase();
    });
    this.expect(actualFixedArray).to.deep.equal(expectedArray);
  });

  Then(/^'(\d+)'(?:st|th|nd|rd|) section header should be '(.+)'$/, async function(sectionNumber, expectedText) {
    sectionNumber = sectionNumber - 1;
    const actualText = await this.basePage.helpModal.getSection(sectionNumber).getHeader();
    this.expect(actualText.toLowerCase()).to.equal(expectedText.toLowerCase());
  });

  Then(/^dialogue header should be '(.+)'$/, async function(expectedText) {
    const actualText = await this.basePage.helpModal.getHeader();
    this.expect(actualText.toLowerCase()).to.equal(expectedText.toLowerCase());
  });

  Then(/^help dialogue (?:'(.+)'|) ?should be (visible|invisible)$/, async function(elementName, visibility) {
    const expectedState = visibility === 'visible';
    let actualState: boolean;
    if (elementName) {
      actualState = await this.basePage.helpModal.isElementVisible(elementName);
    } else {
      actualState = await this.basePage.helpModal.isVisible();
    }
    this.expect(actualState).to.equal(expectedState);
  });

});
