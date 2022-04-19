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
    $canOrder = false;
    $maxBuy  = $db->sql("SELECT MAX(price) as 'max',id,user_id,price,quantity FROM `order_book` WHERE symbol_pair=? and buy_sell=1",[ $symbol_pair["id"] ]);
    $minSell = $db->sql("SELECT MIN(price) as 'min',id,user_id,price,quantity FROM `order_book` WHERE symbol_pair=? and buy_sell=-1",[ $symbol_pair["id"] ]);
    if ( $maxBuy!=false && $minSell!=false ){
      if ( $maxBuy["max"] >= $minSell["min"] ){
        $canOrder = true;
        // buy quantity > sell quantity
        if ( $maxBuy["quantity"] > $minSell["quantity"] ){
          $quantity = $minSell["quantity"];
          $price    = $minSell["price"];
          $order_id = $minSell["id"];

          $sellPiece = $quantity * $price;
          $sellUnit = $symbol_pair["symbol_2"];

          $db->sql("DELETE FROM `order_book` WHERE id = ?",[ $minSell["id"]]);
          // TODO:: Inventory Table must update
          print($minSell["user_id"] . " e '" . $sellPiece ." kadar ". $SYMBOLS[ $sellUnit ] . ' geçmiştir. '  );

          $buyPiece = $quantity;
          $buyUnit = $symbol_pair["symbol_1"];

          // TODO :: Update $quanity
          // TODO:: Inventory Table must update
          

        }


      }
    }
    
  }
  exit();
}
