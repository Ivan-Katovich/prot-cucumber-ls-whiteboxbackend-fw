@product-page
Feature: Product page
  As a user
  I can open product page for any market
  So all the product page functionality should work as expected

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @delete-watchlist @market-360-tab-view @wt-658-v7
  Scenario: Market 360 tab view
    #1
    When I make 'Watchlist' panel active
    When I expand 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    When I click on 'dropdown arrow' in the '1'st market
    When I select 'Market 360 Chart, news, market information' in dropdown menu in '1'st market
    Then 'current market product' tab should be active
    When I am on the 'Watchlist container'
    Then the 'watchlist name' should be visible in product page
    And the 'dropdown arrow' should be invisible in product page
    When I navigate back to previous page
    #
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I click on 'name' in the '1'st market within search modal
    And I wait for chart loading
    Then the 'chart in search modal' panel should be visible
    When I click on squares icon within menu above Chart
    And 'current market product' tab should be active
    When I am on the 'Watchlist container'
    Then the 'watchlist name' should be visible in product page
    And the 'dropdown arrow' should be invisible in product page
    When I navigate back to previous page
    #
    And I make 'Positions And Orders' panel active
    And I add position with parameters:
      | MarketName | AUD/USD |
      | Direction  | buy     |
      | Quantity   | 1000    |
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And I click on 'dropdown arrow' in the 'current' market
    And I select 'Market 360 Chart, news, market information' in dropdown menu in '1'st market
    Then 'current market product' tab should be active
    When I am on the 'Watchlist container'
    Then the 'watchlist name' should be visible in product page
    And the 'dropdown arrow' should be invisible in product page
    When I navigate back to previous page
    #
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    Then the panel should be visible
    When I expand 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    When I hover '1'st market
    And I click on 'squares icon' in the '1'st market
    Then 'current market product' tab should be active
    When I am on the 'Watchlist container'
    Then the 'watchlist name' should be visible in product page
    And the 'dropdown arrow' should be invisible in product page
    When I navigate back to previous page
    #2
    And I switch to 'New workspace 2' workspace tab
    And I make 'Watchlist' panel active
    And I create 'New Watchlist 1' watchlist
    Then the 'New Watchlist 1' watchlist should be visible
    When I create 'Test' watchlist
    Then the 'Test' watchlist should be visible
    When I remember all existed watchlists
    And I type 'EUR/USD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I type 'AUD/USD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I type 'UK 100 CFD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I remember markets in 'New Watchlist 1' watchlist
    And I hover '1'st market
    And I click on 'squares icon' in the '1'st market
    Then 'current market product' tab should be active
    And tabs count should be '4'
    When I am on the 'Watchlist container'
    Then the 'watchlist name' should be visible in product page
    And the 'dropdown arrow' should be visible in product page
    When I click on dropdown arrow in product page
    Then the 'dropdown body' should be visible in product page
    And existed watchlists displayed in correct order within watchlist dropdown body in product page
    #3
    When I am on the 'Market container'
    Then the correct market display to the right '1'st position
    And 'selected' market inside market container should be hightlighted
    And all markets from selected watchlist are displayed in market container
    #4
    When I am on the 'Market information'
    Then the correct market display in market information
    When I am on the 'Market container'
    And I switch on the market on the '3'st position
    #Then '3'rd tab name should be 'previously added market'
    And '1'st market inside market container should be not hightlighted
    And '3'rd market inside market container should be hightlighted
    When I am on the 'Market information'
    Then the correct market display in market information
    And 'Market information' section default width should be '320' px
    #5
    When I am on the 'Chart'
    Then 'current' market should be opened on the chart
    And 'Chart' section should be to the left of 'Market information' section
    And 'Chart' section should be to the right of 'Economic Calendar' section
    And 'Chart' section should be to the right of 'News feed' section
    #6
    When I am on the 'News feed' component
    Then the 'News feed' no panel component should be visible
    And the header no panel component of 'News feed' is 'News'
    And articles should be visible within no panel component of New feed
    And news list is displayed under search field
    When I scroll to last article in the news list
    Then 'last article' should be visible
    When I scroll to first article in the news list
    Then 'first article' should be visible
    And search input placeholder should be 'All headlines'
    And news list is displayed under search field
    When I click on '1'st article in the list
    Then 'Article' should be visible
    And 'Article title' should be visible
    And 'Article text' should be visible
    And 'Button back' should be visible
    And 'Timestamp' should be visible
    When I click on Button back
    Then articles should be visible
    And displayed news should be related to 'current' market
    #7
    When I switch to 'Economic Calendar'
    Then I am on the 'Economic Calendar' component
    And all the panels parts should be loaded
    And scrolling through corresponding events should be available
    When I switch 'Today' filter within economic calendar
    Then all the panels parts should be loaded
    And scrolling through corresponding events should be available
    When I switch 'Tomorrow' filter within economic calendar
    Then all the panels parts should be loaded
    And scrolling through corresponding events should be available
    When I switch 'This Week' filter within economic calendar
    Then all the panels parts should be loaded
    And scrolling through corresponding events should be available
    When I switch 'Next Week' filter within economic calendar
    Then all the panels parts should be loaded
    And scrolling through corresponding events should be available
    When I expand filters within economic calendar
    Then 'filter panel' is visible within economic calendar
    When I hide filters within economic calendar
    Then 'filter panel' is invisible within economic calendar
    When I expand '1'st event within economic calendar
    Then event details for '1'st event within economic calendar is visible
    When I collapse '1'st event within economic calendar
    Then event details for '1'st event within economic calendar is invisible

#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @smoke @delete-watchlist @watchlists-dropdown-on-product-page @wt-651
  Scenario: Watchlists dropdown on product page
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    Then the panel should be visible
    # Step 5 from manual test case wt-651 is more suitable to run here
    When I expand 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    When I hover '1'st market
    And I click on 'squares icon' in the '1'st market
    Then '3'rd tab name should be 'from parent market'
    And 'current market product' tab should be active
    When I am on the 'Watchlist container'
    Then the 'watchlist name' should be visible in product page
    And the 'dropdown arrow' should be invisible in product page
    When I navigate back to previous page
    And I switch to 'New workspace 2' workspace tab
    And I make 'Watchlist' panel active
    And I create 'New Watchlist 1' watchlist
    Then the 'New Watchlist 1' watchlist should be visible
    When I create 'Test' watchlist
    Then the 'Test' watchlist should be visible
    When I remember all existed watchlists
    And I type 'EUR/USD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I type 'AUD/USD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I remember markets in 'New Watchlist 1' watchlist
    And I hover '1'st market
    And I click on 'squares icon' in the '1'st market
    Then '3'rd tab name should be 'from parent market'
    And 'current market product' tab should be active
    When I am on the 'Market container'
    Then the correct market display to the right '1'st position
    And 'selected' market inside market container should be hightlighted
    And all markets from selected watchlist are displayed in market container
    When I am on the 'Watchlist container'
    Then the 'watchlist name' should be visible in product page
    And the 'dropdown arrow' should be visible in product page
    When I click on dropdown arrow in product page
    Then the 'dropdown body' should be visible in product page
    And existed watchlists displayed in correct order within watchlist dropdown body in product page
    When I switch to 'Popular Markets' watchlist within dropdown list in product page
    Then the 'dropdown arrow' should be visible in product page
    When I click on dropdown arrow in product page
    Then the 'dropdown body' should be visible in product page
    And existed watchlists displayed in correct order within watchlist dropdown body in product page
    When I am on the 'Market container'
    Then part of markets from 'Popular Markets' watchlist is displayed in market container
    And the 'more icon' should be visible in product page
    When I click on more icon in product page
    Then the 'markets dropdown' should be visible in product page
    # TPDWT-10278 - as mentioned in comments - it's reproduced
    # NEW ISSUE - TPDWT-14028 about markets sorting
    #And the markets dropdown contains all the markets from selected watchlist that don't fit product page
    When I click on more icon in product page
    Then the 'markets dropdown' should be invisible in product page
    When I am on the 'Chart'
    Then 'current' market should be opened on the chart
    When I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    When I make 'Watchlist' panel active
    And I create 'Additional watchlist' watchlist
    Then the 'Additional watchlist' watchlist should be visible
    When I remember all existed watchlists
    And I switch to 'current market product' workspace tab
    Then 'current market product' tab should be active
    When I am on the 'Watchlist container'
    Then the 'dropdown arrow' should be visible in product page
    When I click on dropdown arrow in product page
    Then existed watchlists displayed in correct order within watchlist dropdown body in product page

  @smoke @delete-watchlist @market-selection-tool-bar @wt-650
  Scenario: Market selection tool bar
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    Then the panel should be visible
    When I make 'Watchlist' panel active
    And I create 'New Watchlist 1' watchlist
    Then the 'New Watchlist 1' watchlist should be visible
    When I type 'EUR/USD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I type 'AUD/USD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I remember markets in 'New Watchlist 1' watchlist
    And I hover '1'st market
    And I click on 'squares icon' in the '1'st market
    Then '3'rd tab name should be 'from parent market'
    And 'current market product' tab should be active
    When I am on the 'Market container'
    Then the correct market display to the right '1'st position
    And 'selected' market inside market container should be hightlighted
    And '2'nd market inside market container should be not hightlighted
    And all markets from selected watchlist are displayed in market container
    When I switch on the market on the '2'st position
    Then '3'rd tab name should be 'previously added market'
    And 'selected' market inside market container should be hightlighted
    And '1'st market inside market container should be not hightlighted
    When I am on the 'Market information'
    Then the correct market display in market information
    When I am on the 'Chart'
    Then 'current' market should be opened on the chart
    When I switch to 'New workspace 2' workspace tab
    Then 'New workspace 2' tab should be active
    When I make 'Watchlist' panel active
    And I expand 'New Watchlist 1' watchlist
    Then markets of 'New Watchlist 1' watchlist should be visible
    When I type 'USD/JPY' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I remember markets in 'New Watchlist 1' watchlist
    And I switch to '3'rd workspace tab
    And I am on the 'Market container'
    Then '1'st market inside market container should be not hightlighted
    And '2'nd market inside market container should be hightlighted
    And '3'rd market inside market container should be not hightlighted
    And all markets from selected watchlist are displayed in market container
    When I am on the 'Watchlist container'
    And I click on dropdown arrow in product page
    Then the 'dropdown body' should be visible in product page
    When I switch to 'Popular Markets' watchlist within dropdown list in product page
    And I am on the 'Market container'
    Then part of markets from 'Popular Markets' watchlist is displayed in market container
    And the 'more icon' should be visible in product page
    When I click on more icon in product page
    Then the 'markets dropdown' should be visible in product page
    # TPDWT-10278 - as mentioned in comments - it's reproduced
    # NEW ISSUE - TPDWT-14028 about markets sorting
    #And the markets dropdown contains all the markets from selected watchlist that don't fit product page
    When I switch on '1'st market from markets dropdown in product page
    Then the 'markets dropdown' should be invisible in product page
    And the correct market display to the right 'last' position
    And 'selected' market inside market container should be hightlighted
    And '2'nd market inside market container should be not hightlighted
    And the 'more icon' should be visible in product page
    When I click on more icon in product page
    Then the 'markets dropdown' should be visible in product page
    And markets dropdown contains previous market from the last position of Market container
    When I click on more icon in product page
    Then the 'markets dropdown' should be invisible in product page
    When I am on the 'Market information'
    Then the correct market display in market information
    When I am on the 'Chart'
    Then 'current' market should be opened on the chart

  @smoke @delete-watchlist @market-information-view @wt-866
  Scenario: Market information view
    When I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    And the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I hover '1'st market
    And I click on 'squares icon' in the '1'st market
    Then '3'rd tab name should be 'from parent market'
    And 'current market product' tab should be active
    When I am on the 'Watchlist container'
    Then the 'watchlist name' should be visible in product page
    And the 'dropdown arrow' should be invisible in product page
    When I am on the 'Market container'
    Then the correct market display to the right '1'st position
    When I am on the 'Market information'
    Then the correct market display in market information
    # Checking visibility of the main sections inside market information
    # Next steps include scrolling to the sections
    And the 'key information document' should be visible in product page
    And the 'margin factor' should be visible in product page
    And the 'time' should be visible in product page
    And the 'dealing' should be visible in product page
    And the 'orders' should be visible in product page
    And the 'preferences' should be visible in product page
    And the 'notes' should be visible in product page
    And the 'version' should be visible in product page
    When I am on the 'Market container'
    And I switch on the market on the '3'st position
    Then '3'rd tab name should be 'previously added market'
    When I am on the 'Market information'
    Then the correct market display in market information
    # Next steps include scrolling to the sections
    And the 'notes' should be visible in product page
    And the 'version' should be visible in product page

  @smoke @delete-watchlist @charts-component @wt-655
  Scenario: Charts component
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    Then the panel should be visible
    When I make 'Watchlist' panel active
    And I create 'New Watchlist 1' watchlist
    Then the 'New Watchlist 1' watchlist should be visible
    When I remember all existed watchlists
    And I type 'EUR/USD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I type 'AUD/USD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I remember markets in 'New Watchlist 1' watchlist
    And I hover '1'st market
    And I click on 'squares icon' in the '1'st market
    Then '3'rd tab name should be 'from parent market'
    And 'current market product' tab should be active
    When I am on the 'Market information'
    Then the correct market display in market information
    When I am on the 'Chart'
    Then 'current' market should be opened on the chart
    When I am on the 'Watchlist container'
    Then the 'watchlist name' should be visible in product page
    And the 'dropdown arrow' should be visible in product page
    When I click on dropdown arrow in product page
    Then the 'dropdown body' should be visible in product page
    And existed watchlists displayed in correct order within watchlist dropdown body in product page
    When I switch to 'Popular Markets' watchlist within dropdown list in product page
    And I am on the 'Market container'
    Then part of markets from 'Popular Markets' watchlist is displayed in market container
    When I am on the 'Chart'
    Then 'current' market should be opened on the chart
    When I am on the 'Market container'
    And I switch on the market on the '2'st position
    Then '3'rd tab name should be 'previously added market'
    And 'selected' market inside market container should be hightlighted
    And '1'st market inside market container should be not hightlighted
    When I am on the 'Market information'
    Then the correct market display in market information
    When I wait for chart loading
    And I am on the 'Chart'
    Then 'current' market should be opened on the chart
    And sell button element should be enabled inside chart
    And sell button element should be colored in 'red'
    And buy button element should be enabled inside chart
    And buy button element should be colored in 'blue'
    When I refresh current page
    And I wait for chart loading
    And I am on the 'Chart'
    Then 'current' market should be opened on the chart
    And sell button element should be enabled inside chart
    And sell button element should be colored in 'red'
    And buy button element should be enabled inside chart
    And buy button element should be colored in 'blue'
    When I click on sell button within Chart
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    When I fill 'quantity' with value '1000'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'sell*1.01' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'st limit linked order 'price' with value 'sell*0.99' in the 'current market'
    And I click on 'submit' button
    # Next step CAN fail due opened issue - TPDWT-13736
    And I wait confirmation message is displayed within panel
    Then 'confirmation' element text should be 'Trade executed'
    When I click on 'ok' button
    And I navigate back to previous page
    And I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    And the 'Positions And Orders' panel should be visible
    And 'Positions' item should be active
    And the 'previously added' market should be present on the list
    When I switch to '3'rd workspace tab
    And I am on the 'Chart'
    Then 'current' market should be opened on the chart
    When I click on buy button within Chart
    And I wait for 'Deal ticket' panel loading
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'buy'
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I fill 'current market' main price with value not between current prices on 'buy'
    And I fill 'quantity' with value '1000'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.93' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'st limit linked order 'price' with value 'buy*1.01' in the 'current market'
    And I click on 'submit' button
    # Next step CAN fail due opened issue - TPDWT-13736
    And I wait confirmation message is displayed within panel
    Then 'confirmation' element text should be 'Order placed'
    When I click on 'ok' button
    And I navigate back to previous page
    And I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    And the 'Positions And Orders' panel should be visible
    And 'Positions' item should be active
    When I select 'Orders' list
    Then the 'previously added' order should be present on the list
    # Chart component is external module
    # 1-7 steps implemented
    # 8-13 steps are NOT implemented

  @smoke @delete-watchlist @news-component @wt-656
  Scenario: News component
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    Then the panel should be visible
    When I expand 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    When I click on 'squares icon' in the 'USD/CAD' market
    Then '3'rd tab name should be 'from parent market'
    And 'current market product' tab should be active
    When I am on the 'News feed' component
    Then the 'News feed' no panel component should be visible
    And the header no panel component of 'News feed' is 'News'
    And articles should be visible within no panel component of New feed
    And news list is displayed under search field
    When I scroll to last article in the news list
    Then 'last article' should be visible
    When I scroll to first article in the news list
    Then 'first article' should be visible
    And each article has timestamp
    And each article has title
    And articles are shown in descending order based on timestamp
    And search input placeholder should be 'All headlines'
    When I click search 'input'
    Then articles should be visible
    And empty message should be invisible
    And search input placeholder should be 'All headlines'
    When I fill search input with value 'dollar'
    Then each article has title with word 'dollar'
    And articles are shown in descending order based on timestamp
    When I click search 'X button'
    Then articles are shown in descending order based on timestamp
    When I click on '1'st article in the list
    Then 'Article' should be visible
    And 'Article title' should be visible
    And 'Article text' should be visible
    And 'Button back' should be visible
    And 'Timestamp' should be visible
    When I scroll to article title in the news list
    Then 'article title' should be visible
    When I click on Button back
    Then articles should be visible within no panel component of New feed
    And 'Article' should be invisible
    And displayed news should be related to 'current' market

  @smoke @delete-watchlist @economic-calendar-component @wt-657
  Scenario: Economic calendar component
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    Then the panel should be visible
    When I expand 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    When I hover '1'st market
    And I click on 'squares icon' in the '1'st market
    Then '3'rd tab name should be 'from parent market'
    And 'current market product' tab should be active
    When I switch to 'Economic Calendar'
    Then I am on the 'Economic Calendar' component
    And all the panels parts should be loaded
