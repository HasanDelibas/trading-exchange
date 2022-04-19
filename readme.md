# Trading Exchange
This is an example for Trading Exchange = Order Book + Matching Engine app.

This application written by php language.

## What is the algorithm?
```
while True
  foreach symbol => symbols
    canTransaction = true
    symbolToBuy  = symbol.symbol_1
    symbolToSell = symbol.symbol_2
    while canTransaction == true
      maxBuyOrder = search order in database maximum price for wanted to buy symbol
      minSellOrder = search order in database minimum pricate for wanted to sell symbol
      if maxBuyOrder < minSellOrder
        canTransaction = false
      if canTransaction = false 
        exit()
      
      quantity = min( maxBuyOrder.quantity , minSellOrder.quantity )
      price = minSellOrder.price

      // Selling symbol to user wallet
      minSellOrder.user.wallet  += quantity * price , symbolToSell
      // Decrease quantity from order
      minSellOrder.quantity     -= quantity
      // Add To Transaction History
      transactionHistory.add( user, quantity , price , "sell" , date )

      // Buy symbol from order
      maxBuyOrder.user.wallet   += quantity , symbolToBuy
      // Decrease quantity from order
      minSellOrder.quantity     -= quantity
      // Add To Transaction History
      transactionHistory.add( user, quantity , price , "buy" , date )

      // Remove all empty quantityies
      DB::Delete( {quantity:0} )

```


## Database Example

### symbol

| id | name |
|----|------|
| 1  | BTC  |
| 2  | USD  |

### symbol_pair

| id | symbol_1 | symbol_2 | name        |
|----|----------|----------|-------------|
| 1  |    1     |    2     |   BTC/USD   |

### order_book


| id | symbol_pair | quantity | price | buy_sell | user_id | date |
|----|-------------|----------|-------|----------|---------|------|
| 1  | 1           | 10       | 10    |   -1     |  1      | CD   |
| 2  | 1           | 20       | 12    |    1     |  2      | CD   |


### transaction_history

> Editing
