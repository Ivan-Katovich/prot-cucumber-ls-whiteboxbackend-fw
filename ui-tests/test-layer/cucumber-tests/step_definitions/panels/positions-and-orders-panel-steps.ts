import { defineSupportCode } from 'cucumber';
import { browser } from 'protractor';


defineSupportCode(function({Given, When, Then}) {

  When(/^I (?:select|am on the) '([Hh]istory|[Cc]urrent|[Pp]ositions|[Oo]rders|[Pp]osition [Hh]istory|[Oo]rder [Hh]istory|[Pp]rice [Aa]lerts|[Mm]ore [Hh]istory)' (view|list)$/,
    async function(itemName, type) {
    if (type === 'view') {
      await this.basePage.currentBoard.tabBody.currentPanel.selectView(itemName);
    } else {
      await this.basePage.currentBoard.tabBody.currentPanel.selectList(itemName);
    }
  });

  Then(/^positions and orders panel header should contain items:$/, async function(table) {
    const itemNames = table.hashes().map((el) => {
      return el.itemName;
    });
    const itemNamesFromUi = await this.basePage.currentBoard.tabBody.currentPanel.getHeaderItemNames();
    this.expect(itemNames).to.deep.equal(itemNamesFromUi);
  });

  Then(/^'(.+)' item should be (active|not active)$/, async function(itemName, cond) {
    const condition = cond === 'active';
    const is = await this.basePage.currentBoard.tabBody.currentPanel.isItemActive(itemName);
    this.expect(condition).to.equal(is);
  });

  Then(/^'(.+)' list should be (visible|not visible)$/, async function(listName, cond) {
    const condition = cond === 'visible';
    const is = await this.basePage.currentBoard.tabBody.currentPanel.isListVisible(listName);
    this.expect(condition).to.equal(is);
  });

  Then(/^'(.+)' market should be predefined with '(.+)'$/, async function(name, expectedValue) {
    const actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getInputValue(name);
    this.expect(actualValue).to.equal(expectedValue);
  });

  Then(/^'(.+)' panel table header should contain:$/, async function(name, table) {
    const columnNames = table.hashes().map((el) => {
      return el.columnName.toLowerCase();
    });
    const columnNamesFromUi = (await this.basePage.currentBoard.tabBody.currentPanel.currentList.getColumnsName())
      .map(n => n.toLowerCase());

    this.expect(columnNamesFromUi).to.deep.equal(columnNames);
  });

  // tslint:disable-next-line:max-line-length
  Then(/^([Pp]osition [Hh]istory|[Oo]rder [Hh]istory) '(\d)'(?:st|th|nd|rd) table row with cell '(.+)' should contain correct '(.+)' data$/,
    async function(typeHistory, rowNumber, cellName, memoryName) {
    let marketCellValue = await this.basePage.currentBoard.tabBody.currentPanel.currentList
      .getMarket(parseInt(rowNumber) - 1).getText(cellName);
    let expectedValue: any;
    switch (cellName.toLowerCase()) {
      case 'date':
      case 'last-edit':
        // browser's local timezone
        expectedValue = this.momentTimezone(this.memory.history[memoryName]).format('DD/MM/YYYY hh:mm:ss A');
        break;
      case 'price':
      case 'realised profit/loss':
        marketCellValue = parseFloat(marketCellValue.replace(/\,/g, '')) ? parseFloat(marketCellValue.replace(/\,/g, '')) : null;
        expectedValue = this.memory.history[memoryName];
        break;
      case 'quantity':
        marketCellValue = parseFloat(marketCellValue.toLowerCase().match(/\d+,?\d*?.?\d*/)[0].replace(',', '')) ?
          parseFloat(marketCellValue.toLowerCase().match(/\d+,?\d*?.?\d*/)[0].replace(',', '')) : null;
        expectedValue = this.memory.history[memoryName];
        break;
      case 'type':
        expectedValue = this.orderApplicabilityEnum[this.memory.history[memoryName]];
        break;
      case 'status':
        expectedValue = this.orderStatusEnum[this.memory.history[memoryName]];
        break;
      default:
        expectedValue = this.memory.history[memoryName];
    }
    if (cellName === 'price') {
      const validError = Math.abs(expectedValue) * 0.01; // 1%
      this.expect(marketCellValue).to.be.within(expectedValue - validError, expectedValue + validError);
    } else {
      this.expect(marketCellValue).to.equal(expectedValue);
    }
  });
});
