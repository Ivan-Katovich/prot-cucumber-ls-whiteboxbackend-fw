import { userCreator } from './../../support/utils/user-creator';
import { defineSupportCode } from 'cucumber';
import { LoginPage } from '../../support/objects/pages/login-page';
import { BasePage } from '../../support/objects/pages/base-page';
import { backendHelper } from '../../support/utils/backend-helper';
import * as lightstreamer from '../../support/utils/lightstreamer-helper';
import { expect } from 'chai';
import { helper } from '../../support/utils/helper';
import * as moment from 'moment';
import * as momentTimezone from 'moment-timezone';
import { idMatcher } from '../../support/enums/market-id.enum';
import { OrderApplicabilityEnum } from '../../support/enums/order-applicability.enum';
import { OrderStatusEnum } from '../../support/enums/order-status.enum';
import * as formulas from './../../support/utils/deal-ticket-formulas';


function CustomWorld({attach, parameters}) {
  this.attach = attach;
  this.parameters = parameters;
  this.basePage = new BasePage();
  this.loginPage = new LoginPage();
  this.userCreator = userCreator;
  this.backendHelper = backendHelper;
  this.expect = expect;
  this.helper = helper;
  this.moment = moment;
  this.momentTimezone = momentTimezone;
  this.memory = {};
  this.orderApplicabilityEnum = OrderApplicabilityEnum;
  this.orderStatusEnum = OrderStatusEnum;
  this.lightstreamer = lightstreamer;
  this.idMatcher = idMatcher;
  this.formulas = formulas;
}

defineSupportCode(function({setWorldConstructor}) {
  setWorldConstructor(CustomWorld);
});
