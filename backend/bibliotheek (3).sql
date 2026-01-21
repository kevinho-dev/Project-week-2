-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 21 jan 2026 om 13:14
-- Serverversie: 10.4.32-MariaDB
-- PHP-versie: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bibliotheek`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `books`
--

CREATE TABLE `books` (
  `book_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(100) DEFAULT NULL,
  `summary` text DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `buy_price` decimal(10,2) DEFAULT NULL,
  `rent_price` decimal(10,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `is_bestseller` tinyint(1) DEFAULT 0,
  `img` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `books`
--

INSERT INTO `books` (`book_id`, `title`, `author`, `summary`, `category_id`, `buy_price`, `rent_price`, `stock_quantity`, `is_bestseller`, `img`) VALUES
(1, 'Beer en Vogel gaan op avontuur in Winter Wonderland', 'Lambert, Jonny', 'Het heeft gesneeuwd! Beer en Vogel gaan wandelen in de bergen. Daar zien ze allerlei winterse taferelen. Kijk je mee? Prentenboek met zoekplaten in kleur. Vanaf ca. 2 jaar.', 27, 20.00, 5.00, 3, 2, 'https://bibliotheek.wise.oclc.org/cgi-bin/momredir.pl?size=280&lid=2025230197;ppn=449739317;isbn=9789048323098;key=1617083;'),
(2, 'Koen gaat op reis', 'Zanden, Monique van der', 'Eekhoorn Koen zit in zijn boom en wil naar zijn neef Joep gaan, maar die woont bij de beek. Dat is ver weg. Lukt het Koen om zijn neef te vinden? Met gekleurde illustraties. Vanaf ca. 6 jaar.', 27, 10.00, 25.00, 3, 8, 'https://bibliotheek.wise.oclc.org/cgi-bin/momredir.pl?size=280&lid=2024240955;ppn=443092699;isbn=9789062389780;key=1603468;'),
(3, 'Wie redt de magische boeken?', 'George, Nina', 'Vier vrienden ontdekken een geheime bibliotheek met magische wezens. Dat is uniek, want in hun wereld zijn boeken verboden. Zal het de vrienden lukken om de boeken te redden? Vanaf ca. 10 jaar.', 27, 15.00, 7.00, 3, 3, 'https://bibliotheek.wise.oclc.org/cgi-bin/momredir.pl?size=280&lid=2025110569;ppn=444726039;isbn=9789025888565;key=1603608;'),
(4, 'Elf minuten', 'Coelho, Paulo', 'Om een relatie met een jonge schilder aan te kunnen gaan moet een Braziliaanse prostituee met haar vroegere leven en beroep in het reine zien te komen.', 2, 30.00, 20.00, 17, 15, 'https://bibliotheek.wise.oclc.org/cgi-bin/momredir.pl?size=280&lid=2014102220;ppn=372469620;isbn=9789029589499;key=941630;'),
(5, 'De alchemist', 'Coelho, Paulo', 'De zoektocht van een Andalusische herdersjongen naar de ware levenswijsheid brengt hem naar de Egyptische piramiden.', 2, 35.00, 20.00, 5, 12, 'https://bibliotheek.wise.oclc.org/cgi-bin/momredir.pl?size=280&lid=2013133152;ppn=356195279;isbn=9789029588607;key=804560;'),
(6, 'Atlas van het Westland :\r\n10.000 jaar ruimtelijke ontwikkeling', 'IJsselstijn, Marcel', 'Het Westland is meer dan alleen een \'glazen stad\'. Het heeft een rijke en afwisselende landschapsgeschiedenis en die krijgt in deze atlas in groot formaat ...', 3, 40.00, 25.00, 5, 2, 'https://bibliotheek.wise.oclc.org/cgi-bin/momredir.pl?size=280&lid=2016312014;ppn=406335125;isbn=9789068687200;key=1086073;'),
(7, 'Het verzet van mijn vader', 'Maas, Frank', 'Biografie van de Nederlandse communist en verzetsstrijder (1913-1988). Met foto’s, portretten en illustraties.', 3, 45.00, 30.00, 2, 5, 'https://bibliotheek.wise.oclc.org/cgi-bin/momredir.pl?size=280&lid=2024512210;ppn=443837244;isbn=9789492335562;key=1597359;');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL CHECK (`level` between 1 and 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `parent_id`, `level`) VALUES
(1, 'kinderen', NULL, 1),
(2, 'volwassenen', NULL, 1),
(3, 'ouderen', NULL, 1),
(4, 'Avontuur', 1, 2),
(5, 'Fantasy', 1, 2),
(8, 'Dieren', 1, 2),
(9, 'Vriendschap', 1, 2),
(11, 'Vrolijk', 4, 3),
(12, 'Spannend', 5, 3),
(13, 'Grappig', 5, 3),
(14, 'Ontroerend', 5, 3),
(15, 'Vrolijk', 5, 3),
(16, 'Spannend', 4, 3),
(17, 'Grappig', 4, 3),
(18, 'Ontroerend', 4, 3),
(19, 'Kort(<200 pagina\'s)', 15, 4),
(20, 'Gemiddeld (200 - 400 pagina\'s)', 15, 4),
(21, 'LANG(> 400 pagina\'s) ', 15, 4),
(22, 'Maakt niet uit', 15, 4),
(23, 'Kort ( < 200 pagina\'s)', 11, 4),
(24, 'Gemiddeld (200 - 400 pagina\'s)', 11, 4),
(25, 'Lang (> 400 pagina\'s)', 11, 4),
(26, 'Maakt niet uit', 11, 4),
(27, 'Fantasiewerled', 23, 5),
(28, 'School', 23, 5),
(29, 'NAtuur', 23, 5),
(30, 'Thuis', 23, 5);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `complaints`
--

CREATE TABLE `complaints` (
  `complaint_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` enum('pending','resolved') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `transactions`
--

CREATE TABLE `transactions` (
  `transaction_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `book_id` int(11) DEFAULT NULL,
  `type` enum('purchase','rental') NOT NULL,
  `amount_paid` decimal(10,2) DEFAULT NULL,
  `transaction_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `due_date` date DEFAULT NULL,
  `status` enum('active','completed','returned') DEFAULT 'completed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','member','visitor') DEFAULT 'visitor',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `email`, `password_hash`, `role`, `created_at`) VALUES
(3, 'Midf', 'kjbcdksc@ncc.com', '$2y$10$WKJ9/sJVrNDIeZewjwJeXuOsu/MyeFGU/yU2S/ja58ac/EDO.X.du', '', '2026-01-19 12:05:18'),
(6, 'Mir', 'Mirnassrc@ncc.com', '$2y$10$VFEpiKzJqKLbZKkd.7qMb.tGcq8wCiViJStJ04p7Qy.1TDF2KWKC2', '', '2026-01-19 14:30:39'),
(7, 'mif', 'nfed@dffk.com', '$2y$10$HJlPUzB7MZYS5VjtITDcM.MmWp6ygX6W64Owt.W7iqYuTAj4K17Nq', '', '2026-01-20 12:16:23'),
(9, 'jhdcsd', 'kjdvd@dffk.com', '$2y$10$hHmNOTu66zEcEHQJdQIKteocID9gCj/t/L758SWQkBM76mOFmye2K', '', '2026-01-20 14:05:45'),
(10, 'Sbds', 'kjsdjbd@dffk.com', '$2y$10$TC353HnYBNH82KcPfSvUgOaALxvR01JVo8NiNgykJIb5eftZwi.z2', '', '2026-01-21 10:00:20');

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexen voor tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexen voor tabel `complaints`
--
ALTER TABLE `complaints`
  ADD PRIMARY KEY (`complaint_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexen voor tabel `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexen voor tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT voor een tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT voor een tabel `complaints`
--
ALTER TABLE `complaints`
  MODIFY `complaint_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `transactions`
--
ALTER TABLE `transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Beperkingen voor geëxporteerde tabellen
--

--
-- Beperkingen voor tabel `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Beperkingen voor tabel `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE;

--
-- Beperkingen voor tabel `complaints`
--
ALTER TABLE `complaints`
  ADD CONSTRAINT `complaints_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Beperkingen voor tabel `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
