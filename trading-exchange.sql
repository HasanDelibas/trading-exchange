-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost
-- Üretim Zamanı: 21 Nis 2022, 21:39:52
-- Sunucu sürümü: 10.4.17-MariaDB
-- PHP Sürümü: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `trading-exchange`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `inventory`
--

CREATE TABLE `inventory` (
  `user_id` int(11) NOT NULL,
  `symbol` int(11) NOT NULL,
  `quantity` float(10,5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Tablo döküm verisi `inventory`
--

INSERT INTO `inventory` (`user_id`, `symbol`, `quantity`) VALUES
(2, 1, 82.00000),
(4, 2, 168.00000),
(8, 2, 1840.00000),
(9, 2, 42.00000);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `order_book`
--

CREATE TABLE `order_book` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `symbol_pair` int(11) NOT NULL,
  `price` float(10,2) NOT NULL,
  `quantity` float(10,5) NOT NULL,
  `buy_sell` int(4) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Tablo döküm verisi `order_book`
--

INSERT INTO `order_book` (`id`, `user_id`, `symbol_pair`, `price`, `quantity`, `buy_sell`, `date`) VALUES
(11, 1, 1, 19.00, 10.00000, 1, '2022-04-20 23:19:41'),
(12, 2, 1, 21.00, 8.00000, 1, '2022-04-20 23:20:34');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `symbol`
--

CREATE TABLE `symbol` (
  `id` int(11) NOT NULL,
  `name` varchar(24) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Tablo döküm verisi `symbol`
--

INSERT INTO `symbol` (`id`, `name`) VALUES
(1, 'Coal ore'),
(2, 'FCT');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `symbol_pair`
--

CREATE TABLE `symbol_pair` (
  `id` int(11) NOT NULL,
  `symbol_to_buy` int(11) NOT NULL,
  `symbol_to_sell` int(11) NOT NULL,
  `symbol_pair_last_price` float(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Tablo döküm verisi `symbol_pair`
--

INSERT INTO `symbol_pair` (`id`, `symbol_to_buy`, `symbol_to_sell`, `symbol_pair_last_price`) VALUES
(1, 1, 2, 20.00);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `transaction_history`
--

CREATE TABLE `transaction_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `symbol_pair_id` int(11) NOT NULL,
  `price` float(10,2) NOT NULL,
  `quantity` double(10,5) NOT NULL,
  `buy_sell` int(4) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Tablo döküm verisi `transaction_history`
--

INSERT INTO `transaction_history` (`id`, `user_id`, `symbol_pair_id`, `price`, `quantity`, `buy_sell`, `date`) VALUES
(2, 8, 0, 20.00, 10.00000, -1, '2022-04-20 23:15:40'),
(3, 8, 0, 20.00, 82.00000, -1, '2022-04-20 23:20:34'),
(4, 2, 0, 20.00, 82.00000, 1, '2022-04-20 23:20:34'),
(5, 4, 1, 20.00, 8.00000, -1, '2022-04-21 21:20:28'),
(6, 2, 1, 20.00, 8.00000, 1, '2022-04-21 21:20:28'),
(9, 9, 1, 20.00, 2.00000, -1, '2022-04-21 22:39:07'),
(10, 2, 1, 20.00, 2.00000, 1, '2022-04-21 22:39:07');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `inventory`
--
ALTER TABLE `inventory`
  ADD UNIQUE KEY `inventory_id` (`user_id`,`symbol`) USING BTREE;

--
-- Tablo için indeksler `order_book`
--
ALTER TABLE `order_book`
  ADD PRIMARY KEY (`id`),
  ADD KEY `symbol_pair` (`symbol_pair`);

--
-- Tablo için indeksler `symbol`
--
ALTER TABLE `symbol`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `symbol_pair`
--
ALTER TABLE `symbol_pair`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `transaction_history`
--
ALTER TABLE `transaction_history`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `order_book`
--
ALTER TABLE `order_book`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Tablo için AUTO_INCREMENT değeri `symbol`
--
ALTER TABLE `symbol`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `symbol_pair`
--
ALTER TABLE `symbol_pair`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `transaction_history`
--
ALTER TABLE `transaction_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `order_book`
--
ALTER TABLE `order_book`
  ADD CONSTRAINT `order_book_ibfk_1` FOREIGN KEY (`symbol_pair`) REFERENCES `symbol_pair` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `symbol_pair`
--
ALTER TABLE `symbol_pair`
  ADD CONSTRAINT `symbol_pair_ibfk_1` FOREIGN KEY (`symbol_to_buy`) REFERENCES `symbol` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `symbol_pair_ibfk_2` FOREIGN KEY (`symbol_to_sell`) REFERENCES `symbol` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
