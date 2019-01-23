import { defineSupportCode } from 'cucumber';
import { backendHelper } from '../../../support/utils/backend-helper';
import { results } from '../../results';


defineSupportCode(function({ AfterAll }) {

  AfterAll(async function() {
    const message = results.failed === 0 ? `All scenario passed` : `${results.failed} scenario failed`;
    console.log(`
****************************************************************
App version: 
${message}
Execution time: ${results.time}
****************************************************************`);
    await backendHelper.deleteSession();
  });

});
