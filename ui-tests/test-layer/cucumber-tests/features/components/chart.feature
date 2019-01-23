@charts
Feature: Charts panel
  As a user
  I can open charts panel
  So all the chart functionality should work as expected

  Background:
    Given I am logged in to the application with default state

  @quick @smoke @multiple-charts
  Scenario: Multiple charts
    When I add new tab
    And I add new 'Chart' panel in 'New workspace 2'th tab
    Then the 'Chart' panel should be visible
    And count of 'Chart' panels should be '1'
    When I expand dropdown in 'current' tab
    Then Charts number should be '1'
    When I add '9' Chart panels
    Then Charts number should be '10'
    And count of 'Chart' panels should be '10'
    And 'Chart' button is disabled in 'current' tab
    When I add new 'Watchlist' panel in 'current' tab
    And I move panel to the 'top-right' corner
    And I expand 'Popular Markets' watchlist
    And I click on 'dropdown arrow' in the '1'st market
    Then 'Chart' in dropdown menu in '1'st market should be disabled
    When I close 'Chart' panel
    Then count of 'Chart' panels should be '9'
    When I make 'watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'dropdown arrow' in the '1'st market
    Then 'Chart' in dropdown menu in '1'st market should be enabled
    When I select 'Chart' in dropdown menu in 'current' market
    Then count of 'Chart' panels should be '10'
    When I make 'watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'dropdown arrow' in the '1'st market
    Then 'Chart' in dropdown menu in '1'st market should be disabled

  @quick @smoke @open-default-market-on-charts-panel
  Scenario: Open default market on charts panel
    When I add new tab
    And I add new 'Chart' panel in 'New workspace 2' tab
    Then the panel should be visible
    And 'default' market should be in panel header
    And the chart should be loaded
    And 'default' market should be opened on the chart

  @quick @smoke @change-market-using-market-search-control
  Scenario: Change market using market search control
    When I add new tab
    And I add new 'Chart' panel in 'New workspace 2'th tab
    Then the panel should be visible
    And the chart should be loaded
    When I switch market to 'Germany 30 CFD'
    Then 'Germany 30 CFD' market should be opened on the chart
    And 'Germany 30 CFD' market should be in panel header
