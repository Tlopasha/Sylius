@checkout
Feature: Checkout fixed discount promotions
    In order to handle product promotions
    As a store owner
    I want to apply promotion discounts during checkout

    Background:
        Given the following promotions exist:
          | name              | description                               |
          | 3 items           | Discount for orders with at least 3 items |
          | 300 EUR           | Discount for orders over 300 EUR          |
        And promotion "3 items" has following rules defined:
          | type       | configuration        |
          | Item count | Count: 3,Equal: true |
        And promotion "3 items" has following actions defined:
          | type           | configuration |
          | Fixed discount | Amount: 15    |
        And promotion "300 EUR" has following rules defined:
          | type       | configuration |
          | Item total | Amount: 300   |
        And promotion "300 EUR" has following actions defined:
          | type           | configuration |
          | Fixed discount | Amount: 40    |
        And there are following taxonomies defined:
          | name     |
          | Category |
        And taxonomy "Category" has following taxons:
          | Clothing > Debian T-Shirts |
        And the following products exist:
          | name    | price | taxons          |
          | Buzz    | 500   | Debian T-Shirts |
          | Potato  | 200   | Debian T-Shirts |
          | Woody   | 125   | Debian T-Shirts |
          | Sarge   | 25    | Debian T-Shirts |
          | Etch    | 20    | Debian T-Shirts |
          | Lenny   | 15    | Debian T-Shirts |

    # fixed discount promotion (300 EUR)
    Scenario: Fixed discount promotion is applied when the cart
              has the required amount
        Given I am on the store homepage
          And I follow "Debian T-Shirts"
          And I click "Woody"
         When I fill in "Quantity" with "3"
          And I press "Add to cart"
         Then I should be on the cart summary page
          And "Promotion total: (€40.00)" should appear on the page
          And "Grand total: €335.00" should appear on the page

    # fixed discount promotion (300 EUR)
    Scenario: Fixed discount promotion is not applied when the cart
              has not the required amount
        Given I am on the store homepage
          And I follow "Debian T-Shirts"
          And I click "Sarge"
         When I fill in "Quantity" with "8"
          And I press "Add to cart"
         Then I should be on the cart summary page
          And "Promotion total: €0.00" should appear on the page
          And "Grand total: €200.00" should appear on the page

    # item count promotion (3 items)
    Scenario: Item count promotion is applied when the cart has the
              number of items required
        Given I am on the store homepage
          And I follow "Debian T-Shirts"
          And I click "Sarge"
          And I fill in "Quantity" with "3"
          And I press "Add to cart"
          And I follow "Debian T-Shirts"
          And I click "Etch"
          And I fill in "Quantity" with "1"
          And I press "Add to cart"
         When I follow "Debian T-Shirts"
          And I click "Lenny"
          And I fill in "Quantity" with "2"
          And I press "Add to cart"
         Then I should be on the cart summary page
          And "Promotion total: (€15.00)" should appear on the page
          And "Grand total: €110.00" should appear on the page

    # item count promotion (3 items)
    Scenario: Item count promotion is not applied when the cart has
              not the number of items required
        Given I am on the store homepage
          And I follow "Debian T-Shirts"
          And I click "Etch"
         When I fill in "Quantity" with "8"
          And I press "Add to cart"
         Then I should be on the cart summary page
          And "Promotion total: €0.00" should appear on the page
          And "Grand total: €160.00" should appear on the page

    # let's cumulate the promotions (3 items + 300 EUR)
    Scenario: Several promotions are applied when an cart fulfills
              the rules of several promotions
        Given I am on the store homepage
          And I follow "Debian T-Shirts"
          And I click "Potato"
          And I fill in "Quantity" with "4"
          And I press "Add to cart"
          And I follow "Debian T-Shirts"
          And I click "Buzz"
          And I fill in "Quantity" with "1"
          And I press "Add to cart"
          And I follow "Debian T-Shirts"
          And I click "Woody"
         When I fill in "Quantity" with "3"
          And I press "Add to cart"
         Then I should still be on the cart summary page
          And "Promotion total: (€55.00)" should appear on the page
          # 4*200 + 1*500 + 3*125 = 1675 - 15 - 40 = 1620
          And "Grand total: €1,620.00" should appear on the page

