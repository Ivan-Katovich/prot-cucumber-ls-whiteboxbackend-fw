import { defineSupportCode } from 'cucumber';
import { browser } from 'protractor';


defineSupportCode(function({ Given, When, Then }) {
  Given(/^I am logged in to the application with default state$/, async function() {
    const url = await browser.getCurrentUrl();
    this.expect(url).to.include(browser.params.baseUrl);
    // await this.basePage.waitLoading();
  });
});
