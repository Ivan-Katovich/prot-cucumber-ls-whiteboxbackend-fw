/* tslint:disable:max-line-length */

import { defineSupportCode } from 'cucumber';
import { browser, element, by } from 'protractor';


defineSupportCode(function({ Given, When, Then }) {

  When(/^I select '(.+)' from expanded dropdown$/, async function(optionNameOrNumber) {
    if (parseInt(optionNameOrNumber)) {
      optionNameOrNumber = optionNameOrNumber - 1;
    }
    await this.basePage.dropdown.select(optionNameOrNumber, true);
  });

  When(/^I click on '(.+)' in date\/time picker '(.+)' time(?:s|)( and click outside)?$/,
  async function(elementName, count, clickOutside) {
    count = parseInt(count);
    for (let i = 0; i < count; i++) {
      await this.basePage.dateTimePicker.click(elementName);
    }

    if (clickOutside) {
      await this.basePage.header.clickLogo();
    }
  });

  When(/^I add to date\/time picker '([+-]?\d+)' (year|hour|minute)s?( and click outside)?$/, async function(unitNumber, unitType, clickOutside) {
    unitNumber = parseInt(unitNumber);
    await this.basePage.dateTimePicker.add(unitNumber, unitType);
    if (clickOutside) {
      await this.basePage.header.clickLogo();
    }
  });

  When(/^I click on '(.+)' watchlist$/, async function(watchlistName) {
    await this.basePage.actionsMenu.clickItem(watchlistName);
  });

  When(/^I add new '(.+)' watchlist( from menu panel|)$/, async function(watchlistName, location) {
    await this.basePage.actionsMenu.addNewItem(watchlistName, location);
  });

  Then(/^'(.+)' (should|should not) be visible inside date\/time picker$/, async function(elementName, expectedState) {
    expectedState = expectedState === 'should';
    let actualState;

    if (elementName.match(/current day(\+|-)\d+?\.?\d*/)) {
      const multiplier = parseFloat(elementName.split(/(\+|-)/)[2]);
      const operation = elementName.split(/(\+|-)/)[1];
      const today = parseInt(this.moment().format('x'));
      const days = 86400000 * multiplier;
      elementName = new Function('', `return ${today} ${operation} ${days};`)();
      elementName = this.momentTimezone(elementName).format('LL'); // December 17, 2018
      actualState = await this.basePage.dateTimePicker.isDateElementDisplayed(elementName);
    } else {
      actualState = await this.basePage.dateTimePicker.isElementDisplayed(elementName);
    }
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^the options from expanded dropdown should be:$/, async function(table) {
    if (!this.memory[`${process.env.npm_config_browser.replace('Headless', '')}SwitchedOff`]) {
      let actualArray = await this.basePage.dropdown.getOptions();
      actualArray = actualArray.map((text) => {
        text = text.replace(/ *\n */g, ' ');
        let matchRes = text.match(/[a-z]{1}[A-Z]/);
        while (matchRes) {
          text = [
            text.slice(0, matchRes.index + 1),
            text.slice(matchRes.index + 1)
          ].join(' ');
          matchRes = text.match(/[a-z]{1}[A-Z]/);
        }
        if (text.includes('Guaranteed')) {
          text = text.match(/Guaranteed( stop)?/)[0];
          // guaranteed tooltip message is erased, it's checked in 'guaranteed tooltip message should be correct for the current market' step
        }

        return text;
      });
      const expectedArray = table.raw().map(el => el[0]);
      this.expect(actualArray.map(i => i.toLowerCase())).to.deep.equal(expectedArray.map(i => i.toLowerCase()));
    }
  });

  Then(/^dropdown should be opened (upwards|downwards) the '(.+)'(?:st|th|nd|rd|) market$/, async function(expectedState, marketNameOrNumber) {
    if (parseInt(marketNameOrNumber)) {
      marketNameOrNumber = marketNameOrNumber - 1;
    }
    const marketLocation = (await this.basePage.currentBoard.tabBody.currentPanel.currentList.getMarket(marketNameOrNumber).getLocation('name')).y;
    const dropdownLocation = (await this.basePage.dropdown.getDropdownLocation()).y;

    if (expectedState === 'upwards') {
      this.expect(dropdownLocation).to.be.below(marketLocation);
    } else {
      this.expect(dropdownLocation).to.be.above(marketLocation);
    }
  });

  Then(/^guaranteed tooltip message should be correct for the current market$/, async function() {
    let expectedMessage;
    const marketId = this.memory.marketId;
    const marketInfo = await this.backendHelper.getMarketInformation(parseInt(marketId));

    if (marketInfo.GuaranteedOrderPremiumUnits === 1) {
      expectedMessage = `If triggered, charge is ${marketInfo.GuaranteedOrderPremium} times the quantity`;
    } else if (marketInfo.GuaranteedOrderPremiumUnits === 2) {
      expectedMessage = `If triggered, charge is ${marketInfo.GuaranteedOrderPremium}% of consideration`;
    }
    let guaranteedOption = (await this.basePage.dropdown.getOptions()).filter((item) => item.includes('Guaranteed'))[0];
    guaranteedOption = guaranteedOption.replace(/Guaranteed (stop )?/, '');
    this.expect(guaranteedOption).to.equal(expectedMessage);
  });

  Then(/^action menu is (visible|not visible)$/, async function(visibility) {
    const expectedState = visibility === 'visible';
    const actualState = await this.basePage.actionsMenu.isVisible();
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^'(.+)' watchlist is (present|not present) in menu$/, async function(watchlistName, visibility) {
    const expectedState = visibility === 'present';
    const actualState = await this.basePage.actionsMenu.isItemPresent(watchlistName);
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^new watchlist button is (present|not present) in menu$/, async function(visibility) {
    const expectedState = visibility === 'present';
    const actualState = await this.basePage.actionsMenu.isNewItemButtonVisible();
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^confirmation icon is (visible|not visible) in '(.+)' watchlist$/, async function(visibility, watchlistName) {
    const expectedState = visibility === 'visible';
    const actualState = await this.basePage.actionsMenu.isConfirmationIconVisible(watchlistName);
    this.expect(actualState).to.equal(expectedState);
  });

  Then(/^workspace dropdown (component list|grid view) contains( used | )items in the correct order:$/,
    async function(componentName, componentsState, table) {
    const itemNames = table.raw().map((el) => {
      if (el[0] === 'Chart according market name' && componentName === 'grid view') {
        el[0] = this.memory.defaultMarketName;
      }

      return el[0];
    });

    const actualItem = await this.basePage.workspaceDropdown.getComponentsTitles(componentName, componentsState.trim());

    /*
    actualItem = actualItem.replace(/[0-9]|[,]|[.]|[-]|[>]|[%]|\ss+/g, '').split('\n').map(t => t.trim()).filter(t => t);
    if (process.env.npm_config_browser === 'safari') {
      actualItem = actualItem[0].replace(/\s{2,}/g, '  ').split('  ');
    }
    */
    for (let i = 0; i < itemNames.length; i++) {
      this.expect(actualItem[i]).to.contain(itemNames[i]);
    }
  });

  Then(/^workspace dropdown (component list|grid view) contains optional items if KVP set$/, async function(componentName) {
    const optionalItems = {
      'Autochartist Analysis': 'Autochartist_1',
      'Recognia Research': 'Recognia_1',
      'City Index Market Analysis': 'ATPro_research_link_1'
    };
    const accountInformation = await this.backendHelper.getClientAndTradingAccount();
    const translationKeys = await this.backendHelper.getClientApplicationMessageTranslationWithInterestingItems(
      0, // INFO: as in AP app
      accountInformation.CultureId,
      accountInformation.AccountOperatorId,
      [optionalItems['Autochartist Analysis'], optionalItems['Recognia Research'], optionalItems['City Index Market Analysis']]);

    function getValueByKeyFromArray(array, key) {
      return array.filter((elem) => elem.Key === key)[0].Value;
    }

    const actualItems = await this.basePage.workspaceDropdown.getComponentsTitles(componentName);

    for (let i = 0; i < Object.keys(optionalItems).length; i++) {
      const actualStateForItem = actualItems.includes(Object.keys(optionalItems)[i]);
      const expectedStateForItem = getValueByKeyFromArray(translationKeys, optionalItems[Object.keys(optionalItems)[i]]);
      this.expect(actualStateForItem).to.equal(Boolean(expectedStateForItem));
    }
  });

  Then(/^workspace dropdown '(.+)' element should contain text '(.+)'$/, async function(elementName, expectedText) {
    let actualText = await this.basePage.workspaceDropdown.getText(elementName);
    if (process.env.npm_config_browser === 'edge' || process.env.npm_config_browser === 'safari') {
      actualText = actualText.toLowerCase();
      expectedText = expectedText.toLowerCase();
    }
    this.expect(actualText).to.equal(expectedText);
  });

  Then(/^'(date picker|date time picker|action menu)' dropdown should be (visible|not visible)$/, async function(dropdownType, visibility) {
    const expectedState = visibility === 'visible';
    const dropdowns = {
      'date time picker': 'dateTimePicker',
      'date picker': 'dateTimePicker',
      'action menu': 'actionMenu'
    };
    const actualState = await this.basePage[dropdowns[dropdownType]].IsVisible();
    this.expect(actualState).to.equal(expectedState);
  });
});
