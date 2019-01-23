import { defineSupportCode } from 'cucumber';
import { browser, element, by, ExpectedConditions } from 'protractor';


defineSupportCode(function({Given, When, Then}) {

  When(/^I close notification dialogue$/, async function() {
    await this.basePage.notificationModal.close();
  });

  Then(/^notification dialogue header should be '(.+)'$/, async function(expectedText) {
    const actualText = await this.basePage.notificationModal.getHeader();
    this.expect(actualText.toLowerCase()).to.equal(expectedText.toLowerCase());
  });


  Then(/^notification dialogue (?:'(.+)'|) ?should be (visible|invisible)$/, async function(elementName, visibility) {
    const expectedState = visibility === 'visible';
    let actualState: boolean;
    if (elementName) {
      actualState = await this.basePage.notificationModal.isElementVisible(elementName);
    } else {
      actualState = await this.basePage.notificationModal.isElementVisible('dialogue');
    }
    this.expect(actualState).to.equal(expectedState);
  });

});
