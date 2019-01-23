import { defineSupportCode } from 'cucumber';
import { browser, element, by, ExpectedConditions } from 'protractor';


defineSupportCode(function({Given, When, Then}) {

  When(/^I click on '(.+)' in the guide bubble$/, async function(elementName) {
    await this.basePage.guideBubble.clickElement(elementName);
  });

  Then(/^guide bubble (?:'(.+)'|) ?should be (visible|invisible)$/, async function(elementName, visibility) {
    const expectedState = visibility === 'visible';
    let actualState: boolean;
    if (elementName) {
      actualState = await this.basePage.guideBubble.isElementVisible(elementName);
    } else {
      actualState = await this.basePage.guideBubble.isVisible();
    }
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^guide bubble '(.+)' text should be '(.+)'$/, async function(elementName, expectedText) {
    const actualText = await this.basePage.guideBubble.getElementText(elementName);
    this.expect(actualText.toLowerCase()).to.equal(expectedText.toLowerCase());
  });

  Then(/^other elements should be inactive$/, async function() {
    let isClickable = false;
    try {
      await this.basePage.header.click('help button');
      isClickable = true;
    } catch (err) {
      if (process.env.npm_config_browser.includes('firefox')) {
        this.expect(err.message).to.include('is not clickable at point');
      } else if (process.env.npm_config_browser.includes('safari')) {
        this.expect(err.message).to.include('An unknown server-side error occurred while processing the command');
      } else if (process.env.npm_config_browser.includes('edge')) {
        this.expect(err.message).to.include('Element is obscured');
      } else {
        this.expect(err.message).to.include('Other element would receive the click');
      }
    }
    this.expect(false).to.equal(isClickable);
  });

});
