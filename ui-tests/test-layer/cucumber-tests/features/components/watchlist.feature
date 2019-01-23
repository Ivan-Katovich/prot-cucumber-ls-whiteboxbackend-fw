@watchlist
Feature: Watchlist panel
  As a user
  I can open watchlist panel
  So all functionality should work fine for the panel

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @delete-watchlist @default-resize-window @watchlist @wt-1337-v14
  Scenario: Watchlist [short]
    #1
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    Then the panel should be visible
    #2
    When I resize panel with:
      | height | 600   |
      | width  | 1000  |
    Then the header of 'Watchlist' panel is 'Watchlists'
    Then text of 'create watchlist button' in watchlist panel should be 'Create new'
    Then close button is available
    Then watchlist panel table header should contain:
      | columnName |
      | Sell       |
      | Buy        |
      | Change     |
      | High       |
      | Low        |
      | Spread     |
    When I enable one click trading
    And I make 'Watchlist' panel active
    Then watchlist panel table header should contain:
      | columnName |
      | Quantity   |
      | Sell       |
      | Buy        |
      | Change     |
      | High       |
      | Low        |
      | Spread     |
    When I disable one click trading
    And I make 'Watchlist' panel active
    #3, 4
    #after 1.23
    #And 'Popular Markets CFD' watchlist should be collapsed
    #When I expand 'Popular Markets CFD' watchlist
    #Then markets of 'Popular Markets CFD' watchlist should be visible
    # And the 'Popular Markets CFD' markets should be ordered by weight
    #When I collapse 'Popular Markets CFD' watchlist
    #Then markets of 'Popular Markets CFD' watchlist should be invisible
    #And 'Popular Markets Spread Bet' watchlist should be collapsed
    #When I expand 'Popular Markets Spread Bet' watchlist
    #Then markets of 'Popular Markets Spread Bet' watchlist should be visible
    # And the 'Popular Markets Spread Bet' markets should be ordered by weight
    #When I collapse 'Popular Markets Spread Bet' watchlist
    #Then markets of 'Popular Markets Spread Bet' watchlist should be invisible

    And 'Popular Markets' watchlist should be collapsed
    And the 'Popular Markets' watchlist should be on the 'top' position
    When I expand 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    When I collapse 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be invisible
    #5
    When I create 'default' watchlist
    Then the 'New Watchlist 1' watchlist should be visible
    Then the 'New Watchlist 1' watchlist should be on the 'top' position
    Then 'New Watchlist 1' watchlist should be expanded
    Then 'New Watchlist 1' watchlist should be empty and contain text 'This watchlist is empty. To add an instrument, use the 'Add to watchlist' feature.'
    When I delete 'New Watchlist 1' watchlist
    Then watchlists count should be '1'
    #6
    When I create 'x' watchlist
    Then the 'x' watchlist should be visible
    Then the 'x' watchlist should be on the 'top' position
    #7
    When I create 'x' watchlist without submitting action
    # looks like small typo in manual test-case: "The watchlist name is taken.." - not the same in on UI
    Then text of 'error message' in watchlist panel should be 'That watchlist name is taken. Please choose another name.'
    When I create 'X' watchlist without submitting action
    Then text of 'error message' in watchlist panel should be 'That watchlist name is taken. Please choose another name.'
    When I create 'Popular Markets' watchlist without submitting action
    #When I create 'Popular Markets CFD' watchlist without submitting action after 1.23
    Then text of 'error message' in watchlist panel should be 'That watchlist name is taken. Please choose another name.'
    When I create 'popular markets' watchlist without submitting action
    #When I create 'popular markets cfd' watchlist without submitting action
    Then text of 'error message' in watchlist panel should be 'That watchlist name is taken. Please choose another name.'
    #8
    When I create 'xz' watchlist without submitting action
    Then the 'error message' element should be invisible on '1'st watchlist
    When I end to edit '1'st watchlist
    #9
    When I hover mouse on '2'nd watchlist
    Then the 'edit button' element should be visible on '2'nd watchlist
    And the 'add to watch list text field' element should be visible on '2'nd watchlist
    And the 'trash icon' element should be visible on '2'nd watchlist
    #10
    When I change the name of 'xz' watchlist to 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' through 'key enter'
    Then the 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' watchlist should be visible
    #11
    When I change the name of 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' watchlist to 'ABC' through 'do not complete'
    And I make 'Watchlist' panel active
    Then the 'ABC' watchlist should be visible
    #12
    When I change the name of 'ABC' watchlist to '' through 'key enter'
    Then the 'ABC' watchlist should be visible
    #13
    When I change the name of 'ABC' watchlist to 'x' through 'do not complete'
    Then text of 'error message' in watchlist panel should be 'That watchlist name is taken. Please choose another name.'
    When I end to edit '1'st watchlist
    Then the 'ABC' watchlist should be visible
    When I change the name of 'ABC' watchlist to 'X' through 'do not complete'
    Then text of 'error message' in watchlist panel should be 'That watchlist name is taken. Please choose another name.'
    When I end to edit '1'st watchlist
    Then the 'ABC' watchlist should be visible
    When I change the name of 'ABC' watchlist to 'Popular Markets' through 'do not complete'
    #When I change the name of 'ABC' watchlist to 'Popular Markets Spread Bet' through 'do not complete'
    Then text of 'error message' in watchlist panel should be 'That watchlist name is taken. Please choose another name.'
    When I end to edit '1'st watchlist
    Then the 'ABC' watchlist should be visible
    When I change the name of 'ABC' watchlist to 'popular markets' through 'do not complete'
    #When I change the name of 'ABC' watchlist to 'popular markets spread bet' through 'do not complete'
    Then text of 'error message' in watchlist panel should be 'That watchlist name is taken. Please choose another name.'
    When I end to edit '1'st watchlist
    Then the 'ABC' watchlist should be visible
    #14
    When I change the name of 'ABC' watchlist to 'xz' through 'do not complete'
    Then the 'error message' element should be invisible on '1'st watchlist
    When I end to edit '1'st watchlist
    Then the 'xz' watchlist should be visible
    #15 removing focus
    When I change the name of 'xz' watchlist to 'x' through 'do not complete'
    Then text of 'error message' in watchlist panel should be 'That watchlist name is taken. Please choose another name.'
    When I make 'Watchlist' panel active
    Then the 'xz' watchlist should be visible
    #16
    When I hover mouse on '1'st watchlist
    And I start to edit '1'st watchlist
    And I hover mouse on '2'nd watchlist
    And I start to edit '2'nd watchlist
    Then the 'edit input' element should be visible on '2'nd watchlist
    And the 'edit input' element should be invisible on '1'st watchlist
    When I end to edit '2'nd watchlist
    #17, 18
    Then watchlists count should be '3'
    When I delete 'xz' watchlist
    And the 'undo icon' element should be visible on '1'st watchlist
    Then the 'xz' watchlist should be invisible
    Then watchlists count should be '2'
    #19
    When I delete 'x' watchlist
    And I undo '1'st watchlist removal
    Then the 'x' watchlist should be visible
    Then watchlists count should be '2'
    #20
    When I create 'Test' watchlist
    Then the 'Test' watchlist should be visible
    When I collapse 'x' watchlist
    When I hover mouse on 'x' watchlist
    And the 'add to watch list text field' element should be visible on 'x' watchlist
    When I hover mouse on 'Test' watchlist
    And the 'add to watch list text field' element should be invisible on 'x' watchlist
    When I expand 'x' watchlist
    And the 'add to watch list text field' element should be visible on 'x' watchlist
    When I hover mouse on 'Test' watchlist
    And the 'add to watch list text field' element should be visible on 'x' watchlist
    When I delete 'Test' watchlist
    Then watchlists count should be '2'
    #21
    When I type 'U' name of market in 'x' watchlist
    Then the 'market from dropdown' element should be invisible on 'x' watchlist
    When I type 'US' name of market in 'x' watchlist
    Then the 'market from dropdown' element should be invisible on 'x' watchlist
    When I type 'USD' name of market in 'x' watchlist
    Then the 'market from dropdown' element should be visible on 'x' watchlist
    #22
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    #23
    When I collapse 'x' watchlist
    When I hover mouse on 'x' watchlist
    And the 'add to watch list text field' element should be visible on 'x' watchlist
    When I type 'USD' name of market in 'x' watchlist
    Then the 'market from dropdown' element should be visible on 'x' watchlist
    # "...Additional scrollbars do not appear, " is not automated
    #25 hovering on market from custom watchlist
    When I expand 'x' watchlist
    When I click on 'dropdown arrow' in the '1'st market
    Then the options from expanded dropdown should be:
      | Market 360 Chart, news, market information |
      | Chart                                      |
      | Set Price Alert                            |
      | Remove from watch list                     |
      | Buy Trade                                  |
      | Sell Trade                                 |
    When I select 'Market 360 Chart, news, market information' in dropdown menu in '1'st market
    Then 'current market product' tab should be active
    When I switch to 'New workspace 2' workspace tab
    Then the 'Watchlist' panel should be visible
    Then markets of 'x' watchlist should be visible
    And I complete '1'st market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    Then the header of 'Chart' panel is 'current market'
    When I close 'Chart' panel
    When I make 'Watchlist' panel active
    Then markets of 'x' watchlist should be visible
    And I complete '1'st market dropdown with value 'Set price alert'
    Then the 'Deal ticket' panel should be visible
    And 'Set Alert' ticket type should be 'selected'
    When I close panel
    When I make 'Watchlist' panel active
    Then markets of 'x' watchlist should be visible
    And I complete 'current' market dropdown with value 'Remove from watch list'
    Then the 'current' market is invisible
    When I collapse 'x' watchlist
    #24 hovering on market from "Popular..." watchlist
    When I expand 'Popular Markets' watchlist
    #When I expand 'Popular Markets Spread Bet' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    #Then markets of 'Popular Markets Spread Bet' watchlist should be visible
    When I click on 'dropdown arrow' in the '1'st market
    Then the options from expanded dropdown should be:
      | Market 360 Chart, news, market information |
      | Chart                                      |
      | Set Price Alert                            |
      | Buy Trade                                  |
      | Sell Trade                                 |
    When I select 'Market 360 Chart, news, market information' in dropdown menu in '1'st market
    Then 'current market product' tab should be active
    When I switch to 'New workspace 2' workspace tab
    Then the 'Watchlist' panel should be visible
    When I resize panel with:
      | height | 600   |
      | width  | 1000  |
    Then markets of 'Popular Markets' watchlist should be visible
    And I complete '1'st market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    Then the header of 'Chart' panel is 'current market'
    When I close 'Chart' panel
    When I make 'Watchlist' panel active
    Then markets of 'Popular Markets' watchlist should be visible
    #Then markets of 'Popular Markets Spread Bet' watchlist should be visible
    And I complete '1'st market dropdown with value 'Set price alert'
    Then the 'Deal ticket' panel should be visible
    And 'Set Alert' ticket type should be 'selected'
    When I close panel
    When I make 'Watchlist' panel active
    #26 look after 35th step
    #27
    Then markets of 'Popular Markets' watchlist should be visible
    # Then markets of 'Popular Markets Spread Bet' watchlist should be visible
    When I switch off test execution in 'firefox'
    When I perform right click on 'name' in the '1'st market
    Then the options from expanded dropdown should be:
      | Market 360 Chart, news, market information |
      | Chart                                      |
      | Set Price Alert                            |
      | Buy Trade                                  |
      | Sell Trade                                 |
    When I select 'Sell Trade' in dropdown menu in '1'st market
    Then the 'Deal ticket' panel should be visible
    When I close panel
    When I switch on test execution in 'firefox'
    When I make 'Watchlist' panel active
    When I collapse 'Popular Markets' watchlist
    # When I collapse 'Popular Markets Spread Bet' watchlist
    #28
    # reordering doesn't work in safari. following steps are not automated
    When I switch off test execution in 'safari'
    And I expand 'x' watchlist
    When I type 'USD' name of market in 'x' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    And the 'USD' market should be on '1' position in the 'x' watchlist
    When I type 'Wall Street' name of market in 'x' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    And the 'Wall Street' market should be on '2' position in the 'x' watchlist
    When I type 'EUR' name of market in 'x' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    And the 'EUR' market should be on '3' position in the 'x' watchlist
    When I drag and drop '1'st market from 'x' watchlist to '3' market in the 'x' watchlist
    Then the 'USD' market should be on '3' position in the 'x' watchlist
    And the 'EUR' market should be on '2' position in the 'x' watchlist
    And the 'Wall Street' market should be on '1' position in the 'x' watchlist
    #29
    When I expand 'Popular Markets' watchlist
    #When I expand 'Popular Markets CFD' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    #Then markets of 'Popular Markets CFD' watchlist should be visible
    # TODO when 1.23 is deployed (AUD/USD and EUR/JPY ? are CFD market)
    When I remember 'AUD/USD' market position
    And I drag and drop 'AUD/USD' market from 'Popular Markets' watchlist to 'EUR/JPY' market in the 'Popular Markets' watchlist
    #And I drag and drop 'AUD/USD' market from 'Popular Markets CFD' watchlist to 'EUR/JPY' market in the 'Popular Markets CFD' watchlist
    Then the 'AUD/USD' market should be on 'same' position in the 'Popular Markets' watchlist
    When I collapse 'Popular Markets' watchlist
    #30
    When I delete 'x' watchlist
    Then watchlists count should be '1'
    When I create 'abc' watchlist
    When I type 'USD' name of market in 'abc' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    And the 'USD' market should be on '1' position in the 'abc' watchlist
    When I type 'EUR' name of market in 'abc' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    And the 'EUR' market should be on '2' position in the 'abc' watchlist
    When I type 'Spread' name of market in 'abc' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    And the 'Spread' market should be on '3' position in the 'abc' watchlist
    When I create 'def' watchlist
    Then the 'def' watchlist should be visible
    When I type 'GBP' name of market in 'def' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I drag and drop '1'st market from 'abc' watchlist to '1' market in the 'def' watchlist
    Then the 'def' watchlist should contain 'current' market
    And the 'EUR' market should be on '1' position in the 'abc' watchlist
    When I expand 'Popular Markets' watchlist
    When I drag and drop '1'st market from 'abc' watchlist to '1' market in the 'Popular Markets' watchlist
    And the 'abc' watchlist should contain 'current' market
    #31
    When I collapse 'Popular Markets' watchlist
    # When I collapse 'Popular Markets CFD' watchlist
    And I collapse 'abc' watchlist
    When I collapse 'def' watchlist
    Then the 'def' watchlist should be on the '1'st position
    Then the 'abc' watchlist should be on the '2'nd position
    Then the 'Popular Markets' watchlist should be on the '3'rd position
    # Then the 'Popular Markets CFD' watchlist should be on the '3'rd position
    When I drag 'Popular Markets' watchlist and drop to 'def' watchlist
    # When I drag 'Popular Markets CFD' watchlist and drop to 'def' watchlist
    Then the 'Popular Markets' watchlist should be on the '1'st position
    #Then the 'Popular Markets CFD' watchlist should be on the '1'st position
    Then the 'def' watchlist should be on the '2'nd position
    Then the 'abc' watchlist should be on the '3'rd position
    When I switch on test execution in 'safari'
    #32, 33
    When I expand 'Popular Markets' watchlist
    #When I expand 'Popular Markets CFD' watchlist
    Then the '1'st market should be 'black' when it is 'hovered'
    When I hover mouse on Sell price in the '1'st market
    Then the Sell price should be white in the '1'st market
    When I hover mouse on Buy price in the '1'st market
    Then the Buy price should be white in the '1'st market
    When I collapse 'Popular Markets' watchlist
    #When I collapse 'Popular Markets CFD' watchlist
    #26
    When I resize panel with:
      | height | 100  |
      | width  | 600  |
    Then panel should be not scrolled vertically
    When I move panel to the 'bottom of the page'
    And I expand 'Popular Markets' watchlist
    #When I expand 'Popular Markets CFD' watchlist
    When I click on 'dropdown arrow' in the '1'st market
    Then the options from expanded dropdown should be:
      | Market 360 Chart, news, market information |
      | Chart                                      |
      | Set Price Alert                            |
      | Buy Trade                                  |
      | Sell Trade                                 |
    Then dropdown should be opened upwards the '1'st market
    #34, 35
    # "...Additional scrollbars do not appear, " is not automated
    When I scroll to '4'th 'market' in the panel
    Then panel should be scrolled vertically
    When I resize panel with:
      | height | 240  |
      | width  | 600  |
    Then panel should be not scrolled horizontally
    When I scroll to 'spread column' inside 'tabHeader' in the panel
    Then panel should be scrolled horizontally


#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @delete-watchlist @watchlist-panel-main-functionality @no-safari
  Scenario: Watchlist panel main functionality
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    Then the panel should be visible
    When I resize panel with:
      | height | 600   |
      | width  | 1000  |
    Then the header of 'Watchlist' panel is 'Watchlists'
    Then text of 'create watchlist button' in watchlist panel should be 'Create new'
    Then close button is available
    Then watchlist panel table header should contain:
      | columnName |
      | Sell       |
      | Buy        |
      | Change     |
      | High       |
      | Low        |
      | Spread     |
    Then the 'Popular Markets' watchlist should be on the 'top' position
    When I collapse 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be invisible
    When I expand 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    When I create 'default' watchlist
    Then the 'New Watchlist 1' watchlist should be visible
    Then the 'New Watchlist 1' watchlist should be on the 'top' position
    Then 'New Watchlist 1' watchlist should be expanded
    Then 'New Watchlist 1' watchlist should be empty and contain text 'This watchlist is empty. To add an instrument, use the 'Add to watchlist' feature.'
    When I change the name of 'New Watchlist 1' watchlist to 'aa' through 'key enter'
    Then the 'aa' watchlist should be visible
    When I change the name of 'aa' watchlist to 'z' through 'key enter'
    Then the 'z' watchlist should be visible
    When I change the name of 'z' watchlist to 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' through 'key enter'
    Then the 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' watchlist should be visible
    When I change the name of 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' watchlist to 'abc' through 'key enter'
    Then the 'abc' watchlist should be visible
    Then the 'abc' watchlist should be on the 'top' position
    When I create 'de' watchlist
    Then the 'de' watchlist should be visible
    Then the 'de' watchlist should be on the 'top' position
    When I create 'g' watchlist
    Then the 'g' watchlist should be visible
    Then the 'g' watchlist should be on the 'top' position
    When I create 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' watchlist
    Then the 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' watchlist should be visible
    Then the 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' watchlist should be on the 'top' position
    And I delete 'Lorem ipsum dolor sit amet, usu ei aliquid reprimique' watchlist
    When I wait for '5000'
    And the 'edit button' element should be invisible on 'abc' watchlist
    When I hover mouse on 'abc' watchlist
    And the 'edit button' element should be visible on 'abc' watchlist
    When I change the name of 'abc' watchlist to 'cba' through 'key enter'
    Then the 'abc' watchlist should be invisible
    Then the 'cba' watchlist should be visible
    When I change the name of 'cba' watchlist to 'abc' through 'click away from the field'
    Then the 'cba' watchlist should be invisible
    Then the 'abc' watchlist should be visible
    When I change the name of 'abc' watchlist to '' through 'key enter'
    Then the 'abc' watchlist should be visible
    And I hover mouse on '2'nd watchlist
    And I start to edit '2'nd watchlist
    And I hover mouse on '3'rd watchlist
    And I start to edit '3'rd watchlist
    Then the 'edit input' element should be visible on '3'rd watchlist
    And the 'edit input' element should be invisible on '2'nd watchlist
    When I end to edit '3'nd watchlist
    Then watchlists count should be '4'
    And I delete 'g' watchlist
    And the 'undo icon' element should be visible on '1'st watchlist
    Then watchlists count should be '3'
    When I delete 'abc' watchlist
    And I undo '2'nd watchlist removal
    And I wait for '5000'
    Then the 'abc' watchlist should be visible
    When I expand 'abc' watchlist
    Then the 'add to watch list text field' element should be visible on 'abc' watchlist
    And the 'trash icon' element should be visible on 'abc' watchlist
    When I collapse 'abc' watchlist
    When I hover mouse on 'de' watchlist
    Then the 'add to watch list text field' element should be invisible on 'abc' watchlist
    And the 'trash icon' element should be invisible on 'abc' watchlist
    When I hover mouse on 'abc' watchlist
    Then the 'add to watch list text field' element should be visible on 'abc' watchlist
    And the 'trash icon' element should be visible on 'abc' watchlist
    When I expand 'abc' watchlist
    When I type 'U' name of market in 'abc' watchlist
    Then the 'market from dropdown' element should be invisible on 'abc' watchlist
    When I type 'US' name of market in 'abc' watchlist
    Then the 'market from dropdown' element should be invisible on 'abc' watchlist
    When I type 'USD' name of market in 'abc' watchlist
    Then the 'market from dropdown' element should be visible on 'abc' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    Then the '1'st market should be 'black' when it is 'hovered'
    When I hover mouse on Sell price in the '1'st market
    Then the Sell price should be white in the '1'st market
    When I hover mouse on Buy price in the '1'st market
    Then the Buy price should be white in the '1'st market
    Then the 'current' market 'change' should be visible
    Then the 'current' market 'low' should be visible
    Then the 'current' market 'spread' should be visible
    When I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    Then trade direction should be 'sell'
    When I make 'Watchlist' panel active
    Then 'abc' watchlist should be expanded
    When I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    Then trade direction should be 'buy'
    When I make 'Watchlist' panel active
    When I create 'default' watchlist
    Then the 'New Watchlist 3' watchlist should be on the 'top' position
    When I create 'default' watchlist
    Then the 'New Watchlist 4' watchlist should be on the 'top' position
    When I create 'default' watchlist
    Then the 'New Watchlist 5' watchlist should be on the 'top' position

  @delete-watchlist @watchlist-panel-main-functionality
  Scenario: Watchlist panel dropdown menu
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    Then the panel should be visible
    When I resize panel with:
      | height | 600   |
      | width  | 1000  |
    When I expand 'Popular Markets' watchlist
    Then markets of 'Popular Markets' watchlist should be visible
    When I click on 'dropdown arrow' in the '1'st market
    Then the options from expanded dropdown should be:
      | Market 360 Chart, news, market information |
      | Chart                                      |
      | Set Price Alert                            |
      | Buy Trade                                  |
      | Sell Trade                                 |
    When I select 'Market 360 Chart, news, market information' in dropdown menu in '1'st market
    Then 'current market product' tab should be active
    When I switch to 'New workspace 2' workspace tab
    Then the 'Watchlist' panel should be visible
    Then markets of 'Popular Markets' watchlist should be visible
    And I complete '1'st market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    Then the header of 'Chart' panel is 'current market'
    When I close 'Chart' panel
    When I make 'Watchlist' panel active
    Then markets of 'Popular Markets' watchlist should be visible
    And I complete '1'st market dropdown with value 'Set price alert'
    Then the 'Deal ticket' panel should be visible
    And 'Set Alert' ticket type should be 'selected'
    When I close panel
    When I make 'Watchlist' panel active
    When I create 'abc' watchlist
    Then the 'abc' watchlist should be visible
    When I type 'USD' name of market in 'abc' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I click on 'dropdown arrow' in the 'current' market
    Then the options from expanded dropdown should be:
      | Market 360 Chart, news, market information |
      | Chart                                      |
      | Set Price Alert                            |
      | Remove from watch list                     |
      | Buy Trade                                  |
      | Sell Trade                                 |
    When I select 'Market 360 Chart, news, market information' in dropdown menu in 'current' market
    Then 'current market product' tab should be active
    When I switch to 'New workspace 2' workspace tab
    Then the 'Watchlist' panel should be visible
    When I expand 'abc' watchlist
    Then the 'previously added' market is visible
    And I complete 'current' market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    Then the header of 'Chart' panel is 'current market'
    When I close 'Chart' panel
    When I make 'Watchlist' panel active
    Then markets of 'abc' watchlist should be visible
    And I complete 'current' market dropdown with value 'Set price alert'
    Then the 'Deal ticket' panel should be visible
    And 'Set Alert' ticket type should be 'selected'
    When I close panel
    When I make 'Watchlist' panel active
    Then markets of 'abc' watchlist should be visible
    And I complete 'current' market dropdown with value 'Remove from watch list'
    Then the 'current' market is invisible

  @delete-watchlist @watchlist-panel-reorder @no-safari
  Scenario: Watchlist panel reorder
    Then the 'Watchlist' panel should be visible
    Then markets of 'Popular Markets' watchlist should be visible
    When I remember 'AUD/USD' market position
    And I drag and drop 'AUD/USD' market from 'Popular Markets' watchlist to 'EUR/JPY' market in the 'Popular Markets' watchlist
    Then the 'AUD/USD' market should be on 'same' position in the 'Popular Markets' watchlist
    When I create 'abc' watchlist
    When I type 'USD' name of market in 'abc' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    And the 'USD' market should be on '1' position in the 'abc' watchlist
    When I type 'EUR' name of market in 'abc' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    And the 'EUR' market should be on '2' position in the 'abc' watchlist
    When I type 'Spread' name of market in 'abc' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    And the 'Spread' market should be on '3' position in the 'abc' watchlist
    When I drag and drop '1'st market from 'abc' watchlist to '3' market in the 'abc' watchlist
    Then the 'USD' market should be on '3' position in the 'abc' watchlist
    And the 'Spread' market should be on '2' position in the 'abc' watchlist
    And the 'EUR' market should be on '1' position in the 'abc' watchlist
    When I create 'def' watchlist
    Then the 'def' watchlist should be visible
    When I type 'GBP' name of market in 'def' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I drag and drop '1'st market from 'abc' watchlist to '1' market in the 'def' watchlist
    Then the 'def' watchlist should contain 'current' market
    And the 'Spread' market should be on '1' position in the 'abc' watchlist
    When I drag and drop '1'st market from 'abc' watchlist to '1' market in the 'Popular Markets' watchlist
    And the 'abc' watchlist should contain 'current' market
    When I collapse 'def' watchlist
    When I collapse 'abc' watchlist
    When I collapse 'Popular Markets' watchlist
    Then the 'def' watchlist should be on the '1'st position
    Then the 'abc' watchlist should be on the '2'nd position
    Then the 'Popular Markets' watchlist should be on the '3'rd position
    When I drag 'Popular Markets' watchlist and drop to 'def' watchlist
    Then the 'Popular Markets' watchlist should be on the '1'st position
    Then the 'def' watchlist should be on the '2'nd position
    Then the 'abc' watchlist should be on the '3'rd position
    When I drag 'Popular Markets' watchlist and drop to 'def' watchlist
    Then the 'def' watchlist should be on the '1'st position
    Then the 'Popular Markets' watchlist should be on the '2'nd position
    Then the 'abc' watchlist should be on the '3'rd position
    When I create 'empty' watchlist
    When I collapse 'empty' watchlist
    Then the 'empty' watchlist should be on the '1'st position
    When I drag 'empty' watchlist and drop to 'Popular Markets' watchlist
    Then the 'empty' watchlist should be on the '3'rd position
    When I drag 'empty' watchlist and drop to 'abc' watchlist
    Then the 'empty' watchlist should be on the '4'th position
    When I expand 'def' watchlist
    When I drag and drop '1'st market from 'def' watchlist to 'outside' of the 'panel' watchlist
    Then the 'def' watchlist should contain 'current' market
#    When I drag and drop '1'st market from 'def' watchlist to 'root' of the 'abc' watchlist
#    Then 'abc' watchlist should be expanded
#    And the 'EUR' market should be on '1'st position in the 'abc' watchlist
#    will be uncomment after implementation

  @watchlist-popular-markets
  Scenario: Watchlist Popular Markets
    Then the 'Watchlist' panel should be visible
    Then markets of 'Popular Markets' watchlist should be visible
    Then 'Popular Markets' watchlist should be expanded
    When I hover mouse on 'Popular Markets' watchlist
    Then the 'trash icon' element should be invisible on 'Popular Markets' watchlist
    And the 'edit button' element should be invisible on 'Popular Markets' watchlist
    And the 'Popular Markets' watchlist should return the same markets as backend request
    And the PopularMarkets watchlist's markets should be ordered by 'Weighting'
    When I collapse 'Popular Markets' watchlist
    Then 'Popular Markets' watchlist should be collapsed
    Then markets of 'Popular Markets' watchlist should be invisible
    When I expand 'Popular Markets' watchlist
    Then 'Popular Markets' watchlist should be expanded
    Then markets of 'Popular Markets' watchlist should be visible
    Then the '1'st market 'sell' should be visible
    Then the '1'st market 'buy' should be visible
    Then the '1'st market 'change' should be visible
    Then the '1'st market 'low' should be visible
    Then the '1'st market 'spread' should be visible
    When I click on 'sell' in the '1'st market
    Then the 'Deal ticket' panel should be visible
    Then trade direction should be 'sell'
    When I close panel
    When I make 'Watchlist' panel active
    Then markets of 'Popular Markets' watchlist should be visible
    When I click on 'buy' in the '1'st market
    Then the 'Deal ticket' panel should be visible
    Then trade direction should be 'buy'
    When I close panel
    When I make 'Watchlist' panel active
    Then markets of 'Popular Markets' watchlist should be visible
    # Closed markets can be not displayed in Popular markets watchlist
    And I create 'market statuses' watchlist
    And I find market with 'closed' status
    And I type 'closed' name of market
    Then the 'market from dropdown' element should be visible on '1'nd watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I click on 'sell' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    Then trade direction should be 'sell'
    And 'order' ticket type should be 'selected'

  @delete-watchlist @watchlist-state-persisted
  Scenario: Watchlist state persisted
    Then the 'Watchlist' panel should be visible
    When I collapse 'Popular Markets' watchlist
    When I create 'abc' watchlist
    When I collapse 'abc' watchlist
    When I create 'def' watchlist
    When I collapse 'def' watchlist
    When I create 'ghi' watchlist
    Then 'ghi' watchlist should be expanded
    Then the 'ghi' watchlist should be on the '1'st position
    Then the 'def' watchlist should be on the '2'nd position
    Then the 'abc' watchlist should be on the '3'rd position
    Then the 'Popular Markets' watchlist should be on the '4'th position
    When I relogin to the application
    Then the 'Watchlist' panel should be visible
    # https://jira.gaincapital.com/browse/TPDWT-11436
    Then 'ghi' watchlist should be expanded
    Then 'def' watchlist should be collapsed
    Then 'abc' watchlist should be collapsed
    Then 'Popular Markets' watchlist should be collapsed
    Then the 'ghi' watchlist should be on the '1'st position
    Then the 'def' watchlist should be on the '2'nd position
    Then the 'abc' watchlist should be on the '3'rd position
    Then the 'Popular Markets' watchlist should be on the '4'th position



