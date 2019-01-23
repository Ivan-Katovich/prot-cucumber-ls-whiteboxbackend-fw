@news
Feature: News
  As a user
  I can open news
  So all functionality of news should work fine

  Background:
    Given I am logged in to the application with default state

  @quick @smoke @articles-display
  Scenario: Articles display
    Then the 'News feed' panel should be visible
    And the header of 'News feed' panel is 'News'
    And articles should be visible
    And each article has timestamp
    And each article has title
    And articles are shown in descending order based on timestamp
    When I click on '1'st article in the list
    Then articles should be visible
    And 'Article' should be visible
    And 'Article title' should be visible
    And 'Article text' should be visible
    And 'Button back' should be visible
    And 'Timestamp' should be visible
    When I move 'right' border '800' pixel 'left'
    Then articles should be invisible
    And 'Article' should be visible
    When I click on Button back
    Then articles should be visible
    And 'Article' should be invisible
    When I close panel
    Then the 'News feed' panel should be invisible

  @quick @smoke @news-feed-search
  Scenario: News feed search
    Then the 'News feed' panel should be visible
    And articles should be visible
    And search input placeholder should be 'All headlines'
    When I click search 'input'
    Then articles should be visible
    And empty message should be invisible
    And search input placeholder should be 'All headlines'
    When I fill search input with value 'abirvalg'
    Then articles count should be '0'
    And empty message should be visible and contain text 'No matches found.'
    When I click search 'X button'
    Then empty message should be invisible
    And articles should be visible
    And search input placeholder should be 'All headlines'
    When I fill search input with value 'funds'
    Then each article has title with word 'funds'
    And articles are shown in descending order based on timestamp
    When I click search 'X button'
    Then articles are shown in descending order based on timestamp

  @quick @smoke @EUR/USD @articles-display-for-product-page
  Scenario: Articles display for Product Page
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I hover 'Wall Street CFD' market
    Then the 'current' market 'dropdown arrow' should be visible
    When I complete 'current' market dropdown with value 'Market 360 Chart, news, market information'
    Then tabs count should be '3'
    And I am on the 'News feed' component
    And the 'News feed' no panel component should be visible
    And the header no panel component of 'News feed' is 'News'
    And articles should be visible
    And each article has timestamp
    And each article has title
    And articles are shown in descending order based on timestamp
    When I click on '1'st article in the list
    Then 'Article' should be visible
    And 'Article title' should be visible
    And 'Article text' should be visible
    And 'Button back' should be visible
    And 'Timestamp' should be visible
    When I click on Button back
    Then articles should be visible
