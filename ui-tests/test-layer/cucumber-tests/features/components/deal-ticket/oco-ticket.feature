@ocoticket
Feature: OCO Order Ticket panel
  As a user
  I can open oco order ticket panel
  So all functionality should work fine for the panel

  Background:
    Given I am logged in to the application with default state

  @regression @USD/JPY @oco-ticket-standard-view @wt-840-v9
  Scenario: OCO Ticket Standard View
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    #2
    When I switch to 'order' tab
    Then trade direction should be 'buy'
    #3
    When I click on 'oco' link
    Then trade direction should be 'buy'
    And 'market info' element text should be 'USD/JPY'
    And the order ticket standard view panel should contain items:
      | itemName                  |
      | ticket form clarification |
      | oco link                  |
    And 'ticket form clarification' element text should be 'These orders are linked. When one is executed the other will be cancelled.'
    And the 'main' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    And 'main good till dropdown' element should be enabled
    And the 'oco' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    And 'oco good till dropdown' element should be disabled
    And the main '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | price         |
      | pips/points   |
      | p/l           |
    And the main '2'nd limit order should contain fields:
      | itemName      |
      | checkbox      |
      | label         |
      | price         |
      | pips/points   |
      | p/l           |
    And the oco '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | price         |
      | pips/points   |
      | p/l           |
    And the oco '2'nd limit order should contain fields:
      | itemName      |
      | checkbox      |
      | label         |
      | price         |
      | pips/points   |
      | p/l           |
    And the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    And the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled
    And the oco '1'st normal stop linked order 'price' element should be disabled
    And the oco '1'st normal stop linked order 'points' element should be disabled
    And the oco '1'st normal stop linked order 'p/l' element should be disabled
    And the oco '2'nd limit linked order 'price' element should be disabled
    And the oco '2'nd limit linked order 'points' element should be disabled
    And the oco '2'nd limit linked order 'p/l' element should be disabled
    And 'oco link' element text should be 'Remove OCO'
    #4#5
    When I click on 'oco' link
    Then 'oco link' element text should be 'Add OCO'
    When I click on 'sell' label
    Then trade direction should be 'sell'
    When I click on 'oco' link
    Then trade direction should be 'sell'
    When I click on 'buy' label
    #6
    When I check main 'stop' checkbox
    And I check main 'limit' checkbox
    And I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    Then the main '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | price         |
      | pips/points   |
      | p/l           |
    And the main '2'nd limit order should contain fields:
      | itemName      |
      | checkbox      |
      | label         |
      | price         |
      | pips/points   |
      | p/l           |
    And the oco '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | price         |
      | pips/points   |
      | p/l           |
    And the oco '2'nd limit order should contain fields:
      | itemName      |
      | checkbox      |
      | label         |
      | price         |
      | pips/points   |
      | p/l           |
    And the main '1'st normal stop linked order 'price' element should be enabled
    And the main '1'st normal stop linked order 'points' element should be enabled
    And the main '1'st normal stop linked order 'p/l' element should be enabled
    And the main '2'nd limit linked order 'price' element should be enabled
    And the main '2'nd limit linked order 'points' element should be enabled
    And the main '2'nd limit linked order 'p/l' element should be enabled
    And the oco '1'st normal stop linked order 'price' element should be enabled
    And the oco '1'st normal stop linked order 'points' element should be enabled
    And the oco '1'st normal stop linked order 'p/l' element should be enabled
    And the oco '2'nd limit linked order 'price' element should be enabled
    And the oco '2'nd limit linked order 'points' element should be enabled
    And the oco '2'nd limit linked order 'p/l' element should be enabled
    #7
    When I fill main 'quantity' with value '1000'
    And I fill main 'order price' with value '90'
    And I fill oco 'quantity' with value '1000'
    And I fill oco 'order price' with value '130'
    And I fill the main '1'st normal stop linked order 'price' with value '80' in the 'current market'
    And I fill the main '2'nd limit linked order 'price' with value '100' in the 'current market'
    And I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '140' in the 'current market'
    And 'submit button' element should be enabled
    #8
    When I click on 'sell' label
    Then 'submit button' element should be disabled
    When I click on 'buy' label
    Then 'submit button' element should be enabled
    #9
    When I click on 'submit' button
    And I click on 'ok' button after waiting
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    Then '2' 'previously added' orders should be on the list
    #10
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    And 'submit button' element should be disabled
    #11
    When I fill main 'order price' with value '95'
    Then 'submit button' element should be enabled
    #12
    When I click on 'submit' button
    And I click on 'ok' button after waiting
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    Then the '1'st order 'order price' cell should contain '95.000' data
    #13
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    And 'submit button' element should be disabled
    When I fill main 'quantity' with value '1200'
    Then 'submit button' element should be enabled
    When I fill main 'quantity' with value '1000'
    Then 'submit button' element should be disabled
    When I fill oco 'order price' with value '135'
    Then 'submit button' element should be enabled
    When I fill oco 'order price' with value '130'
    Then 'submit button' element should be disabled
    When I fill oco 'quantity' with value '1200'
    Then 'submit button' element should be enabled
    When I fill oco 'quantity' with value '1000'
    Then 'submit button' element should be disabled
    When I fill the main '1'st normal stop linked order 'price' with value '85' in the 'current market'
    Then 'submit button' element should be enabled
    When I fill the main '1'st normal stop linked order 'price' with value '80' in the 'current market'
    Then 'submit button' element should be disabled
    When I fill the main '2'nd limit linked order 'price' with value '105' in the 'current market'
    Then 'submit button' element should be enabled
    When I fill the main '2'nd limit linked order 'price' with value '100' in the 'current market'
    Then 'submit button' element should be disabled
    When I fill the oco '1'st normal stop linked order 'price' with value '125' in the 'current market'
    Then 'submit button' element should be enabled
    When I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    Then 'submit button' element should be disabled
    When I fill the oco '2'nd limit linked order 'price' with value '145' in the 'current market'
    Then 'submit button' element should be enabled
    When I fill the oco '1'st limit linked order 'price' with value '140' in the 'current market'
    Then 'submit button' element should be disabled
    #14
    When I uncheck main 'stop' checkbox
    And I uncheck main 'limit' checkbox
    And I uncheck oco 'stop' checkbox
    And I uncheck oco 'limit' checkbox
    And I click on the '1'st main normal stop linked order 'price' field
    Then the main '1'st normal stop linked order 'price' element should be enabled
    And the main '1'st normal stop linked order 'points' element should be enabled
    And the main '1'st normal stop linked order 'p/l' element should be enabled
    When I click on the '2'nd main limit linked order 'points' field
    Then the main '2'nd limit linked order 'price' element should be enabled
    And the main '2'nd limit linked order 'points' element should be enabled
    And the main '2'nd limit linked order 'p/l' element should be enabled
    When I click on the '1'st oco normal stop linked order 'p/l' field
    Then the oco '1'st normal stop linked order 'price' element should be enabled
    And the oco '1'st normal stop linked order 'points' element should be enabled
    And the oco '1'st normal stop linked order 'p/l' element should be enabled
    When I click on the '2'nd oco limit linked order 'points' field
    Then the oco '2'nd limit linked order 'price' element should be enabled
    And the oco '2'nd limit linked order 'points' element should be enabled
    And the oco '2'nd limit linked order 'p/l' element should be enabled


  @regression @USD/JPY @oco-order-multiple-stops-and-limits-view @wt-914-v3
  Scenario: OCO Order - Multiple Stops and Limits View
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    #2
    When I switch to 'order' tab
    Then trade direction should be 'buy'
    #3
    When I click on 'oco' link
    Then the 'main' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    And the 'oco' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    #4
    When I click on main 'advancedTicket' link
    And I click on oco 'advancedTicket' link
    Then the main '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | points        |
      | p/l           |
      | applicability |
    And the main '2'nd limit order should contain fields:
      | itemName      |
      | checkbox      |
      | label         |
      | quantity      |
      | price         |
      | points        |
      | p/l           |
      | applicability |
    And the order ticket advanced view panel should contain items:
      | itemName                     |
      | order price                  |
      | quantity                     |
      | good till dropdown           |
      | add stop limit dropdown link |
      | hedging toggle               |
      | hedging info icon            |
      | standard ticket link         |
    #5
    When I hover main order 'hedging info icon' element
    Then trade ticket 'hedging tooltip' element is visible
    #6 skipped
    #7
    When I expand main add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    Then the number of linked orders should be '5'
    When I expand main add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    Then the number of linked orders should be '6'
    When I expand main add stop limit dropdown
    And I select 'limit' from expanded dropdown
    Then the number of linked orders should be '7'
    When I check main 'stop' checkbox
    And I check main 'limit' checkbox
    Then the main '1'st normal stop linked order 'price' element should be enabled
    And the main '2'nd limit linked order 'price' element should be enabled
    And 'submit button' element text should be 'Choose quantity'
    #8
    When I expand oco add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    Then the number of linked orders should be '8'
    When I expand oco add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    Then the number of linked orders should be '9'
    When I expand oco add stop limit dropdown
    And I select 'limit' from expanded dropdown
    Then the number of linked orders should be '10'
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    Then the oco '1'st normal stop linked order 'price' element should be enabled
    And the oco '2'nd limit linked order 'price' element should be enabled
    And 'submit button' element text should be 'Choose quantity'
    #9
    When I fill main 'quantity' with value '5000'
    And I fill oco 'quantity' with value '5000'
    And I fill the main '1'st normal stop linked order 'quantity' with value '1100' in the 'current market'
    And I fill the main '2'nd limit linked order 'quantity' with value '1100' in the 'current market'
    And I fill the main '3'rd normal stop linked order 'quantity' with value '1100' in the 'current market'
    And I fill the main '4'th trailing stop linked order 'quantity' with value '1100' in the 'current market'
    And I fill the main '5'th limit linked order 'quantity' with value '1100' in the 'current market'
    And I fill the oco '1'st normal stop linked order 'quantity' with value '1100' in the 'current market'
    And I fill the oco '2'nd limit linked order 'quantity' with value '1100' in the 'current market'
    And I fill the oco '3'rd normal stop linked order 'quantity' with value '1100' in the 'current market'
    And I fill the oco '4'th trailing stop linked order 'quantity' with value '1100' in the 'current market'
    And I fill the oco '5'th limit linked order 'quantity' with value '1100' in the 'current market'
    And 'submit button' element text should be 'Enter a price'
    #10
    When I fill main 'order price' with value '90'
    And I fill oco 'order price' with value '130'
    Then 'submit button' element text should be 'Choose stop and limit levels'
    #11
    When I fill the main '1'st normal stop linked order 'price' with value '85' in the 'current market'
    And I fill the main '2'nd limit linked order 'price' with value '95' in the 'current market'
    And I fill the main '3'rd normal stop linked order 'price' with value '80' in the 'current market'
    And I fill the main '4'th trailing stop linked order 'points' with value '100' in the 'current market'
    And I fill the main '5'th limit linked order 'price' with value '100' in the 'current market'
    And I fill the oco '1'st normal stop linked order 'price' with value '125' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '135' in the 'current market'
    And I fill the oco '3'rd normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '4'th trailing stop linked order 'points' with value '100' in the 'current market'
    And I fill the oco '5'th limit linked order 'price' with value '140' in the 'current market'
    Then 'submit button' element text should be 'Place Order'
    #12
    When I click on 'submit' button
    Then 'ok button' element should be enabled
    #13
    When I hover main order 'hedging info icon' element
    Then trade ticket 'hedging tooltip' element is visible


  @regression @oco-order-sell-stop/limit-buy-original-order-cfd-market @wt-123-v6
  Scenario: OCO Order - Sell - Stop/Limit - Buy Original Order - CFD Market
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    #2
    When I switch to 'order' tab
    Then trade direction should be 'buy'
    #3#4
    When I fill main 'order price' with value '90'
    And I fill main 'quantity' with value '1000'
    Then 'submit button' element text should be 'Place Order'
    #5
    Then 'main good till dropdown' element text should be 'Good 'til canceled (GTC)'
    #6
    When I check 'stop' checkbox
    And I check 'limit' checkbox
    And I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    And the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled
    #7
    When I check 'stop' checkbox
    And I check 'limit' checkbox
    And I fill the main '1'st normal stop linked order 'price' with value '100' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the main '1'st normal stop linked order 'p/l' input should be autopopulated
    #8
    When I fill the main '2'nd limit linked order 'price' with value '80' in the 'current market'
    Then the main '2'nd limit linked order 'pips/points' input should be autopopulated
    And the main '2'nd limit linked order 'p/l' input should be autopopulated
    #9
    And 'buy' price should change with time
    And the main '1'st normal stop linked order 'p/l' input should be autopopulated
    And the main '2'nd limit linked order 'p/l' input should be autopopulated
    #10
    When I click on 'oco' link
    Then the 'main' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    And the 'oco' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    #11
    When I click on 'sell' label
    Then trade direction should be 'sell'
    #12 #13
    When I fill oco 'quantity' with value '1000'
    And I fill oco 'order price' with value '130'
    Then 'submit button' element text should be 'Place Order'
    #14
    And 'main good till dropdown' element text should be 'Good 'til canceled (GTC)'
    And 'oco good till dropdown' element text should be 'Good 'til canceled (GTC)'
    #15
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '140' in the 'current market'
    And I uncheck oco 'stop' checkbox
    And I uncheck oco 'limit' checkbox
    Then the oco '1'st normal stop linked order 'price' element should be disabled
    And the oco '1'st normal stop linked order 'points' element should be disabled
    And the oco '1'st normal stop linked order 'p/l' element should be disabled
    And the oco '2'nd limit linked order 'price' element should be disabled
    And the oco '2'nd limit linked order 'points' element should be disabled
    And the oco '2'nd limit linked order 'p/l' element should be disabled
    #16
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    Then the oco '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the oco '1'st normal stop linked order 'p/l' input should be autopopulated
    #17
    When I fill the oco '2'nd limit linked order 'price' with value '140' in the 'current market'
    Then the oco '2'nd limit linked order 'pips/points' input should be autopopulated
    And the oco '2'nd limit linked order 'p/l' input should be autopopulated
    #18
    And 'sell' price should change with time
    And the oco '1'st normal stop linked order 'p/l' input should be autopopulated
    And the oco '2'nd limit linked order 'p/l' input should be autopopulated
    #19
    When I click on 'submit' button
    Then 'oco order' confirmation message should be correct
    #20
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #21
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then '2' 'previously added' orders should be on the list
    And the '1'st order 'direction' cell should contain 'sell' word
    And the '1'st order 'quantity' cell should contain '1000' data
    And the '1'st order 'order price' cell should contain '90.000' data
    And the '1'st order 'stop price' cell should contain '100.000' data
    And the '1'st order 'limit price' cell should contain '80.000' data
    And the '2'nd order 'direction' cell should contain 'buy' word
    And the '2'nd order 'quantity' cell should contain '1000' data
    And the '2'nd order 'order price' cell should contain '130.000' data
    And the '2'nd order 'stop price' cell should contain '120.000' data
    And the '2'nd order 'limit price' cell should contain '140.000' data
    #22 skipped
    #23
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    And max allowed symbols in main 'quantity' field should be '15'
    And max allowed symbols in main 'order price' field should be '15'
    And max allowed symbols in the main '1'st normal stop linked order 'price' should be '15'
    And max allowed symbols in the main '1'st normal stop linked order 'points' should be '15'
    And max allowed symbols in the main '1'st normal stop linked order 'p/l' should be '15'
    And max allowed symbols in the main '2'nd limit linked order 'price' should be '15'
    And max allowed symbols in the main '2'nd limit linked order 'points' should be '15'
    And max allowed symbols in the main '2'nd limit linked order 'p/l' should be '15'
    And max allowed symbols in oco 'quantity' field should be '15'
    And max allowed symbols in oco 'order price' field should be '15'
    And max allowed symbols in the oco '1'st normal stop linked order 'price' should be '15'
    And max allowed symbols in the oco '1'st normal stop linked order 'points' should be '15'
    And max allowed symbols in the oco '1'st normal stop linked order 'p/l' should be '15'
    And max allowed symbols in the oco '2'nd limit linked order 'price' should be '15'
    And max allowed symbols in the oco '2'nd limit linked order 'points' should be '15'
    And max allowed symbols in the oco '2'nd limit linked order 'p/l' should be '15'
    #24
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I uncheck main 'stop' checkbox
    And I uncheck main 'limit' checkbox
    And I uncheck oco 'stop' checkbox
    And I uncheck oco 'limit' checkbox
    And I click on 'submit' button
    And I click on the '1'st main normal stop linked order 'price' field
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    When I click on the '2'nd main limit linked order 'points' field
    Then the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled


  @regression @oco-order-sell-stop/limit-buy-original-order-spread-market @wt-126-v6
  Scenario: OCO Order - Sell - Stop/Limit - Buy Original Order - Spread Market
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'GBP/USD DFT' market
    Then the 'Deal ticket' panel should be visible
    #2
    When I switch to 'order' tab
    Then trade direction should be 'buy'
    #3#4
    When I fill main 'order price' with value '1'
    And I fill main 'quantity' with value '2'
    Then 'submit button' element text should be 'Place Order'
    #5
    And 'main good till dropdown' element text should be 'Good 'til canceled (GTC)'
    #6
    When I check 'stop' checkbox
    And I check 'limit' checkbox
    And I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    And the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled
    #7
    When I check 'stop' checkbox
    And I check 'limit' checkbox
    And I fill the main '1'st normal stop linked order 'price' with value '1.1' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the main '1'st normal stop linked order 'p/l' input should be autopopulated
    #8
    When I fill the main '2'nd limit linked order 'price' with value '0.9' in the 'current market'
    Then the main '2'nd limit linked order 'pips/points' input should be autopopulated
    And the main '2'nd limit linked order 'p/l' input should be autopopulated
    #9
    And 'buy' price should change with time
    And the main '1'st normal stop linked order 'p/l' input should be autopopulated
    And the main '2'nd limit linked order 'p/l' input should be autopopulated
    #10
    When I click on 'oco' link
    Then the 'main' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    And the 'oco' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    #11
    When I click on 'sell' label
    Then trade direction should be 'sell'
    #12 #13
    When I fill oco 'quantity' with value '2'
    And I fill oco 'order price' with value '1.5'
    Then 'submit button' element text should be 'Place Order'
    #14
    And 'main good till dropdown' element text should be 'Good 'til canceled (GTC)'
    And 'oco good till dropdown' element text should be 'Good 'til canceled (GTC)'
    #15
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '1.4' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '1.6' in the 'current market'
    And I uncheck oco 'stop' checkbox
    And I uncheck oco 'limit' checkbox
    Then the oco '1'st normal stop linked order 'price' element should be disabled
    And the oco '1'st normal stop linked order 'points' element should be disabled
    And the oco '1'st normal stop linked order 'p/l' element should be disabled
    And the oco '2'nd limit linked order 'price' element should be disabled
    And the oco '2'nd limit linked order 'points' element should be disabled
    And the oco '2'nd limit linked order 'p/l' element should be disabled
    #16
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '1.4' in the 'current market'
    Then the oco '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the oco '1'st normal stop linked order 'p/l' input should be autopopulated
    #17
    When I fill the oco '2'nd limit linked order 'price' with value '1.6' in the 'current market'
    Then the oco '2'nd limit linked order 'pips/points' input should be autopopulated
    And the oco '2'nd limit linked order 'p/l' input should be autopopulated
    #18
    And 'sell' price should change with time
    And the oco '1'st normal stop linked order 'p/l' input should be autopopulated
    And the oco '2'nd limit linked order 'p/l' input should be autopopulated
    #19
    When I click on 'submit' button
    Then 'oco order' confirmation message should be correct
    #20
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #21
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then '2' 'previously added' orders should be on the list
    And the '1'st order 'direction' cell should contain 'sell' word
    And the '1'st order 'quantity' cell should contain '2' data
    And the '1'st order 'order price' cell should contain '1.00000' data
    And the '1'st order 'stop price' cell should contain '1.10000' data
    And the '1'st order 'limit price' cell should contain '0.90000' data
    And the '2'nd order 'direction' cell should contain 'buy' word
    And the '2'nd order 'quantity' cell should contain '2' data
    And the '2'nd order 'order price' cell should contain '1.50000' data
    And the '2'nd order 'stop price' cell should contain '1.40000' data
    And the '2'nd order 'limit price' cell should contain '1.60000' data
    #22 skipped
    #23
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    And max allowed symbols in main 'quantity' field should be '15'
    And max allowed symbols in main 'order price' field should be '15'
    And max allowed symbols in the main '1'st normal stop linked order 'price' should be '15'
    And max allowed symbols in the main '1'st normal stop linked order 'points' should be '15'
    And max allowed symbols in the main '1'st normal stop linked order 'p/l' should be '15'
    And max allowed symbols in the main '2'nd limit linked order 'price' should be '15'
    And max allowed symbols in the main '2'nd limit linked order 'points' should be '15'
    And max allowed symbols in the main '2'nd limit linked order 'p/l' should be '15'
    And max allowed symbols in oco 'quantity' field should be '15'
    And max allowed symbols in oco 'order price' field should be '15'
    And max allowed symbols in the oco '1'st normal stop linked order 'price' should be '15'
    And max allowed symbols in the oco '1'st normal stop linked order 'points' should be '15'
    And max allowed symbols in the oco '1'st normal stop linked order 'p/l' should be '15'
    And max allowed symbols in the oco '2'nd limit linked order 'price' should be '15'
    And max allowed symbols in the oco '2'nd limit linked order 'points' should be '15'
    And max allowed symbols in the oco '2'nd limit linked order 'p/l' should be '15'
    #24
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I uncheck main 'stop' checkbox
    And I uncheck main 'limit' checkbox
    And I uncheck oco 'stop' checkbox
    And I uncheck oco 'limit' checkbox
    And I click on 'submit' button
    And I click on the '1'st main normal stop linked order 'price' field
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    When I click on the '2'nd main limit linked order 'points' field
    Then the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled


  @regression @oco-order-client-validation @wt-915-v6
  Scenario: OCO order - Client Validation
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    #2
    When I fill main 'order price' with value '90'
    And I fill main 'quantity' with value '1000'
    Then 'submit button' element text should be 'Place Order'
    #3
    When I click on 'oco' link
    Then the 'main' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    And the 'oco' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    #4
    When I fill oco 'order price' with value '80'
    Then 'USD/JPY' oco order 'sell price' validation should be correct
    #5
    When I fill main 'order price' with value '130'
    And I fill oco 'order price' with value '140'
    Then 'USD/JPY' oco order 'buy price' validation should be correct
    #6 skipped
    #7
    When I fill main 'quantity' with value '900'
    Then 'USD/JPY' main order 'min quantity' validation should be correct
    When I fill main 'quantity' with value '900000000000'
    Then 'USD/JPY' main order 'max quantity' validation should be correct
    When I fill oco 'quantity' with value '900'
    Then 'USD/JPY' oco order 'min quantity' validation should be correct
    When I fill oco 'quantity' with value '900000000000'
    Then 'USD/JPY' oco order 'max quantity' validation should be correct
    #8
    When I fill main 'order price' with value '90'
    And I fill main 'quantity' with value '1000'
    And I fill oco 'order price' with value '130'
    And I fill oco 'quantity' with value '5000'
    And I click on 'oco advanced ticket link' element
    #9
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '1'st normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '140' in the 'current market'
    And I fill the oco '2'nd limit linked order 'quantity' with value '1000' in the 'current market'
    And I expand oco '1'st applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    Then 'GTT' option should be selected in oco '1'st applicability dropdown
    When I uncheck oco 'stop' checkbox
    And I uncheck oco 'limit' checkbox
    Then the oco '1'st normal stop linked order 'price' element should be disabled
    And the oco '1'st normal stop linked order 'points' element should be disabled
    And the oco '1'st normal stop linked order 'p/l' element should be disabled
    And 'GTC' option should be selected in oco '1'st applicability dropdown
    And the oco '2'nd limit linked order 'price' element should be disabled
    And the oco '2'nd limit linked order 'points' element should be disabled
    And the oco '2'nd limit linked order 'p/l' element should be disabled
    And 'GTC' option should be selected in oco '1'st applicability dropdown
    #10
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I expand oco add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    Then the number of linked orders should be '5'
    When I expand oco add stop limit dropdown
    And I select 'limit' from expanded dropdown
    Then the number of linked orders should be '6'
    #11
    When I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '1'st normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the oco '2'nd normal stop linked order 'price' with value '140' in the 'current market'
    And I fill the oco '2'nd normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the oco '3'rd normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the oco '3'rd normal stop linked order 'price' with value '140' in the 'current market'
    Then 'buy' 'USD/JPY' oco '3'rd stop price validation should be correct
    When I fill the oco '4'th limit linked order 'quantity' with value '1000' in the 'current market'
    And I fill the oco '4'th limit linked order 'price' with value '120' in the 'current market'
    Then 'buy' 'USD/JPY' oco '4'rd limit price validation should be correct
    #12
    When I wait for '5000'
    And I click on 'oco' link
    #13
    When I click on 'oco' link
    Then the oco '3'rd normal stop linked order 'price' input should be autopopulated
    And the oco '4'th limit linked order 'price' input should be autopopulated
    And 'buy' 'USD/JPY' oco '3'rd stop price validation should be correct
    And 'buy' 'USD/JPY' oco '4'rd limit price validation should be correct
    #14
    When I fill the oco '3'rd normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '3'rd normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the oco '4'th limit linked order 'price' with value '140' in the 'current market'
    And I fill the oco '4'th limit linked order 'quantity' with value '1000' in the 'current market'
    Then 'submit button' element text should be 'Place Order'
    #15
    When I clear oco 'order price' field
    Then 'submit button' element text should be 'Enter a price'


  @regression @edit-and-remove-oco-order-with-stop/limit @wt-913-v6
  Scenario: Edit and remove OCO order with stop/limit
    #pre
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    And I click on 'oco' link
    And I fill main 'order price' with value '90'
    And I fill main 'quantity' with value '1000'
    And I fill oco 'order price' with value '130'
    And I fill oco 'quantity' with value '1000'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    Then '2' 'previously added' orders should be on the list
    #1
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    #2
    When I click on 'sell' label
    Then trade direction should be 'buy'
    #3
    When I fill oco 'order price' with value '140'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    Then the '2'nd order 'order price' cell should contain '140.000' data
    #4
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I fill main 'order price' with value '80'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    Then the '1'st order 'order price' cell should contain '80.000' data
    #5
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I fill oco 'quantity' with value '2000'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    Then the '2'nd order 'quantity' cell should contain '2000' data
    #6
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I fill main 'quantity' with value '3000'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    Then the '1'st order 'quantity' cell should contain '3000' data
    #7
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '150' in the 'current market'
    And I uncheck oco 'stop' checkbox
    And I uncheck oco 'limit' checkbox
    Then the oco '1'st normal stop linked order 'price' element should be disabled
    And the oco '1'st normal stop linked order 'points' element should be disabled
    And the oco '1'st normal stop linked order 'p/l' element should be disabled
    And the oco '2'nd limit linked order 'price' element should be disabled
    And the oco '2'nd limit linked order 'points' element should be disabled
    And the oco '2'nd limit linked order 'p/l' element should be disabled
    #8
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '150' in the 'current market'
    Then 'submit button' element text should be 'Update Order'
    #9 (10)
    When I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '150' in the 'current market'
    Then 'submit button' element text should be 'Update Order'
    And 'buy' price should change with time
    And 'submit button' element text should be 'Update Order'
    #10 (9)
    When I click on the '1'st oco normal stop linked order 'price' field
    And I modify the '1'st oco normal stop linked order 'price' by typing 'ARROW_UP' key until the value will be above '145.000'
    And I click on the '2'nd oco normal stop linked order 'price' field
    And I modify the '2'nd oco normal stop linked order 'price' by typing 'ARROW_DOWN' key until the value will be below '130.000'
    Then 'buy' 'USD/JPY' oco '1'st stop price validation should be correct
    And 'buy' 'USD/JPY' oco '2'st limit price validation should be correct
    #11
    When I fill the oco '1'st normal stop linked order 'price' with value '120' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '150' in the 'current market'
    Then 'submit button' element text should be 'Update Order'
    And 'buy' price should change with time
    And the oco '1'st normal stop linked order 'price' input should be 120.000
    And the oco '2'nd limit linked order 'price' input should be 150.000
    #12
    When I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    Then the '2'nd order 'stop price' cell should contain '120.000' data
    And the '2'nd order 'limit price' cell should contain '150.000' data
    #13
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I check main 'stop' checkbox
    And I check main 'limit' checkbox
    And I fill the main '1'st normal stop linked order 'price' with value '70' in the 'current market'
    And I fill the main '2'nd limit linked order 'price' with value '90' in the 'current market'
    Then 'submit button' element text should be 'Update Order'
    #14
    Then 'buy' price should change with time
    And the main '1'st normal stop linked order 'price' input should be 70.000
    And the main '2'nd limit linked order 'price' input should be 90.000
    #15
    When I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    Then the '1'st order 'stop price' cell should contain '70.000' data
    And the '1'st order 'limit price' cell should contain '90.000' data
    #16 at the end of scenario
    #17
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I click on 'main advanced ticket link' element
    #18
    And I fill the main '1'st normal stop linked order 'price' with value '70' in the 'current market'
    And I fill the main '1'st normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the main '2'nd limit linked order 'price' with value '90' in the 'current market'
    And I fill the main '2'nd limit linked order 'quantity' with value '1000' in the 'current market'
    And I expand main '1'st applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    Then 'GTT' option should be selected in main '1'st applicability dropdown
    When I uncheck main 'stop' checkbox
    And I uncheck main 'limit' checkbox
    Then the main '1'st normal stop linked order 'quantity' element should be disabled
    And the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    And the main '2'nd limit linked order 'quantity' element should be disabled
    And the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled
    And 'GTC' option should be selected in main '1'st applicability dropdown
    #19
    When I check main 'stop' checkbox
    And I check main 'limit' checkbox
    And I fill the main '1'st normal stop linked order 'price' with value '70' in the 'current market'
    And I fill the main '1'st normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the main '2'nd limit linked order 'price' with value '90' in the 'current market'
    And I fill the main '2'nd limit linked order 'quantity' with value '1000' in the 'current market'
    And I expand main '1'st applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    And I expand main '1'st date picker dropdown
    And I add to date/time picker '3' hours and click outside
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    Then the '1'st order 'stop price' cell should contain '70.000' data
    And the '1'st order 'limit price' cell should contain '90.000' data
    #20
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    And 'submit button' element text should be 'Update Order'
    #21
    When I fill the main '1'st normal stop linked order 'price' with value '75' in the 'current market'
    Then Submit button should be enable
    And 'submit button' element text should be 'Update order'
    #22
    When I fill the main '1'st normal stop linked order 'price' with value '70' in the 'current market'
    Then Submit button should be disable
    And 'submit button' element text should be 'Update order'
    #23,24 wrong steps
    #16
    When I close 'Deal ticket' panel
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    And I click on 'delete' in the '2'nd order
    And I click on 'delete confirm' in the '2'nd order
    Then '1' 'previously added' orders should be on the list
    When I add new 'Reports' panel in 'Default Workspace' tab
    Then the 'Reports' panel should be visible
    When I select 'Order History' list
    Then the '1'st market 'name' cell should contain 'USD/JPY' word
    And the '2'nd market 'name' cell should contain 'USD/JPY' word


  @regression @oco-order-good-till-applicability @wt-918-v7
  Scenario: OCO Order - Good 'till applicability
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    #2
    When I click on 'oco' link
    #3
    Then 'oco good till dropdown' element text should be 'Good 'til canceled (GTC)'
    And 'oco good till dropdown' element should be disabled
    #4
    When I fill main 'order price' with value '90'
    And I fill main 'quantity' with value '1000'
    And I fill oco 'order price' with value '130'
    And I fill oco 'quantity' with value '1000'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    Then '2' 'previously added' orders should be on the list
    #5
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I expand applicability dropdown
    And I select 'GTD' from expanded dropdown
    Then 'main good till dropdown' element text should be 'Good 'til end of day (GTD)'
    And 'oco good till dropdown' element text should be 'Good 'til end of day (GTD)'
    And 'oco good till dropdown' element should be disabled
    And Submit button should be enable
    And 'submit button' element text should be 'Update order'
    #6
    When I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    And 'main good till dropdown' element text should be 'Good 'til end of day (GTD)'
    And 'oco good till dropdown' element text should be 'Good 'til end of day (GTD)'
    #7
    When I close 'Deal ticket' panel
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Order details'
    Then the 'details' panel should be visible
    And 'Good 'til' row should contain 'End of day' word
    When I close 'details' panel
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '2'nd market dropdown with value 'Order details'
    Then the 'details' panel should be visible
    And 'Good 'til' row should contain 'End of day' word
    #8
    When I close 'details' panel
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    When I expand applicability dropdown
    And I select 'GTT' from expanded dropdown
    Then 'main good till dropdown' element text should be 'Good 'til time (GTT)'
    And 'oco good till dropdown' element text should be 'Good 'til time (GTT)'
    And 'oco good till dropdown' element should be disabled
    And date picker input should be defined with '0' minutes more than now
    When I expand 'date picker' dropdown
    And I add to date/time picker '2' hours and click outside
    Then Submit button should be enable
    And 'submit button' element text should be 'Update order'
    #9, 10
    When I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Order details'
    Then the 'details' panel should be visible
    And 'Good 'til' row should contain 'Time' word
    When I close 'details' panel
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '2'nd market dropdown with value 'Order details'
    Then the 'details' panel should be visible
    And 'Good 'til' row should contain 'Time' word
    #11
    When I close 'details' panel
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    And I expand applicability dropdown
    And I select 'GTD' from expanded dropdown
    Then 'main good till dropdown' element text should be 'Good 'til end of day (GTD)'
    When I click on 'oco' link
    Then 'oco good till dropdown' element text should be 'Good 'til end of day (GTD)'
    And 'oco good till dropdown' element should be disabled


  @regression @sell/buy-state-after-oco-reordering @wt-1418-v1
  Scenario: Sell/Buy state after OCO reopening
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    #2
    When I fill main 'order price' with value '90'
    And I fill main 'quantity' with value '1000'
    And I click on 'oco' link
    #3
    When I click on oco 'buy' label
    Then oco trade direction should be 'buy'
    #4
    When I click on 'oco' link
    #5
    When I click on 'oco' link
    Then oco trade direction should be 'buy'
    #6
    When I click on oco 'sell' label
    Then oco trade direction should be 'sell'
    When I click on 'oco' link
    And I click on 'oco' link
    Then oco trade direction should be 'sell'
    #7
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I clear main 'order price' field
    And I fill oco 'quantity' with value '1000'
    And I fill oco 'order price' with value '(current sell + current buy) / 2'
    Then 'USD/JPY' oco order 'between price' validation should be correct
    When I fill the oco '1'st normal stop linked order 'price' with value '90' in the 'current market'
    Then 'sell' 'USD/JPY' oco '1'st stop price validation should be correct
    When I fill the oco '2'nd limit linked order 'price' with value '130' in the 'current market'
    Then 'sell' 'USD/JPY' oco '2'nd limit price validation should be correct
    #8
    When I click on 'oco' link
    And I click on 'oco' link
#    Then 'USD/JPY' oco order 'between price' validation should be correct
#    change to fast to be stable (Mocks as solution)
    Then 'sell' 'USD/JPY' oco '1'st stop price validation should be correct
    And 'sell' 'USD/JPY' oco '2'nd limit price validation should be correct
    And oco 'order price' input value is 'correct'
    And the oco '1'st normal stop linked order 'price' input should be 90.000
    And the oco '2'nd limit linked order 'price' input should be 130.000
    #9
    When I click on oco 'buy' label
    And I click on 'oco' link
    And I click on 'oco' link
    Then oco trade direction should be 'buy'
    And oco 'order price' input value is 'correct'
#    Then 'USD/JPY' oco order 'between price' validation should be correct


  @regression @confirmation-message-on-oco-main-ticket-update @wt-1087-v3
  Scenario: Confirmation message on OCO Main ticket update
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    And I fill main 'order price' with value '90'
    And I fill main 'quantity' with value '1000'
    And I check main 'stop' checkbox
    And I check main 'limit' checkbox
    And I fill the main '1'st normal stop linked order 'price' with value '100' in the 'current market'
    And I fill the main '2'st limit linked order 'price' with value '80' in the 'current market'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    #2
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #3
    When I click on 'oco' link
    #4
    When I fill oco 'order price' with value '130'
    And I fill oco 'quantity' with value '1000'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '1' linked orders should be displayed
    #5
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    #6
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #7
    When I fill main 'order price' with value '85'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #8
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    #9
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #10
    When I fill main 'quantity' with value '4100'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #11
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #12
    When I expand applicability dropdown
    And I select 'GTD' from expanded dropdown
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #13
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #14
    When I click on 'main advanced ticket link' element
    And I expand main add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    And I fill the main '3'rd normal stop linked order 'price' with value '110' in the 'current market'
    And I fill the main '1'st normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the main '3'rd normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '1' linked orders should be displayed
    #15
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    When I expand main add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    And I expand main add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    And I fill the main '2'nd limit linked order 'quantity' with value '1000' in the 'current market'
    And I fill the main '4'th normal stop linked order 'price' with value '110' in the 'current market'
    And I fill the main '4'th normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the main '5'th limit linked order 'price' with value '80' in the 'current market'
    And I fill the main '5'th limit linked order 'quantity' with value '1000' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '2' linked orders should be displayed
    #16
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #17
    When I fill the main '1'st normal stop linked order 'price' with value '95' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #18
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #19
    When I fill the main '2'nd normal stop linked order 'price' with value '75' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #20
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #21
    When I remove main '3'rd normal stop order
    And I click on 'submit' button after waiting
    Then correct confirmation message about removing '1' linked orders should be displayed
    #22
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #23
    When I expand main add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    And I expand main add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    And I expand main add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    And I fill the main '5'th normal stop linked order 'price' with value '110' in the 'current market'
    And I fill the main '5'th normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the main '6'th trailing stop linked order 'pips' with value '20' in the 'current market'
    And I fill the main '6'th trailing stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the main '7'th limit linked order 'price' with value '80' in the 'current market'
    And I fill the main '7'th limit linked order 'quantity' with value '1000' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '3' linked orders should be displayed
    #24
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #25
    When I fill the main '6'th normal stop linked order 'pips' with value '30' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #26
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #27
    When I uncheck main 'stop' checkbox
    And I uncheck main 'limit' checkbox
    And I remove main '3'rd normal stop order
    And I remove main '4'th limit order
    And I remove main '5'th normal stop order
    And I remove main '6'th trailing stop order
    And I remove main '7'th limit order
    And I click on 'submit' button after waiting
    Then correct confirmation message about removing '7' linked orders should be displayed


  @regression @confirmation-message-on-oco-update @wt-1088-v3
  Scenario: Confirmation message on OCO update
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    And I fill main 'order price' with value '90'
    And I fill main 'quantity' with value '1000'
    And I check main 'stop' checkbox
    And I check main 'limit' checkbox
    And I fill the main '1'st normal stop linked order 'price' with value '100' in the 'current market'
    And I fill the main '2'st limit linked order 'price' with value '80' in the 'current market'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    #2
    When I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #3
    When I click on 'oco' link
    #4
    When I fill oco 'order price' with value '130'
    And I fill oco 'quantity' with value '1000'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '1' linked orders should be displayed
    #5
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    #6
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #7
    When I fill oco 'order price' with value '135'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #8
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    #9
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #10
    When I fill oco 'quantity' with value '1100'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #11
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #12
    When I expand applicability dropdown
    And I select 'GTD' from expanded dropdown
    Then 'main good till dropdown' element text should be 'Good 'til end of day (GTD)'
    And 'oco good till dropdown' element text should be 'Good 'til end of day (GTD)'
    And 'oco good till dropdown' element should be disabled
    When I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #13
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #14
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '140' in the 'current market'
    And I fill the oco '2'st limit linked order 'price' with value '120' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '2' linked orders should be displayed
    #15
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    When I uncheck oco 'stop' checkbox
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #16
    When I check oco 'stop' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '140' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '1' linked orders should be displayed
    #17
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #18
    When I fill the oco '1'st normal stop linked order 'price' with value '150' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '110' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #19
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #20
    When I fill the oco '1'st normal stop linked order 'price' with value '140' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '120' in the 'current market'
    And I fill the main '1'st normal stop linked order 'price' with value '110' in the 'current market'
    And I fill the main '2'nd limit linked order 'price' with value '70' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #21
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #22
    When I uncheck oco 'stop' checkbox
    And I uncheck oco 'limit' checkbox
    And I click on 'submit' button after waiting
    Then correct confirmation message about removing '2' linked orders should be displayed
    #23
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '140' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '120' in the 'current market'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #24
    When I uncheck oco 'stop' checkbox
    And I uncheck oco 'limit' checkbox
    And I uncheck main 'stop' checkbox
    And I uncheck main 'limit' checkbox
    And I click on 'submit' button after waiting
    Then correct confirmation message about removing '4' linked orders should be displayed
    #25
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    When I check oco 'stop' checkbox
    And I check oco 'limit' checkbox
    And I check main 'stop' checkbox
    And I check main 'limit' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value '140' in the 'current market'
    And I fill the oco '2'nd limit linked order 'price' with value '120' in the 'current market'
    And I fill the main '1'st normal stop linked order 'price' with value '100' in the 'current market'
    And I fill the main '2'nd limit linked order 'price' with value '80' in the 'current market'
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #26
    When I click on 'oco advanced ticket link' element
    And I fill oco 'quantity' with value '4100'
    And I expand oco add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    And I fill the oco '3'rd normal stop linked order 'price' with value '140' in the 'current market'
    And I fill the oco '3'rd normal stop linked order 'quantity' with value '1000' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '1' linked orders should be displayed
    #27
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #28
    When I click on 'main advanced ticket link' element
    And I fill main 'quantity' with value '4100'
    And I expand oco add stop limit dropdown
    And I select 'limit' from expanded dropdown
    And I expand main add stop limit dropdown
    And I select 'limit' from expanded dropdown
    And I fill the oco '4'th limit linked order 'price' with value '120' in the 'current market'
    And I fill the oco '4'th limit linked order 'quantity' with value '1000' in the 'current market'
    And I fill the main '3'rd limit linked order 'price' with value '80' in the 'current market'
    And I fill the main '3'rd limit linked order 'quantity' with value '1000' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '2' linked orders should be displayed
    #29
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #30
    When I fill the oco '3'rd normal stop linked order 'price' with value '150' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #31
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #32
    When I fill the oco '4'th limit linked order 'price' with value '110' in the 'current market'
    And I fill the main '3'th limit linked order 'price' with value '70' in the 'current market'
    And I click on 'submit' button after waiting
    Then correct confirmation message about adding '0' linked orders should be displayed
    #33
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #34
    When I remove oco '4'th limit order
    And I click on 'submit' button after waiting
    Then correct confirmation message about removing '1' linked orders should be displayed
    #35
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #36
    When I remove oco '3'rd normal stop order
    And I remove main '3'rd limit order
    And I click on 'submit' button after waiting
    Then correct confirmation message about removing '2' linked orders should be displayed
    #37
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    When I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #38
    When I click on 'oco' link
    And I click on 'submit' button after waiting
    Then correct confirmation message about removing 'OCO' order should be displayed


  @regression @oco-order-edit-direction-changing-after-server-error @wt-1674-v1 @wip
  Scenario: OCO Order - Edit - direction changing after server error
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    #2
    When I click on 'oco' link
    And I fill main 'order price' with value '90'
    And I fill main 'quantity' with value '1000'
    And I fill oco 'order price' with value '130'
    And I fill oco 'quantity' with value '1000'
    #3
    And I click on 'submit' button after waiting
    And I click on 'ok' button after waiting
    #4
    And I make 'positions and orders' panel active
    And I select 'Orders' list
    And I complete '1'st market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    #5
    When I fill main 'order price' with value '1'
    And I fill oco 'order price' with value '100000000000'
    And I click on 'submit' button after waiting
    Then 'error message' in deal ticket panel should be displayed
    #6
    When I click on 'ok' button after waiting
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Update Order'
    #7
    Then main trade direction should be 'sell'
    And oco trade direction should be 'sell'
    When I click on main 'buy' label
    Then main trade direction should be 'sell'
    When I click on oco 'buy' label
    Then oco trade direction should be 'sell'
