/* tslint:disable:max-line-length */
import { defineSupportCode } from 'cucumber';
import * as _ from 'lodash';

defineSupportCode(function({ Given, When, Then }) {
  When(/^I click on the value of '(.+)'(?:st|th|nd|rd|) row$/, async function(rowNameOrNumber) {
    if (parseInt(rowNameOrNumber)) {
      rowNameOrNumber = rowNameOrNumber - 1;
    }

    await this.basePage.currentBoard.tabBody.currentPanel.getRow(rowNameOrNumber).clickOnValue();
  });

  Then(/^market name should be '(.+)'$/, async function(expectedName) {
    if (expectedName === 'correct') {
      expectedName = this.memory.marketName;
    }

    const actualName = await this.basePage.currentBoard.tabBody.currentPanel.getMarketName();

    this.expect(actualName).to.equal(expectedName);
  });

  Then(/^'(.+)'(?:st|th|nd|rd|) (row|history row) should contain '(.*)' (?:word|data)$/, async function(rowNameOrNumber, rowType, expectedValue) {
    if (parseInt(rowNameOrNumber)) {
      rowNameOrNumber = rowNameOrNumber - 1;
    }
    if (expectedValue === 'correct') {
      if (rowNameOrNumber === 'Margin Requirement') {
        this.lightstreamer.subscribeMargin();
        // const margin = await this.lightstreamer.addMarginListener('MarginRequirementConverted');
        const margin = await this.lightstreamer.addMarginListener('4');
        expectedValue = margin !== 0 ? parseFloat(margin) : '';
      } else if (rowNameOrNumber === 'Opening Price') {
        expectedValue = parseFloat(this.memory.prices[this.memory.direction]);
      }
    }
    let actualValue: string;
    if (rowType === 'history row') {
      actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getRow(rowNameOrNumber).getHistoryValue();
    } else {
      actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getRow(rowNameOrNumber).getValue();
    }

    if (typeof(expectedValue) === 'number') {
      const validError = Math.abs(expectedValue) * 0.01; // 1%
      console.log(`${actualValue} should be within ${_.round(expectedValue - validError, 2)} - ${_.round(expectedValue + validError, 2)}`);
      this.expect(parseFloat(actualValue)).to.be.within(_.round(expectedValue - validError, 2), _.round(expectedValue + validError, 2));
    } else {
      this.expect(actualValue).to.equal(expectedValue);
    }
  });

  Then(/^'(Date changed|Date opened)' row should contain correct date$/, async function(dateType) {
    const isPosition = dateType === 'Date opened';
    const actualDate = await this.basePage.currentBoard.tabBody.currentPanel.getRow(dateType).getValue();
    const dateFromBackend = await this.backendHelper.getBackendMultiDataByName(this.memory.marketName, 'LastChangedDateTimeUTC', isPosition);
    // from wt-603 - '...Date opened (time is presented in browser's local time)'
    // time format for POSITION DETAILS is not 24H
    let expectedDate;
    if (isPosition) {
      expectedDate = this.momentTimezone(dateFromBackend[0]).format('DD/MM/YYYY HH:mm:ss'); // 13/12/2018 16:50:00
    } else {
      expectedDate = this.momentTimezone(dateFromBackend[0]).format('DD/MM/YYYY hh:mm:ss A');
    }
    this.expect(actualDate).to.equal(expectedDate);
  });

  Then(/^(Expiry|) row should be set$/, async function(dateType) {
    const actualDate = await this.basePage.currentBoard.tabBody.currentPanel.getRow(dateType).getValue();
    const expectedPattern = /\d{1,2}\/\d{1,2}\/\d{4}\s\d{2}:\d{2}:\d{2}\s?(PM|AM|)/;
    this.expect(actualDate).to.match(expectedPattern);
  });

  Then(/^'Order ID' row should contain correct ID(?: for (trade|stop\/limit)|)$/, async function(orderType) {
    const isPosition = orderType === 'trade';
    let actualID = await this.basePage.currentBoard.tabBody.currentPanel.getRow('Order ID').getValue();
    actualID = parseInt(actualID);
    const idFromBackend = await this.backendHelper.getBackendMultiDataByName(this.memory.marketName, 'OrderId', isPosition);
    const expectedID = idFromBackend[0];

    this.expect(actualID).to.equal(expectedID);
  });

  Then(/^'(.+)' row should contain correct '(.+)' data form history$/, async function(rowName, dataType) {
    let actualValue = await this.basePage.currentBoard.tabBody.currentPanel.getRow(rowName).getHistoryValue();

    let expectedValue = this.memory.history[dataType];
    if (dataType === 'ExecutedDateTimeUtc') {
      // time in browser's local
      expectedValue = this.momentTimezone(expectedValue).format('DD/MM/YYYY hh:mm:ss A');
    }
    if (dataType === 'OrderId' || dataType === 'TriggerPrice') {
      actualValue = parseInt(actualValue);
    }

    this.expect(actualValue).to.equal(expectedValue);
  });
});
