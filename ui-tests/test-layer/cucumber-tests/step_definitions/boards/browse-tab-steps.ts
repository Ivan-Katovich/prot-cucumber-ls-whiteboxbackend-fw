/* tslint:disable:max-line-length */
import * as _ from 'lodash';
import { defineSupportCode } from 'cucumber';
import { browser } from 'protractor';
import { Dropdown } from '../../../../support/objects/elements/dropdown';


defineSupportCode(function({ Given, When, Then }) {
  When(/^I select '(.+)' market category$/, async function(categoryName) {
    this.memory.category = categoryName;
    await this.basePage.currentBoard.tabBody.browse.tags.selectMarketCategoryByName(categoryName);
  });

  When(/^I select '(.+)' filter tab$/, async function(filterName) {
    await this.basePage.currentBoard.tabBody.browse.filterTabs.selectTabByName(filterName);
  });

  When(/^'(.+)' markets category (has|has no) children$/, async function(category, status) {
    const categories = await this.backendHelper.getTagLookup();
    const children = this.basePage.currentBoard.tabBody.browse.filterTabs.getMarketSubtags(categories, category);

    status === 'has'
      ? this.expect(children.length).to.be.at.least(1)
      : this.expect(children.length).to.equal(0);
  });

  When(/^I wait for browse page markets loading$/, async function() {
    await this.basePage.currentBoard.tabBody.browse.marketTable.waitForLoading();
  });

  When(/^I fill browse page search text field with value '(.+)'$/, async function(value) {
    await this.basePage.currentBoard.tabBody.browse.marketTable.fillInputWithValue(value);
  });

  When(/^I click '(.+)' in (browse page search|markets filter tab|more dropdown|product types dropdown)$/, async function(elementName, elementLocation) {
    if (elementLocation === 'browse page search') {
      await this.basePage.currentBoard.tabBody.browse.marketTable.clickSearchElement(elementName);

      if (elementName === 'search input'
        && await this.basePage.currentBoard.tabBody.browse.marketTable.getSearchText('placeholder') !== 'Type two or more characters') {
        console.log('refresh');
        await browser.refresh();
        // await this.basePage.currentBoard.tabBody.browse.marketTable.waitForLoading();
        await this.basePage.currentBoard.tabBody.browse.marketTable.clickSearchElement(elementName);
      }

    } else if (elementName === 'include options toggle') {
      const targetState = this.memory.includeOptions ? 'off' : 'on';
      await this.basePage.dropdown.setIncludeOptions(targetState);
    } else {
      await this.basePage.currentBoard.tabBody.browse.clickElement(elementName);
    }
  });

  When(/^I select '(.+)' (?:market filter|subtag) from more dropdown$/, async function(filterName) {
    this.memory.selectedFilter = filterName;
    const visibleFilters = await this.basePage.currentBoard.tabBody.browse.getSubcategories();
    this.memory.lastVisibleFilter = visibleFilters[visibleFilters.length - 1].trim();
    if (await this.basePage.currentBoard.tabBody.browse.filterTabs.isMoreDropdownHidden()) {
      await this.basePage.currentBoard.tabBody.browse.filterTabs.expandFiltersDropdown();
    }
    await this.basePage.dropdown.select(filterName, true);
  });

  When(/^I clear browse search text$/, async function() {
    await this.basePage.currentBoard.tabBody.browse.marketTable.clearSearchInput();
  });

  When(/^I (expand|collapse) product type dropdown$/, async function(action) {
    await this.basePage.currentBoard.tabBody.browse.productType[`${action}Dropdown`]();
  });

  When(/^I store subcategories location$/, async function() {
    this.memory.subcategoriesLocation = await this.basePage.currentBoard.tabBody.browse.filterTabs.getLocation('filterTab');
  });

  Then(/^subcategories dont blink$/, async function() {
    const expectedX = this.memory.subcategoriesLocation.x;
    const expectedY = this.memory.subcategoriesLocation.y;
    const actualLocation = await this.basePage.currentBoard.tabBody.browse.filterTabs.getLocation('filterTab');
    const actualX = actualLocation.x;
    const actualY = actualLocation.y;

    // 1% due workaround for cross browser support
    this.expect(actualX).to.be.within(expectedX * 0.99, expectedX * 1.01);
    this.expect(actualY).to.be.within(expectedY * 0.99, expectedY * 1.01);
  });

  Then(/^all markets categories are displayed and ordered by weighting$/, async function() {
    let currentCategories = await this.basePage.currentBoard.tabBody.browse.tags.getCategories();

    if (process.env.npm_config_browser === 'safari') {
      currentCategories = currentCategories[0].replace(/\s{2,}/g, '  ').split('  ');
    }

    const categories = await this.backendHelper.getTagLookup();
    const expectedCategories = await this.basePage.currentBoard.tabBody.browse.sortByWeighting(categories);

    this.expect(currentCategories).to.deep.equal(expectedCategories);
  });

  Then(/^'(.+)' (is|is not) present$/, async function(elementName, status) {
    const actualStatus = await this.basePage.currentBoard.tabBody.browse.isElementPresent(elementName);
    const state = status === 'is';
    if ((elementName === 'markets filter dropdown' || elementName === 'dropdown content') && state) {
      this.memory.partialDisplayedSubcategories = await this.basePage.currentBoard.tabBody.browse.getSubcategories();
    } else {
      this.memory.displayedSubcategories = (await this.basePage.currentBoard.tabBody.browse.getSubcategories())
        .map(category => category.trim());
    }
    this.expect(actualStatus).to.equal(state);
  });

  Then(/^(not | )all markets subcategories are displayed in markets filter tabs$/, async function(status) {
    const actualStatus = _.isEqual(this.memory.displayedSubcategories, this.memory.partialDisplayedSubcategories);
    const state = !status.includes('not');
    this.expect(actualStatus).to.equal(state);
  });

  Then(/^not displayed markets subcategories are present in expanded more dropdown$/, async function() {
    const difSubcategories = this.memory.displayedSubcategories.slice(this.memory.partialDisplayedSubcategories.length);
    this.memory.subcategoriesInsideMoreDropdown = difSubcategories;
    const actualSubcategoriesInsideDropdown = await this.basePage.currentBoard.tabBody.browse.getSubcategories('inside more dropdown');
    const actualStatus = _.isEqual(difSubcategories, actualSubcategoriesInsideDropdown);
    this.expect(actualStatus).to.equal(true);
  });

  Then(/^subcategories are placed below Market tab name$/, async function() {
    const subcategoriesLocation = (await this.basePage.currentBoard.tabBody.browse.filterTabs.getLocation('filterTab')).y;
    const marketTabNameLocation = (await this.basePage.currentBoard.tabBody.browse.filterTabs.getLocation('tag name')).y;

    this.expect(subcategoriesLocation).to.be.above(marketTabNameLocation);
  });


  Then(/^'(.+)' (filters panel|more dropdown) contains correct tabs ordered by weighting$/, async function(category, tagsSet) {
    const categories = await this.backendHelper.getTagLookup();
    let expectedTabs = await this.basePage.currentBoard.tabBody.browse.filterTabs.getMarketSubtags(categories, category);
    expectedTabs = await this.basePage.currentBoard.tabBody.browse.sortByWeighting(expectedTabs);

    let actualTabs = await this.basePage.currentBoard.tabBody.browse.filterTabs.getMarketTabs();

    let links;

    const present = await this.basePage.currentBoard.tabBody.browse.filterTabs.isMoreDropdownPresent();
    if ( present ) {
      if (await this.basePage.currentBoard.tabBody.browse.filterTabs.isMoreDropdownHidden()) {
        await this.basePage.currentBoard.tabBody.browse.filterTabs.expandFiltersDropdown();
      }

      links = await this.basePage.dropdown.getOptions();
      actualTabs.splice(-1);
      // .filter(t => t) is removing empty elements from array
      actualTabs = actualTabs.filter(t => t).map(t => t.toUpperCase());
      actualTabs = actualTabs.concat(links.map(c => c.toUpperCase()).filter(t => actualTabs.indexOf(t) === -1));
    }

    if (tagsSet === 'more dropdown') {
      actualTabs = links.map(c => c.toUpperCase());
      expectedTabs = expectedTabs.filter(tabs => true === links.some( b => tabs === b));
    }
    this.memory.leftmostTab = expectedTabs[0];
    this.expect(actualTabs.map(c => c.toUpperCase())).to.deep.equal(expectedTabs.map(c => c.toUpperCase()));
  });

  Then(/^Market tab name should be '(.+)'$/, async function(expectedName) {
    const actualName = await this.basePage.currentBoard.tabBody.browse.filterTabs.getText('tag name');

    this.expect(actualName.toLowerCase()).to.equal(expectedName.toLowerCase());
  });

  Then(/^'(.+)' markets (filter tab|category) should be active$/, async function(filterName, elementName) {
    if (filterName === 'leftmost') {
      filterName = this.memory.leftmostTab;
    }
    const status = await this.basePage.currentBoard.tabBody.browse.isElementActive(elementName, filterName);
    elementName === 'category' ? this.memory.category = filterName : this.memory.subcategory = filterName;
    this.expect(status).to.equal(true);
  });

  Then(/^1-click '(.+)' for all present on browse tab markets should be displayed according to market status$/,
  async function(field) {
    field = `1-click ${field.toLowerCase()}`;
    const marketsIds = await this.basePage.currentBoard.tabBody.browse.marketTable.getSearchModal().getAllMarketsIds();
    for (let i = 0; i < marketsIds.length; i++) {
      let status;
      if (this.memory[`${marketsIds[i]}Status`]) {
        status = this.memory[`${marketsIds[i]}Status`];
      } else {
        await this.lightstreamer.subscribe(marketsIds[i]);
        status = await this.lightstreamer.addListener('StatusSummary');
        this.memory[`${marketsIds[i]}Status`] = status;
      }

      const market = await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(i);
      const actualState = await market.isElementVisible(field);
      // status === '4' for closed markets
      if (status === '4') {
        this.expect(actualState).to.equal(false);
      } else if (status === '0') {
        this.expect(actualState).to.equal(true);
      }
    }
  });

  Then(/^'(.+)' (filter tab|category) search list contains correct markets ordered by weighting$/, async function(filterName, elementName) {
    if (filterName === 'leftmost') {
      filterName = this.memory.leftmostTab;
    }

    const categories = await this.backendHelper.getTagLookup();
    let tagId;
    let expectedMarketsList;
    let actualMarketsList;

    if (elementName === 'category') {
      tagId = await this.basePage.currentBoard.tabBody.browse.getMarketTagId(categories, filterName);
    } else if (elementName === 'filter tab') {
      const children = await this.basePage.currentBoard.tabBody.browse.filterTabs.getMarketSubtags(categories, this.memory.category);
      tagId = await this.basePage.currentBoard.tabBody.browse.getMarketTagId(children, filterName);
    }
    expectedMarketsList = await this.backendHelper.getMarketsInformation(tagId, 150, this.memory.includeOptions);
    const group = await this.basePage.currentBoard.tabBody.browse.groupByWeighting(expectedMarketsList);

    const keys = Object.keys(group);
    const sortedGroup = [];
    for (let i = keys.length - 1; i >= 0; i--) {
      const b = await this.basePage.currentBoard.tabBody.browse.sortByName(group[keys[i]]);
      sortedGroup.push(b);
    }

    expectedMarketsList = sortedGroup.reduce(
      (accumulator, currentValue) => {
        return accumulator.concat(currentValue);
      },
      []
    );
    expectedMarketsList = expectedMarketsList.map(a => a.trim());

    // await this.basePage.currentBoard.tabBody.browse.marketTable.marketsTableWait();
    actualMarketsList = await this.basePage.currentBoard.tabBody.browse.marketTable.getSearchModal().getAllMarketsTitles();
    actualMarketsList = actualMarketsList.map(a => a.toLowerCase());
    actualMarketsList.forEach((actualMarket) => this.expect(expectedMarketsList).to.include(actualMarket));
  });

  Then(/^'(.+)' markets filter tab should be displayed on '(.+)'(?:st|th|nd|rd|) position$/, async function(filterName, positionNumber) {
    if (filterName === 'current') {
      filterName = this.memory.selectedFilter;
    }
    if (positionNumber === 'last') {
      positionNumber = (await this.basePage.currentBoard.tabBody.browse.getSubcategories()).length;
    }
    const actualFilterName = await this.basePage.currentBoard.tabBody.browse.getNameFilter(parseInt(positionNumber) - 1);
    this.expect(actualFilterName.toUpperCase()).to.equal(filterName.toUpperCase());
  });

  Then(/^markets filter dropdown contains previously the last visible market filter tab$/, async function() {
    if (await this.basePage.currentBoard.tabBody.browse.filterTabs.isMoreDropdownHidden()) {
      await this.basePage.currentBoard.tabBody.browse.filterTabs.expandFiltersDropdown();
    }
    const actualDropdownFilters = await this.basePage.currentBoard.tabBody.browse.getSubcategories('inside more dropdown');
    this.expect(actualDropdownFilters).to.include(this.memory.lastVisibleFilter);
  });

  Then(/^the browse page '(.+)' section should contain items:$/, async function(section, table) {
    const itemNames = table.hashes().map((el) => {
      return el.itemName;
    });
    let actualState;
    for (let i = 0; i < itemNames.length; i++) {
      if (section === 'markets') {
        actualState = await this.basePage.currentBoard.tabBody.browse.tags.isElementVisible(itemNames[i]);
      } else if (section === 'filter tabs') {
        actualState = await this.basePage.currentBoard.tabBody.browse.filterTabs.isElementVisible(itemNames[i]);
      } else if (section === 'product type dropdown') {
        actualState = await this.basePage.currentBoard.tabBody.browse.productType.isElementVisible(itemNames[i]);
      } else {
        actualState = await this.basePage.currentBoard.tabBody.browse.marketTable.isElementVisible(itemNames[i]);
      }

      this.expect(actualState).to.equal(true);
    }
  });

  Then(/^browse page search text input '(placeholder|value)' should be '(.+)'$/, async function(textType, expectedText) {
    const actualText = await this.basePage.currentBoard.tabBody.browse.marketTable.getSearchText(textType);
    this.expect(actualText).to.equal(expectedText.trim());
  });

  Then(/^'(.+)' (filter tab|category) '(.+)' query returns correct markets ordered by weighting$/,
    async function(filterName, elementName, query) {
    const categories = await this.backendHelper.getTagLookup();
    let actualMarketsList;
    let tagId;
    let expectedMarketsList;

    if (elementName === 'category') {
      tagId = await this.basePage.currentBoard.tabBody.browse.getMarketTagId(categories, filterName);
    } else if (elementName === 'filter tab') {
      const children = await this.basePage.currentBoard.tabBody.browse.filterTabs.getMarketSubtags(categories, this.memory.category);
      tagId = await this.basePage.currentBoard.tabBody.browse.getMarketTagId(children, filterName);
    }
    expectedMarketsList = await this.backendHelper.getMarketsNamesByQuery(tagId, 150, query, true, true, false);
    const group = await this.basePage.currentBoard.tabBody.browse.groupByWeighting(expectedMarketsList);
    const keys = Object.keys(group);
    const sortedGroup = [];
    for (let i = keys.length - 1; i >= 0; i--) {
      const b = await this.basePage.currentBoard.tabBody.browse.sortByName(group[keys[i]]);
      sortedGroup.push(b);
    }

    expectedMarketsList = sortedGroup.reduce(
      (accumulator, currentValue) => {
        return accumulator.concat(currentValue);
      },
      []
    );

    // await this.basePage.currentBoard.tabBody.browse.marketTable.marketsTableWait();
    actualMarketsList = await this.basePage.currentBoard.tabBody.browse.marketTable.getSearchModal().getAllMarketsTitles();
    actualMarketsList = actualMarketsList.map(a => a.toLowerCase());

    actualMarketsList.forEach((actualMarket) => this.expect(expectedMarketsList).to.include(actualMarket));
  });

  Then(/^browse page '(.+)' market '(.+)' '(should|should not)' update according to market status$/, async function(marketName, type, state) {
    this.lightstreamer.subscribe(this.idMatcher.market[marketName]);
    const status = await this.lightstreamer.addListener('StatusSummary');

    const timeWait = status === '4' ? 30000 : 60000;

    if (!process.env.npm_config_browser.includes('firefox')) {
      await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(marketName).scrollTo();
    }

    const market = await this.basePage.currentBoard.tabBody.browse.marketTable.getMarket(marketName);
    const data = await market.getPrice(type);

    const actualState = await browser.wait(() => {
      return market.getPrice(type)
        .then((text) => this.helper.sleepIfFalse(text !== data, 1000));
    }, timeWait)
      .then(() => true, () => false);

    let expectedState;
    if (state === 'should') {
      expectedState = (status === '0') && (actualState);
    } else {
      expectedState = false;
    }
    this.expect(actualState).to.equal(expectedState);
  });

  //
  // TODO: product types filter
  //

  Then(/^'(.+)' product type filter is selected$/, async function(productType) {
    const actualType = await this.basePage.currentBoard.tabBody.browse.productType.getProductType();
    this.expect(actualType.toLowerCase()).to.equal(productType.toLowerCase());
  });

  Then(/^'(.+)' product type filter for '(.+)' (filter tab|category) returns correct markets ordered by weighting$/,
    async function(type, filterName, elementName) {
    const categories = await this.backendHelper.getTagLookup();
    let actualMarketsList;
    let tagId;
    let expectedMarketsList;

    if (elementName === 'category') {
      tagId = await this.basePage.currentBoard.tabBody.browse.getMarketTagId(categories, filterName);
    } else if (elementName === 'filter tab') {
      const children = await this.basePage.currentBoard.tabBody.browse.filterTabs.getMarketSubtags(categories, this.memory.category);
      tagId = await this.basePage.currentBoard.tabBody.browse.getMarketTagId(children, filterName);
    }
    if (!this.memory.includeOptions) {
      this.memory.includeOptions = false;
    }

    const spreads = type === 'Spreads' || type === 'All';
    const cfds = type === 'CFDs' || type === 'All';

    expectedMarketsList = await this.backendHelper.getMarketsNamesByQuery(tagId, 150, '', spreads, cfds, this.memory.includeOptions);
    const group = await this.basePage.currentBoard.tabBody.browse.groupByWeighting(expectedMarketsList);
    const keys = Object.keys(group);
    const sortedGroup = [];
    for (let i = keys.length - 1; i >= 0; i--) {
      const b = await this.basePage.currentBoard.tabBody.browse.sortByName(group[keys[i]]);
      sortedGroup.push(b);
    }

    expectedMarketsList = sortedGroup.reduce(
      (accumulator, currentValue) => {
        return accumulator.concat(currentValue);
      },
      []
    );

    // await this.basePage.currentBoard.tabBody.browse.marketTable.marketsTableWait();
    actualMarketsList = await this.basePage.currentBoard.tabBody.browse.marketTable.getSearchModal().getAllMarketsTitles();
    actualMarketsList = actualMarketsList.map(a => a.toLowerCase());

    actualMarketsList.forEach((actualMarket) => this.expect(expectedMarketsList).to.include(actualMarket));
  });

  Then(/^options included toggle is (on|off)$/, async function(state) {
    if (!(await new Dropdown().isVisible())) {
      await this.basePage.currentBoard.tabBody.browse.productType.expandDropdown();
    }
    const actualState = await this.basePage.dropdown.isOptionsIncluded();
    const expectedState = state === 'on';
    this.memory.includeOptions = state === 'on';
    this.expect(actualState).to.equal(expectedState);
  });
});
