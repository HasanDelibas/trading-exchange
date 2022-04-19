-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost
-- Üretim Zamanı: 19 Nis 2022, 23:23:02
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
-- Tablo için tablo yapısı `order_book`
--

CREATE TABLE `order_book` (
  `id` int(11) NOT NULL,
  `symbol_pair` int(11) NOT NULL,
  `quantity` float(10,5) NOT NULL,
  `price` float(10,2) NOT NULL,
  `buy_sell` int(4) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Tablo döküm verisi `order_book`
--

INSERT INTO `order_book` (`id`, `symbol_pair`, `quantity`, `price`, `buy_sell`, `user_id`, `date`) VALUES
(1, 1, 10.00000, 20.00, 1, 1, '2022-04-19 23:06:13');

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
(1, 'Coal Ore'),
(2, 'FCT');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `symbol_pair`
--

CREATE TABLE `symbol_pair` (
  `id` int(11) NOT NULL,
  `symbol_1` int(11) NOT NULL,
  `symbol_2` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Tablo döküm verisi `symbol_pair`
--

INSERT INTO `symbol_pair` (`id`, `symbol_1`, `symbol_2`) VALUES
(1, 1, 2);

--
-- Dökümü yapılmış tablolar için indeksler
--

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `symbol_1` (`symbol_1`),
  ADD KEY `symbol_2` (`symbol_2`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `order_book`
--
ALTER TABLE `order_book`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  ADD CONSTRAINT `symbol_pair_ibfk_1` FOREIGN KEY (`symbol_1`) REFERENCES `symbol` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `symbol_pair_ibfk_2` FOREIGN KEY (`symbol_2`) REFERENCES `symbol` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
