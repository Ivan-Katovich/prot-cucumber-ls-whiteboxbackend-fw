import { defineSupportCode } from 'cucumber';
import { browser, element, by } from 'protractor';


defineSupportCode(function({Given, When, Then}) {

  When(/^I wait for '(\d+)'$/, async function(milliseconds) {
    await this.helper.sleep(milliseconds);
  });

  When(/^I fail the test$/, async function() {
    this.expect(false).to.equal(true);
  });

  When(/^I write in console '(.+)'$/, async function(text) {
    console.log(text);
  });

  When(/^I navigate back to previous page$/, async function() {
    await browser.navigate().back();
    // await this.basePage.waitLoading();
  });

  When(/^I refresh current page$/, async function() {
    await browser.refresh();
    // await this.basePage.waitLoading();
  });

  When(/^I take a screenshot with name '(.+)'$/, async function(name) {
    await this.helper.createScreenshot(name);
  });

  When(/^I resize window with:$/, async function(table) {
    const height = table.rowsHash().height * 1;
    const width = table.rowsHash().width * 1;
    this.memory.temporaryWindowSize = {
      width: width,
      height: height
    };
    if (process.env.npm_config_browser === 'safari' && width === 1680 && height === 1050) {
      await browser.driver.manage().window().maximize();
      await browser.driver.manage().window().setSize(width, height);
    } else {
      await browser.driver.manage().window().setSize(width, height);
    }
  });

  When(/^I switch (on|off) test execution in '(.+)'$/, async function(state, browserName) {
    this.memory[`${browserName}SwitchedOff`] = state === 'off'; // example, safariSwitchedOff
  });

  When(/^I clean memory object$/, async function() {
    this.memory = {};
  });
});
