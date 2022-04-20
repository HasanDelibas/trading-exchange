# Trading Exchange
This is an example for Trading Exchange = Order Book + Matching Engine app.

This application written by php language.

## What is the algorithm?
```
while True
  foreach symbol => symbols
    symbolToBuy  = symbol.symbol_to_buy
    symbolToSell = symbol.symbol_to_sell
    while canTransaction == true
      maxBuyOrder = search order in database maximum price for wanted to buy symbol
      minSellOrder = search order in database minimum pricate for wanted to sell symbol
      if maxBuyOrder < minSellOrder
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

| id | symbol_to_buy | symbol_to_sell | name        |
|----|---------------|----------------|-------------|
| 1  |    1          |    2           |   BTC/USD   |

### order_book


| id | user_id | symbol_pair | price | quantity | buy_sell | date |
|----|---------|-------------|-------|----------|----------|------|
| 1  |    1    | 1           | 10    | 10       |   -1     |  CD  |
| 2  |    2    | 1           | 20    | 12       |    1     |  CD  |


### transaction_history
| id | user_id | symbol_pair_id | price | quantity | buy_sell | date |
|----|---------|----------------|-------|----------|----------|------|
| 1  |    8    |        1       | 20.00 | 10.00000 |    -1    |  CD  |


### inventory (wallet)
| user_id | symbol | quantity |
|---------|--------|----------|
|    1    |   1    |   82     |
   
