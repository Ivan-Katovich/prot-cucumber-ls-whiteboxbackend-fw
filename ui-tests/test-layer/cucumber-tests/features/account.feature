@myaccount
Feature: My Account
  As a user
  I can open open My account page and manage settings, account details
  So all settings, account details functionality should work fine

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @handles @account-funding @wt-706-v6
  Scenario: Account funding
    #1
    When I click on 'user account' header element
    And I go to my account page
    Then Account board should be active
    Then the count of tabs should be '4'
    And 'icon container' should be visible within account tab
    And 'full username' should be visible within account tab
    And 'logged username' should be visible within account tab
    And 'email' should be visible within account tab
    # for now, details section is active
    #Then the funding section should be active
    Then the details section should be active
    And 'funding' should be visible within account tab
    And 'statements' should be visible within account tab
    And 'settings' should be visible within account tab
    And 'details' should be visible within account tab
    #2
    When I go to 'funding' section
    Then the funding section should be active
    And account funding description is correct
    And the funding section should contain items:
      | add funds link             |
      | withdraw funds link        |
      | add payment method link    |
      | remove payment method link |
    #3
    When I click 'add funds link' in account funding section
    And I switch to '2' browser tab
    Then 'add funds link' redirects to the correct url
    When I close current browser tab
    #4
    And I switch to '1' browser tab
    Then the funding section should be active
    When I click 'withdraw funds link' in account funding section
    And I switch to '2' browser tab
    Then 'withdraw funds link' redirects to the correct url
    When I close current browser tab
    #5
    And I switch to '1' browser tab
    Then the funding section should be active
    When I click 'add payment method link' in account funding section
    And I switch to '2' browser tab
    Then 'add payment method link' redirects to the correct url
    When I close current browser tab
    #6
    And I switch to '1' browser tab
    Then the funding section should be active
    When I click 'remove payment method link' in account funding section
    And I switch to '2' browser tab
    Then 'remove payment method link' redirects to the correct url
    When I close current browser tab
    And I switch to '1' browser tab
    #7 close My Account tab
    Then Account board should be active
    When I close My Account tab
    Then the count of tabs should be '3'

#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @quick @smoke @platform-settings
  Scenario: Platform settings
    When I click on 'user account' header element
    And I go to my account page
    Then Account board should be active
    When I go to 'settings' section
    Then the settings section should be active
    # will start fail soon - new requirements - https://jira.gaincapital.com/browse/TPDWT-17467
    And the settings section should contain items:
      | hedge label              |
      | hedge toggle             |
      | hedge description        |
      | session timeout label    |
      | session timeout dropdown |
      | timezone label           |
      | timezone dropdown        |
      | timezone description     |
      | date format label        |
      | date format dropdown     |
      | date format description  |
    And the hedge is off
    And '24 hours' option is selected in 'session timeout' dropdown
    And '(UTC) Dublin, Edinburgh, Lisbon, London' option is selected in 'time zone' dropdown
    And 'DD/MM/YYYY' option is selected in 'date format' dropdown
    When I switch to 'Default Workspace' workspace tab
    When I make 'watchlist' panel active
    Then 'Popular Markets' watchlist should be expanded
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    And 'hedging status' element text should be 'Hedging is OFF'
    When I click on 'advancedTicket' link
    Then 'hedge toggle' element should be disabled
    When I switch to 'My Account' workspace tab
    And I go to 'settings' section
    And I click 'toggle' in platform settings section
    Then the hedge is on
    When I switch to 'Default Workspace' workspace tab
    Then the 'Deal ticket' panel should be visible
    And 'hedging status' element text should be 'Hedging is ON'
    When I click on 'advancedTicket' link
    Then 'hedge toggle' element should be enabled
    When I relogin to the application
    And I switch to 'My Account' workspace tab
    And I go to 'settings' section
    Then the hedge is on
    When I switch to 'Default Workspace' workspace tab
    And I add new 'Watchlist' panel in '2'nd tab
    And I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    And 'hedging status' element text should be 'Hedging is ON'
    When I click on 'advancedTicket' link
    Then 'hedge toggle' element should be enabled
    When I switch to 'My Account' workspace tab
    And I go to 'settings' section
    And I click 'toggle' in platform settings section
    Then the hedge is off
    When I switch to 'Default Workspace' workspace tab
    Then the 'Deal ticket' panel should be visible
    And 'hedging status' element text should be 'Hedging is OFF'
    When I click on 'advancedTicket' link
    Then 'hedge toggle' element should be disabled
    When I switch to 'My Account' workspace tab
    And I go to 'settings' section
    Then 'session timeout' dropdown in 'platform settings' section contains correct items
    And 'time zone' dropdown in 'platform settings' section contains correct items
    And 'date format' dropdown in 'platform settings' section contains correct items
    When I select '2 hours' option from 'session timeout' dropdown in 'platform settings' section
    Then '2 hours' option is selected in 'session timeout' dropdown
    When I select '(UTC+02:00) Cairo' option from 'time zone' dropdown in 'platform settings' section
    Then '(UTC+02:00) Cairo' option is selected in 'time zone' dropdown
    And time zone description is correct
    When I select 'MM/DD/YYYY' option from 'date format' dropdown in 'platform settings' section
    Then 'MM/DD/YYYY' option is selected in 'date format' dropdown
    And 'date format' is updated
    And I wait for '1000'
    And date format description is correct
    When I select 'DD/MM/YYYY' option from 'date format' dropdown in 'platform settings' section
    Then 'DD/MM/YYYY' option is selected in 'date format' dropdown
    And 'date format' is updated
    And date format description is correct

  @quick @smoke @account-details
  Scenario: Account details
    When I click on 'user account' header element
    And I go to my account page
    Then Account board should be active
    When I go to 'details' section
    Then the details section should be active
    And the details section should contain items:
      | current email |
      | new email input |
      | re-enter email input |
      | update email button |
      | password description |
      | old password input |
      | new password input |
      | re-enter password input |
      | update now button |
    And the 'details' section route is correct
    When I add new tab
    And I close '5'th tab
    # WebTrader-708: ../account/details tab should be active
    # as it is /workspaces/default tab is active
    Then 'Default Workspace' tab should be active
    When I switch to 'My Account' workspace tab
    And Account board should be active
    Then the details section should be active
    When I enter 'text' into 'new email' text input field
    And I enter 'text' into 're-enter email' text input field
    # TODO: WebTrader-708: error msg
    # as it is
    Then 'update email button' should be disabled
    When I enter 'test@mail.com' into 'new email' text input field
    And I enter 'test2@mail.com' into 're-enter email' text input field
    # TODO: WebTrader-708: error msg
    # as it is
    Then 'update email button' should be disabled
    When I clear 'new email' text input field
    And I clear 're-enter email' text input field
    Then 'update email button' should be disabled
    When I enter 'test1@mail.com' into 'new email' text input field
    And I enter 'test1@mail.com' into 're-enter email' text input field
    Then 'update email button' should be enabled
    When I click 'update email button' in account details section
    Then 'current email' is updated
    Then 'current email' text should be fully displayed
    And 'email' text should be fully displayed
    When I enter 'tradingplatformsdevelopmentba@gaincapital.com' into 'new email' text input field
    And I enter 'tradingplatformsdevelopmentba@gaincapital.com' into 're-enter email' text input field
    Then 'update email button' should be enabled
    When I click 'update email button' in account details section
    Then 'current email' is updated
    Then 'current email' text should be fully displayed
    And 'email' text should be with three dots in the name
    When I enter '12345678@gaincapitalgaincapitalgaincapitalgaincapital.com' into 'new email' text input field
    And I enter '12345678@gaincapitalgaincapitalgaincapitalgaincapital.com' into 're-enter email' text input field
    Then 'update email button' should be enabled
    When I click 'update email button' in account details section
    Then 'current email' is updated
    Then 'current email' text should be fully displayed
    And 'email' text should be with three dots in the domain name
    When I enter 'tradingplatformsdevelopmentba@gaincapitalgaincapitalgaincapitalgaincapital.com' into 'new email' text input field
    And I enter 'tradingplatformsdevelopmentba@gaincapitalgaincapitalgaincapitalgaincapital.com' into 're-enter email' text input field
    Then 'update email button' should be enabled
    When I click 'update email button' in account details section
    Then 'current email' is updated
    Then 'current email' text should be fully displayed
    And 'email' text should be with three dots in the name and domain name
    And email tooltip should be correct
    When I enter '12345' into 'old password' text input field
    Then 'update now button' should be disabled
    When I enter '12345' into 'new password' text input field
    Then 'update now button' should be disabled
    When I enter '12345' into 're-enter password' text input field
    Then 'update now button' should be disabled
    When I enter '123456789012345678901' into 'old password' text input field
    Then 'update now button' should be disabled
    When I enter '123456789012345678901' into 'new password' text input field
    Then 'update now button' should be disabled
    When I enter '123456789012345678901' into 're-enter password' text input field
    Then 'update now button' should be disabled
    When I enter '123456' into 'old password' text input field
    Then 'update now button' should be disabled
    When I enter 'new password' into 'new password' text input field
    Then 'update now button' should be disabled
    When I enter 'new password' into 're-enter password' text input field
    Then 'update now button' should be enabled
    When I click 'update now button' in account details section
    Then 'error message' text is 'Your password should have a minimum of 6 characters and a maximum of 20 characters. Your password will not be case sensitive.'
    And 'update now button' should be disabled
    When I enter 'old password' into 'old password' text input field
    And I enter '1234567' into 'new password' text input field
    And I enter '1234568' into 're-enter password' text input field
    Then 'update now button' should be disabled
    When I enter 'old password' into 'old password' text input field
    And I enter 'new password' into 'new password' text input field
    And I enter 'new password' into 're-enter password' text input field
    Then 'update now button' should be enabled
    When I click 'update now button' in account details section
    Then password is changed successfully
    When I enter 'old email' into 'new email' text input field
    And I enter 'old email' into 're-enter email' text input field
    Then 'update email button' should be enabled
    When I click 'update email button' in account details section
    Then 'current email' is updated
    And 'current email' text should be fully displayed

  # TODO: rewrite scenario and scripts because months changing in time & this part of app changed
  @ignore @quick @smoke @ppe @handles @statements-and-contracts @KL76429-password
  Scenario: Statements and contracts
    When I click on 'user account' header element
    And I go to my account page
    Then Account board should be active
    When I go to 'statements' section
    Then the statements section should be active
    And the statements section should contain items:
      | statements and contracts header |
      | statements checkbox |
      | contract notes checkbox |
    And 'statements checkbox' option is selected
    And 'Monthly' option is selected in 'select dates' dropdown
    And 'search button' should be enabled
    When I select 'May 2018' month from the list
    Then 'May 2018' month is selected in the list
    When I click 'search button' in statements and contracts section
    Then the statements section should contain items:
      | statements items |
    And the list of statements and contracts for the correct 'month' is displayed
    When I click 'download link' in statements and contracts section
    Then the statements section should contain items:
      | pdf |
    When I navigate back to previous page
    Then the statements section should be active
    When I select 'April 2018' month from the list
    Then 'April 2018' month is selected in the list
    # TODO: account with statements and contracts for several dates needed
    # And the list of statements and contracts for the correct 'month' is displayed
    When I click 'other dates link' in statements and contracts section
    Then the statements section should contain items:
      | statements and contracts header |
      | statements checkbox |
      | contract notes checkbox |
      | select dates |
      | from date |
      | to date |
    When I select from date '1 April 2018' in the date picker
    And I select to date '30 May 2018' in the date picker
    Then 'search button' should be enabled
    When I click 'search button' in statements and contracts section
    Then the statements section should contain items:
      | statements items |
    And the list of statements and contracts for the correct 'date range' is displayed
    When I click 'statements checkbox' in statements and contracts section
    Then 'statements checkbox' option is not selected
    When I click 'contract notes checkbox' in statements and contracts section
    Then 'contract notes checkbox' option is selected
    When I select 'Last 24 hours' option from 'select dates' dropdown in 'statements and contracts' section
    Then 'search button' should be enabled
    # TODO: account with statements and contracts for several dates needed
    # When I click 'search button' in statements and contracts section
    # Then the list of statements and contracts for the correct 'date range' is displayed
    When I click 'statements checkbox' in statements and contracts section
    Then 'statements checkbox' option is selected
    When I select 'Last 7 days' option from 'select dates' dropdown in 'statements and contracts' section
    Then 'search button' should be enabled
    # TODO: account with statements and contracts for several dates needed
    # When I click 'search button' in statements and contracts section
    # Then the list of statements and contracts for the correct 'date range' is displayed
    When I select 'Last 30 days' option from 'select dates' dropdown in 'statements and contracts' section
    Then 'search button' should be enabled
    # TODO: account with statements and contracts for several dates needed
    # When I click 'search button' in statements and contracts section
    # Then the list of statements and contracts for the correct 'date range' is displayed
    # workaround for dates selection
    When I select 'Other' option from 'select dates' dropdown in 'statements and contracts' section
    Then the statements section should contain items:
      | statements and contracts header |
      | statements checkbox |
      | contract notes checkbox |
      | select dates |
      | from date |
      | to date |
    When I select from date '30 Sepetember 2018' in the date picker
    And I select to date '30 October 2018' in the date picker
    # bug https://jira.gaincapital.com/browse/TPDWT-12093
    # should be
    # Then 'search button' should be disabled
    When I select from date '25 April 2018' in the date picker
    And I select to date '30 March 2018' in the date picker
    # bug https://jira.gaincapital.com/browse/TPDWT-12093
    # Then 'search button' should be disabled
    When I select 'Monthly' option from 'select dates' dropdown in 'statements and contracts' section
    Then the statements section should not contain items:
      | from date |
      | to date |

  @quick @smoke @account-information @wt-1246
  Scenario Outline: Account information
    When I relogin to the application as '<Account type>' account
    And I click on 'user account' header element
    And I go to my account page
    Then Account board should be active
    And 'icon container' should be visible within account tab
    And 'full username' should be visible within account tab
    And 'full username' text is 'correct'
    And 'logged username' should be visible within account tab
    And 'logged username' text is 'correct'
    # NEW REQUIREMENTS: https://jira.gaincapital.com/browse/TPDWT-18581 - HIDDEN in 1.19
    # And 'CFD account' <CFD account visibility option> be visible within account tab
    # And 'Spread account' <Spread account visibility option> be visible within account tab
    And 'email' should be visible within account tab
    And 'email' text should be <Email format>

    Examples:
      | Account type | Email format                |
      | CFD          | fully displayed             |
      | Spread       | fully displayed             |
      | CFD & Spread | with three dots in the name |
