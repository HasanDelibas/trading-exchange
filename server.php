<?php

include "./lib/DB.php";

$db = new DB("localhost", "root", "", "trading-exchange");

$symbol_pairs = $db->all("symbol_pair");
$_symbols = $db->all("symbol");
$SYMBOLS = [];

foreach($_symbols as $symbol){
  $SYMBOLS[$symbol["id"]] = $symbol["name"];
}



while(1){ 
  foreach( $symbol_pairs as $symbol_pair ){ // Sembolleri
    $symbol_pair_id = $symbol_pair["id"];
    $symbolToBuy = $symbol_pair["symbol_to_buy"];
    $symbolToSell = $symbol_pair["symbol_to_sell"];

    while(1){
      $maxBuyOrder  = $db->sql("SELECT id,user_id,price,quantity FROM `order_book` WHERE symbol_pair=? and buy_sell=1 ORDER BY price DESC LIMIT 1",[ $symbol_pair["id"] ]);
      $minSellOrder = $db->sql("SELECT id,user_id,price,quantity FROM `order_book` WHERE symbol_pair=? and buy_sell=-1 ORDER BY price LIMIT 1",[ $symbol_pair["id"] ]);
      if ( $maxBuyOrder==false || $minSellOrder==false ){
        break;
      }
      $maxBuyOrder = $maxBuyOrder[0];
      $minSellOrder = $minSellOrder[0];
      if($maxBuyOrder["price"] < $minSellOrder["price"]) {
        break;
      }

      $quantity = min( $maxBuyOrder["quantity"] , $minSellOrder["quantity"] );
      $price = $minSellOrder["price"];
      
      $db->autocommit(FALSE);

      /// SELL STATE
      // Add Symbol to user wallet
      $sellerInventory = $db->get("inventory", array(
        "user_id" => $minSellOrder["user_id"],
        "symbol" => $symbolToSell
      ));

      if($sellerInventory==false){
        $db->set("inventory", array(
          "user_id" => $minSellOrder["user_id"],
          "symbol" => $symbolToSell,
          "quantity" => $quantity * $price
        ));
      }else{
        $db->sql("UPDATE `inventory` SET `quantity`=`quantity` + ? WHERE `user_id` = ? and `symbol` = ?",[  $quantity * $price , $minSellOrder["user_id"], $symbolToSell ]);
      }

      // Decrease quantity from order
      $db->sql("UPDATE `order_book` SET quantity=quantity-? WHERE id=?",[ $quantity, $minSellOrder["id"] ]);

      // Add To Transaction History
      $db->set("transaction_history", array(
        "user_id" => $minSellOrder["user_id"],
        "symbol_pair_id" => $symbol_pair_id,
        "price" => $price,
        "quantity" => $quantity,
        "buy_sell" => -1
      ));

      /// BUY STATE
      // Buy symbol from order
      $buyerInventory = $db->get("inventory", array(
        "user_id" => $maxBuyOrder["user_id"],
        "symbol" => $symbolToBuy
      ));

      if($buyerInventory==false){
        $db->set("inventory", array(
          "user_id" => $maxBuyOrder["user_id"],
          "symbol" => $symbolToBuy,
          "quantity" => $quantity 
        ));
      }else{
        $db->sql("UPDATE `inventory` SET `quantity`=`quantity` + ? WHERE `user_id` = ? and `symbol` = ?",[  $quantity , $minSellOrder["user_id"], $symbolToSell ]);
      }
      
      // Decrease quantity from order
      $db->sql("UPDATE `order_book` SET quantity=quantity-? WHERE id=?",[ $quantity, $maxBuyOrder["id"] ]);

      // Add To Transaction History
      $db->set("transaction_history", array(
        "user_id" => $maxBuyOrder["user_id"],
        "symbol_pair_id" => $symbol_pair_id,
        "price" => $price,
        "quantity" => $quantity,
        "buy_sell" => 1
      ));

      // Update Last Symbol Price
      $db->sql("UPDATE `symbol_pair` SET `symbol_pair_last_price`=? WHERE `id`=?",[ $price, $symbol_pair_id ]);

      // Remove all empty quantityies
      $db->sql("DELETE FROM `order_book` WHERE quantity=0");

      // Save All Changes
      $db->commit();
      $db->autocommit(TRUE);

      // ADD TO LOG
      print_r([
        "symbol_pair" => $symbol_pair["id"],
        "symbol_to_buy" => $symbolToBuy,
        "symbol_to_sell" => $symbolToSell,
        "price" => $price,
        "quantity" => $quantity
      ]);

    }
  }
}
