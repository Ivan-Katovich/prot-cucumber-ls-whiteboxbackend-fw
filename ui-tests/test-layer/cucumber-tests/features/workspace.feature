@workspace
Feature: Workspace
  As a user
  I can open open all panels
  So all panels functionality should work fine

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @close @default-workspace @wt-1334-v18
  Scenario: Default Workspace
    #1
    Then the count of tabs should be '3'
    And the 'header' should contain items:
      | itemName  |
      | searchDiv |
    And 'Browse markets' tab should be not active
    And 'Browse markets' tab default width should be '150' px
    When I find the highest weighted market in 'Popular Markets' watchlist
    Then 'current market product' tab should be not active
    And 'current market product' tab default width should be '150' px
    And 'Default Workspace' tab should be active
    And 'Default Workspace' tab default width should be '150' px
    And the icon create new workspace is visible
    #2
    When I switch to 'current market product' workspace tab
    Then 'current market product' tab should be active
    When I am on the 'Chart'
    Then 'current' market should be opened on the chart
    #3
    When I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    And the 'Watchlist' panel should be visible
    And 'Popular Markets' watchlist should be expanded
    And the 'News feed' panel should be visible
    And the 'Positions And Orders' panel should be visible
    And the 'Chart' panel should be visible
    And 'default' market should be in panel header
    And the chart should be loaded
    And 'default' market should be opened on the chart
    #4
    When I make 'Watchlist' panel active
    Then markets of 'Popular Markets' watchlist should be visible
    And 'Popular Markets' watchlist should be expanded
    And the 'Popular Markets' watchlist should return the same markets as backend request
    #5
    When I expand dropdown in 'Default Workspace' tab
    Then 'current' tab should contain items:
      | itemName             |
      | component state text |
      | show me button       |
      | icon for rename      |
      | list of components   |
      | delete workspace     |
      | bin icon             |
      | clear workspace      |
      | x button             |
    And workspace dropdown 'component state text' element should contain text 'There are 4 components in your workspace.'
    And workspace dropdown 'workspace name' element should contain text 'Default Workspace'
    And workspace dropdown 'list title' element should contain text 'ADD TO YOUR WORKSPACE'
    And workspace dropdown component list contains items in the correct order:
      | Watchlist                   |
      | Chart                       |
      | News feed                   |
      | Economic calendar           |
      | Positions and Orders        |
      # after 1.23
      #| Positions                 |
      #| Orders                    |
      #| Price Alerts              |
      | Reports                     |
    And workspace dropdown component list contains optional items if KVP set
    And workspace dropdown component list contains used items in the correct order:
      | Watchlist                   |
      | News feed                   |
      | Positions and Orders        |
    And Charts number should be '1'
    #7
    When I click 'Show me' button in 'Default Workspace' tab
    Then the 'Grid view component' element is visible in 'Default Workspace' tab
    And workspace dropdown grid view contains items in the correct order:
      | Watchlists                  |
      | Chart according market name |
      | Positions and Orders        |
      | News                        |
    #8
    When I click 'Grid view component close btn' button in 'Default Workspace' tab
    And workspace dropdown 'component state text' element should contain text 'There are 3 components in your workspace.'
    And workspace dropdown grid view contains items in the correct order:
      | Chart according market name |
      | Positions and Orders        |
      | News                        |
    And the 'Watchlist' panel should be invisible
    #9
    And the 'Icon for rename' element is visible in 'current' tab
    When I click 'Edit icon' button in 'current' tab
    Then the 'Input icon for input' element is visible in 'current' tab
    When I type 'test' name workspace and save
    Then 'test' tab should be active
    #10
    When I click 'Clear workspace' button in 'test' tab
    Then the 'Grid view component' element is invisible in 'test' tab
    And the 'Chart' panel should be invisible
    And the 'News feed' panel should be invisible
    And the 'Positions And Orders' panel should be invisible
    #6
    When I add new 'Watchlist' panel in 'test' tab
    Then the 'Watchlist' panel should be visible
    When I add new 'Chart' panel in 'test' tab
    Then the 'Chart' panel should be visible
    When I add new 'News feed' panel in 'test' tab
    Then the 'News feed' panel should be visible
    When I add new 'Economic Calendar' panel in 'test' tab
    Then the 'Economic Calendar' panel should be visible
    When I add new 'Positions And Orders' panel in 'test' tab
    Then the 'Positions And Orders' panel should be visible
    When I expand dropdown in 'test' tab
    And workspace dropdown 'component state text' element should contain text 'There are 5 components in your workspace.'
    #11
    Then the 'Delete workspace' element is visible in 'test' tab
    When I click 'Delete workspace' button in 'test' tab
    And the count of tabs should be '2'

#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @dropdown @close @default-workspace-functionality
  Scenario: Default Workspace functionality
    Then the count of tabs should be '3'
    And 'Browse markets' tab should be not active
    And 'Default Workspace' tab should be active
    And the 'Watchlist' panel should be visible
    And 'Popular Markets' watchlist should be expanded
    And the 'News feed' panel should be visible
    And the 'Positions And Orders' panel should be visible
    And the 'Chart' panel should be visible
    When I expand dropdown in 'Default Workspace' tab
    Then the 'List of components' element is visible in 'Default Workspace' tab
    When I click 'Clear workspace' button in 'Default Workspace' tab
    Then the 'Watchlist' panel should be invisible
    And the 'Chart' panel should be invisible
    And the 'News feed' panel should be invisible
    And the 'Economic Calendar' panel should be invisible
    And the 'Positions And Orders' panel should be invisible
    When I add new 'Watchlist' panel in 'Default Workspace' tab
    Then the 'Watchlist' panel should be visible
    When I add new 'Chart' panel in 'Default Workspace' tab
    Then the 'Chart' panel should be visible
    When I add new 'News feed' panel in 'Default Workspace' tab
    Then the 'News feed' panel should be visible
    When I add new 'Economic Calendar' panel in 'Default Workspace' tab
    Then the 'Economic Calendar' panel should be visible
    When I add new 'Positions And Orders' panel in 'Default Workspace' tab
    Then the 'Positions And Orders' panel should be visible
    When I expand dropdown in 'Default Workspace' tab
    And I click 'Show me' button in 'Default Workspace' tab
    Then the 'Delete workspace' element is visible in 'Default Workspace' tab
    And the 'Grid view component' element is visible in 'Default Workspace' tab
    When I click 'Grid view component close btn' button in 'Default Workspace' tab
    Then the 'Watchlist' panel should be invisible
    And the 'Icon for rename' element is visible in 'Default Workspace' tab

  @new-workspace-functionality
  Scenario: New Workspace functionality
    When I add new tab
    And I expand dropdown in 'New workspace 2' tab
    And I click 'Edit icon' button in 'New workspace 2' tab
    Then the 'Input icon for input' element is visible in 'New workspace 2' tab
    When I type 'test' name workspace and save
    Then 'test' tab should be active
    When I add new 'Watchlist' panel in 'test' tab
    Then 'Watchlist' panel is disabled in 'test' tab
    And the 'Watchlist' panel should be visible
    When I add new 'News feed' panel in 'test' tab
    Then 'News feed' panel is disabled in 'test' tab
    And the 'News feed' panel should be visible
    When I add new 'Economic Calendar' panel in 'test' tab
    Then 'Economic Calendar' panel is disabled in 'test' tab
    And the 'Economic Calendar' panel should be visible
    When I expand dropdown in 'current' tab
    Then Charts number should be 'empty'
    When I add '10' Chart panels
    Then 'Chart' button is disabled in 'test' tab
    And Charts number should be '10'
    And count of 'Chart' panels should be '10'
    When I add new 'Positions And Orders' panel in 'test' tab
    Then 'Positions And Orders' panel is disabled in 'test' tab
    And the 'Positions And Orders' panel should be visible
    When I click 'Clear workspace' button in 'test' tab
    Then the 'Watchlist' panel should be invisible
    And the 'Chart' panel should be invisible
    And the 'News feed' panel should be invisible
    And the 'Economic Calendar' panel should be invisible
    And the 'Positions And Orders' panel should be invisible
    When I add new tab
    And I add new tab
    And I add new tab
    And I add new tab
    And I add new tab
    And I add new tab
    And I add new tab
    And I add new tab
    Then the icon create new workspace is invisible
    When I close '12'th tab
    Then the count of tabs should be '11'

  @delete-watchlist @product-page
  Scenario: Product Page
    Then the 'Watchlist' panel should be visible
    And I collapse 'Popular Markets' watchlist
    And I create 'test1' watchlist
    And the 'test1' watchlist should be visible
    When I type 'Germany' name of market
    Then the 'market from dropdown' element should be visible on '1'nd watchlist
    When I add '1'st market from market dropdown
    And I expand 'test1' watchlist
    And I complete 'current' market dropdown with value 'Market 360 chart, news, market information'
    Then tabs count should be '3'
    When I am on the 'Watchlist container'
    Then the 'dropdown' should be visible in product page
    When I am on the 'Market container'
    Then the correct market display to the right '1'st position
    When I switch to '2'nd workspace tab
    And I make 'Watchlist' panel active
    And I create 'test2' watchlist
    Then the 'test2' watchlist should be visible
    When I type 'Spread' name of market
    Then the 'market from dropdown' element should be visible on 'test2' watchlist
    When I add '1'st market from market dropdown
    And I complete 'current' market dropdown with value 'Market 360 chart, news, market information'
    And I am on the 'Market container'
    Then the correct market display to the right '1'st position
    When I am on the 'Market information'
    Then the correct market display in market information
    When I am on the 'Chart'
    Then 'Spread' market should be opened on the chart
    When I am on the 'News feed' component
    Then the 'News feed' no panel component should be visible
    When I switch to 'Economic Calendar'
    Then I am on the 'Economic Calendar' component
    And all the panels parts should be loaded
