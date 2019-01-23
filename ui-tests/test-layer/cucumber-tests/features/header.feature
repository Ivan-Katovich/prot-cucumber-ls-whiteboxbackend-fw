@header
Feature: Header
  As a user
  I can see all header items displayed correctly
  So all navigation between items should work fine for the header

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @default-resize-window @header-components-visibility @wt-5-v13
  Scenario: Header components visibility
    #1
    Then the 'header' should contain items:
      | itemName                  |
      | logo                      |
      | balance bar               |
      | add funds button          |
      | one click trading toggle  |
      | feedbackBtn               |
      | help button               |
      | notifications             |
      | user account              |
    And balance bar displays items in the correct order:
      | Available to trade |
      | Net Equity         |
      | Cash               |
      | Unrealised P&L     |
      | Total Margin       |
      | Margin Indicator   |
    #2
    When I click on 'user account' header element
    Then the 'userMenu' should contain items:
      | itemName   |
      | myAccLink  |
      | logOutLink |
    #3, 4 steps (@wt-5-v12) are duplicated
    When I click on 'myAccLink' userMenu element
    Then Account board should be active
    #5 - moved to separate step
    Then One click trading board should be OFF
    And 'one click trading' color should be grey
    When I click on 'one click trading' header element
    Then 'one click trading message' element in header should be visible
    When I submit one click trading message
    Then One click trading board should be ON
    And 'one click trading' color should be green
    When I click on 'one click trading' header element
    Then One click trading board should be OFF
    And 'one click trading' color should be grey
    When I click on 'one click trading' header element
    Then 'one click trading message' element in header should be visible
    When I cancel one click trading message
    Then One click trading board should be OFF
    And 'one click trading' color should be grey
    #6 relogin can hangs on
    #When I click on 'user account' header element
    #Then the 'userMenu' should contain items:
    #  | itemName   |
    #  | myAccLink  |
    #  | logOutLink |
    #When I click on 'logOutLink' userMenu element
    #Then link redirects to the correct 'logOutLink' url
    #And I login as default account to the application
    #7
    When I click on 'feedbackBtn' header element
    Then the 'feedbackModal' should contain items:
      | itemName           |
      | contact us         |
      | client management  |
      | phone              |
      | chat               |
      | feedback text area |
      | submit button      |
    And the submit button should be disabled
    And 'contact us' element in feedback modal dialogue should contain text 'Contact us'
    When I click on 'feedbackBtn' header element
    #8
    When I click on 'help button' header element
    Then dialogue header should be 'Help and support'
    And '1'st section header should be 'Getting started'
    And '2'st section header should be 'New Features'
    And '3'st section header should be 'Tips by topic'
    And help dialogue 'close button' should be visible
    And help dialogue 'charts provided by' should be visible
    When I click on 'charts provided by link' help modal element
    And I switch to '2' browser tab
    Then link redirects to the correct 'charts provided by link' url
    When I close current browser tab
    And I switch to '1' browser tab
    And I click on 'close help modal' header element
    #9
    When I click on 'notifications' header element
    Then notification dialogue should be visible
    And notification dialogue header should be 'Notifications'
    When I close notification dialogue
    Then notification dialogue should be invisible
    #10
    When I resize window with:
      | height | 1680   |
      | width  | 900    |
    Then the 'header' should contain items:
      | itemName                  |
      | logo                      |
      | add funds button          |
      | one click trading toggle  |
      | feedbackBtn               |
      | help button               |
      | notifications             |
      | user account              |
    When I resize window with:
      | height | 1680  |
      | width  | 300   |
    Then the 'header' should contain items:
      | itemName                  |
      | notifications             |
      | user account              |


#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @header-components-visibility
  Scenario: Header components visibility
    Then the 'header' should contain items:
      | itemName          |
      | logo              |
      | notifications     |
      | balance bar       |
      | add funds button  |
      | help button       |
      | feedbackBtn       |
      | user account      |
    When I click on 'user account' header element
    Then the 'userMenu' should contain items:
      | itemName   |
      | myAccLink  |
      | logOutLink |
    When I click on 'user account' header element
    And I click on 'userIcon' header element
    Then the 'userMenu' should contain items:
      | itemName   |
      | myAccLink  |
      | logOutLink |
    When I click on 'myAccLink' userMenu element
    Then Account board should be active

  @search-field
  Scenario: Search field
    Then the search text input 'placeholder' should be 'Search markets'
    When I click on Search input
    Then Search modal should be visible
    And the search text input 'placeholder' should be 'Type two or more characters'
    When I close search input
    Then Search modal should be not visible
    And the search text input 'placeholder' should be 'Search markets'
    When I click on Search input
    And I fill search field with value 'us'
    Then the search text input 'value' should be 'us'
    When I wait for markets loading
    Then markets count should be more than '0'
    And all markets should contain 'US'
    When I clear search input field
    And I click on Search input
    Then the search text input 'placeholder' should be 'Type two or more characters'

  #TODO feedback form controlled using KVPs https://jira.gaincapital.com/browse/TPDAP-4071
  @handles @customer-feedback-form
  Scenario: Customer feedback form
    When I click on 'feedbackBtn' header element
    Then the 'feedbackModal' should contain items:
      | itemName           |
      | contact us         |
      | client management  |
      | phone              |
      | chat               |
      | feedback text area |
      | submit button      |
    And the submit button should be disabled
    And 'contact us' element in feedback modal dialogue should contain text 'Contact us'
    And 'contact us' feedback link should lead us to 'https://www.cityindex.co.uk/contact-us/'
    When I obtain 'contact us' url from kvp
    And I redirect to 'contact us'
    Then link redirects to the correct 'contact us' url
    When I close current browser tab
    And I switch to '1' browser tab
    Then 'client management' element in feedback modal dialogue should contain text 'client-management@cityindex.co.uk'
    And 'client management' feedback link should lead us to 'mailto:client-management@cityindex.co.uk'
    And 'phone' element in feedback modal dialogue should contain text '0845 355 0801'
    And 'phone' feedback link should lead us to 'tel:08453550801'
    When I obtain 'AP_Online_Chat_URL' url from kvp
    And I redirect to 'chat'
    Then link redirects to the correct 'AP_Online_Chat_URL' url
    When I close current browser tab
    And I switch to '1' browser tab
    And I fill feedback text field with value 't'
    Then the submit button should be disabled
    When I fill feedback text field with value 'te'
    Then the submit button should be disabled
    When I fill feedback text field with value 'test feedback'
    Then the submit button should be enabled
    When I click on 'submitBtn' feedbackModal element
    Then 'feedback message' element in feedback modal dialogue should contain text 'Thank you for your feedback'
    And 'submit button' element in feedbackModal should be invisible

  @balance-bar
  Scenario: Balance Bar
    Then balance bar displays items in the correct order:
      | Available to trade |
      | Net Equity         |
      | Cash               |
      | Unrealised P&L     |
      | Total Margin       |
      | Margin Indicator   |
    And 'Available to trade' is displayed on balance bar with correct text and value
    And 'Net Equity' is displayed on balance bar with correct text and value
    And 'Cash' is displayed on balance bar with correct text and value
    And 'Unrealised P&L' is displayed on balance bar with correct text and value
    And 'Total Margin' is displayed on balance bar with correct text and value
    And 'Margin Indicator' is displayed on balance bar with correct text and value
    When I add position with parameters:
      | MarketName | USD/JPY (per 0.01) CFD |
      | Direction  | buy                    |
      | Quantity   | 100                    |
    And I wait for '500'
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And 'Available to trade' is displayed on balance bar with correct text and value updated
    And 'Net Equity' is displayed on balance bar with correct text and value
    And 'Cash' is displayed on balance bar with correct text and value
    And 'Unrealised P&L' is displayed on balance bar with correct text and value updated
    And 'Total Margin' is displayed on balance bar with correct text and value updated
    And 'Margin Indicator' is displayed on balance bar with correct text and value updated
    When I add order with parameters:
      | MarketName | USD/JPY |
      | Direction  | sell    |
      | Quantity   | 1000    |
      | Price      | 97      |
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    Then the 'previously added' market should be present on the list
    And 'Available to trade' is displayed on balance bar with correct text and value updated
    And 'Net Equity' is displayed on balance bar with correct text and value
    And 'Cash' is displayed on balance bar with correct text and value
    And 'Unrealised P&L' is displayed on balance bar with correct text and value updated
    And 'Total Margin' is displayed on balance bar with correct text and value updated
    And 'Margin Indicator' is displayed on balance bar with correct text and value updated
    When I delete 'position' 'USD/JPY (per 0.01) CFD'
    Then 'Available to trade' is displayed on balance bar with correct text and value
    And 'Net Equity' is displayed on balance bar with correct text and value
    And 'Cash' is displayed on balance bar with correct text and value
    And 'Unrealised P&L' is displayed on balance bar with correct text and value
    And 'Total Margin' is displayed on balance bar with correct text and value
    And 'Margin Indicator' is displayed on balance bar with correct text and value
