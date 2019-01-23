@help
Feature: Help
  As a user
  I can open Help Modal Dialogue and get some information
  So all Help functionality should work fine

  Background:
    Given I am logged in to the application with default state

  @quick @smoke @help-main-dialogue
  Scenario: Help main dialogue
    When I click on 'help button' header element
    Then dialogue header should be 'Help and support'
    And '1'st section header should be 'Getting started'
    And '1'st section should contain items:
      | Re-launch platform guide |
      | Finding an instrument    |
      | Placing a trade          |
      | Managing positions       |
    And '2'st section header should be 'New Features'
    And '2'st section should contain items:
      | New charts               |
      | Enhanced Watchlists      |
      | Build your own workspace |
    And '3'st section header should be 'Tips by topic'
    And '3'st section should contain items:
      | One click trading            |
      | Managing risk                |
      | Finding your profit and loss |
      | Adding funds                 |
#      | Harnessing price alerts      |
    And help dialogue 'close button' should be visible
    When I open 'New charts' item
    Then dialogue header should be 'New charts'
    And help dialogue 'back button' should be visible
    And help dialogue 'description' should be visible
    And help dialogue 'close button' should be invisible
    When I go back
    Then dialogue header should be 'Help and support'
    And help dialogue 'close button' should be visible
    When I close help dialogue
    Then help dialogue should be invisible

  @quick @smoke @platform-guide-journey
  Scenario: Platform guide journey
    When I click on 'help button' header element
    Then help dialogue should be visible
    When I open 'Re-launch platform guide' item
    Then help dialogue should be invisible
    And guide bubble should be visible
    And guide bubble 'back later link' should be visible
    And guide bubble 'button next' should be visible
    And guide bubble 'button next' text should be 'Show me more'
    And guide bubble 'button previous' should be invisible
    And guide bubble 'counter' text should be 'Welcome to Web Trader'
    And guide bubble 'description' text should be 'Let’s go through 9 tips to get you started.'
    When I click on 'button next' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'back later link' should be visible
    And guide bubble 'button next' text should be 'Next'
    And guide bubble 'button previous' should be visible
    And guide bubble 'name' text should be 'TABS & WORKSPACES'
    And guide bubble 'counter' text should be 'tip 1 of 9'
    And guide bubble 'description' text should be 'Use this tab to create your custom trading workspace.'
    When I click on 'button next' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'back later link' should be visible
    And guide bubble 'button next' text should be 'Next'
    And guide bubble 'button previous' should be visible
    And guide bubble 'name' text should be 'COMPONENTS'
    And guide bubble 'counter' text should be 'tip 2 of 9'
    And guide bubble 'description' text should be 'You can add more components, such as charts, news and economic calendar, to your workspace from this drop down.'
    When I click on 'button next' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'back later link' should be visible
    And guide bubble 'button next' text should be 'Next'
    And guide bubble 'button previous' should be visible
    And guide bubble 'name' text should be 'NEW TABS'
    And guide bubble 'counter' text should be 'tip 3 of 9'
    And guide bubble 'description' text should be 'Click here to create a new workspace.'
    When I click on 'button next' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'back later link' should be visible
    And guide bubble 'button next' text should be 'Next'
    And guide bubble 'button previous' should be visible
    And guide bubble 'name' text should be 'BROWSE FOR MARKETS'
    And guide bubble 'counter' text should be 'tip 4 of 9'
    And guide bubble 'description' text should be 'Browse for markets using this tab.'
    When I click on 'button next' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'back later link' should be visible
    And guide bubble 'button next' text should be 'Next'
    And guide bubble 'button previous' should be visible
    And guide bubble 'name' text should be 'SEARCH FOR MARKETS'
    And guide bubble 'counter' text should be 'tip 5 of 9'
    And guide bubble 'description' text should be 'Search for a market from here. Type 2 or more characters to start a search.'
    When I click on 'button next' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'back later link' should be visible
    And guide bubble 'button next' text should be 'Next'
    And guide bubble 'button previous' should be visible
    And guide bubble 'name' text should be 'CLOSING ORDERS'
    And guide bubble 'counter' text should be 'tip 6 of 9'
    And guide bubble 'description' text should be 'Stops and Limits associated with a position are now located next to the position they are attached to.'
    When I click on 'button next' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'back later link' should be visible
    And guide bubble 'button next' text should be 'Next'
    And guide bubble 'button previous' should be visible
    And guide bubble 'name' text should be 'CONTACT US'
    And guide bubble 'counter' text should be 'tip 7 of 9'
    And guide bubble 'description' text should be 'If you’d like to get in touch or give feedback, we’re just a click away.'
    When I click on 'button next' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'back later link' should be visible
    And guide bubble 'button next' text should be 'Next'
    And guide bubble 'button previous' should be visible
    And guide bubble 'name' text should be 'MY ACCOUNT'
    And guide bubble 'counter' text should be 'tip 8 of 9'
    And guide bubble 'description' text should be 'Click here to manage your account, add and withdraw funds.'
    When I click on 'button next' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'back later link' should be invisible
    And guide bubble 'finish button' text should be 'Finish'
    And guide bubble 'button next' should be invisible
    And guide bubble 'button previous' should be invisible
    And guide bubble 'name' text should be 'HELP'
    And guide bubble 'counter' text should be 'Last one'
    And guide bubble 'description' text should be 'If you need any help, there is lots more material here.'
    When I click on 'finish button' in the guide bubble
    Then guide bubble should be invisible

  @quick @smoke @platform-guide-features
  Scenario: Platform guide features
    When I click on 'help button' header element
    Then help dialogue should be visible
    When I open 'Re-launch platform guide' item
    Then help dialogue should be invisible
    And guide bubble should be visible
    And other elements should be inactive
    When I click on 'button next' in the guide bubble
    Then guide bubble 'name' text should be 'TABS & WORKSPACES'
    When I click on 'button next' in the guide bubble
    Then guide bubble 'name' text should be 'COMPONENTS'
    When I click on 'button previous' in the guide bubble
    Then guide bubble 'name' text should be 'TABS & WORKSPACES'
    When I click on 'back later link' in the guide bubble
    Then guide bubble should be visible
    And guide bubble 'description' text should be 'Click here to relaunch this guide.'
    And guide bubble 'counter' text should be 'RE-LAUNCH'
    When I wait for '5000'
    Then guide bubble should be invisible
    When I click on 'help button' header element
    Then help dialogue should be visible
    When I open 'Re-launch platform guide' item
    Then help dialogue should be invisible
    And guide bubble should be visible
    And guide bubble 'name' text should be 'TABS & WORKSPACES'
