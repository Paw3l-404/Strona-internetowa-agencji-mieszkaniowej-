-- Ustawienia początkowe
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Wyłączamy sprawdzanie kluczy obcych (zapobiega błędom przy kolejności tworzenia)
SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------------------
-- TWORZENIE TABEL (Z poprawnym AUTO_INCREMENT i PRIMARY KEY w środku)
-- --------------------------------------------------------

-- Tabela: adres
CREATE TABLE `adres` (
  `id_adresu` int(11) NOT NULL AUTO_INCREMENT,
  `ulica` varchar(80) NOT NULL,
  `nr_domu` varchar(100) NOT NULL,
  `nr_mieszkania` varchar(40) DEFAULT NULL,
  `miasto_id_miasta` int(11) NOT NULL,
  `kod_pocztowy` varchar(6) NOT NULL,
  PRIMARY KEY (`id_adresu`),
  KEY `adres_miasto_fk` (`miasto_id_miasta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: klient (Tu był problem - teraz jest naprawiony)
CREATE TABLE `klient` (
  `id_klienta` int(11) NOT NULL AUTO_INCREMENT,
  `imie_klienta` varchar(60) NOT NULL,
  `nazwisko_klienta` varchar(60) NOT NULL,
  `telefon_klienta` char(11) NOT NULL,
  `email_klienta` varchar(70) DEFAULT NULL,
  `haslo` varchar(255) NOT NULL DEFAULT '$2y$10$U7/Fj.qFz.qFz.qFz.qFzeO5O5O5O5O5O5O5O5O5O5O5O5O5O5', -- hasło startowe: start123
  `data_dolaczenia_klienta` date NOT NULL,
  `adres_id_adresu` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_klienta`),
  KEY `klient_adres_fk` (`adres_id_adresu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: kraj
CREATE TABLE `kraj` (
  `id_kraju` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_kraju` varchar(100) NOT NULL,
  PRIMARY KEY (`id_kraju`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: media
CREATE TABLE `media` (
  `id_media` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_media` varchar(60) NOT NULL,
  `koszt` float NOT NULL,
  PRIMARY KEY (`id_media`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: miasto
CREATE TABLE `miasto` (
  `id_miasta` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_miasta` varchar(40) NOT NULL,
  `wojewodztwo_id_wojewodztwa` int(11) NOT NULL,
  PRIMARY KEY (`id_miasta`),
  KEY `miasto_wojewodztwo_fk` (`wojewodztwo_id_wojewodztwa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: mieszkanie
CREATE TABLE `mieszkanie` (
  `id_mieszkania` int(11) NOT NULL AUTO_INCREMENT,
  `metraz_mieszkania` float NOT NULL,
  `liczba_pokoi` int(11) NOT NULL,
  `status_mieszkania` varchar(60) NOT NULL,
  `cena_wynajmu` int(11) NOT NULL,
  `standard_mieszkania_id_standardu` int(11) NOT NULL,
  `adres_id_adresu` int(11) NOT NULL,
  PRIMARY KEY (`id_mieszkania`),
  KEY `mieszkanie_adres_fk` (`adres_id_adresu`),
  KEY `mieszkanie_standard_mieszkania_fk` (`standard_mieszkania_id_standardu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: mieszkanie_media
CREATE TABLE `mieszkanie_media` (
  `mieszkanie_id_mieszkania` int(11) NOT NULL,
  `media_id_media` int(11) NOT NULL,
  PRIMARY KEY (`media_id_media`,`mieszkanie_id_mieszkania`),
  KEY `mieszkanie_media_mieszkanie_fk` (`mieszkanie_id_mieszkania`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: mieszkanie_wyposazenie
CREATE TABLE `mieszkanie_wyposazenie` (
  `mieszkanie_id_mieszkania` int(11) NOT NULL,
  `wyposazenie_id_wyposazenia` int(11) NOT NULL,
  PRIMARY KEY (`wyposazenie_id_wyposazenia`,`mieszkanie_id_mieszkania`),
  KEY `mieszkanie_wyposazenie_mieszkanie_fk` (`mieszkanie_id_mieszkania`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: mieszkanie_zdjecia
CREATE TABLE `mieszkanie_zdjecia` (
  `mieszkanie_id_mieszkania` int(11) NOT NULL,
  `zdjecia_id_zdj` int(11) NOT NULL,
  `nr_zdj_mieszkania` int(11) NOT NULL,
  PRIMARY KEY (`zdjecia_id_zdj`,`mieszkanie_id_mieszkania`),
  KEY `mieszkanie_zdjecia_mieszkanie_fk` (`mieszkanie_id_mieszkania`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: platnosc
CREATE TABLE `platnosc` (
  `id_platnosci` int(11) NOT NULL AUTO_INCREMENT,
  `data_platnosci` date NOT NULL,
  `kwota` int(11) NOT NULL,
  `typ_platnosci_id_typu_platnosci` int(11) NOT NULL,
  `umowa_id_umowy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_platnosci`),
  KEY `platnosc_typ_platnosci_fk` (`typ_platnosci_id_typu_platnosci`),
  KEY `fk_platnosc_do_umowy` (`umowa_id_umowy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: pracownicy
CREATE TABLE `pracownicy` (
  `id_pracownika` int(11) NOT NULL AUTO_INCREMENT,
  `imie_pracownika` varchar(60) NOT NULL,
  `nazwisko_pracownika` varchar(60) NOT NULL,
  `telefon_pracownika` char(11) NOT NULL,
  `email_pracownika` varchar(50) NOT NULL,
  `adres_id_adresu` int(11) NOT NULL,
  `stanowisko_id_roli_pracownika` int(11) NOT NULL,
  PRIMARY KEY (`id_pracownika`),
  KEY `pracownicy_adres_fk` (`adres_id_adresu`),
  KEY `pracownicy_stanowisko_fk` (`stanowisko_id_roli_pracownika`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: rachunek/faktura
CREATE TABLE `rachunek/faktura` (
  `id_rachunku` int(11) NOT NULL AUTO_INCREMENT,
  `data_wystawienia` date NOT NULL,
  `umowa_id_umowy` int(11) NOT NULL,
  `wykorzystane_media_wykorzystane_media_id` int(11) NOT NULL,
  PRIMARY KEY (`id_rachunku`),
  KEY `Rachunek/Faktura_umowa_FK` (`umowa_id_umowy`),
  KEY `Rachunek/Faktura_wykorzystane_media_FK` (`wykorzystane_media_wykorzystane_media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: rezerwacja
CREATE TABLE `rezerwacja` (
  `id_rezerwacji` int(11) NOT NULL AUTO_INCREMENT,
  `data_rezerwacji` date NOT NULL,
  `zaliczka` int(11) NOT NULL,
  `mieszkanie_id_mieszkania` int(11) NOT NULL,
  `pracownicy_id_pracownika` int(11) NOT NULL,
  PRIMARY KEY (`id_rezerwacji`),
  KEY `rezerwacja_mieszkanie_fk` (`mieszkanie_id_mieszkania`),
  KEY `rezerwacja_pracownicy_fk` (`pracownicy_id_pracownika`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: serwis
CREATE TABLE `serwis` (
  `id_serwisu` int(11) NOT NULL AUTO_INCREMENT,
  `data_serwisu` date NOT NULL,
  `opis_serwisu` varchar(1000) NOT NULL,
  `pracownicy_id_pracownika` int(11) NOT NULL,
  PRIMARY KEY (`id_serwisu`),
  KEY `serwis_pracownicy_fk` (`pracownicy_id_pracownika`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: standard_mieszkania
CREATE TABLE `standard_mieszkania` (
  `id_standardu` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_standardu` varchar(40) NOT NULL,
  `dodatkowe_informacje` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id_standardu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: stanowisko
CREATE TABLE `stanowisko` (
  `id_roli_pracownika` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_roli_pracownika` varchar(80) NOT NULL,
  PRIMARY KEY (`id_roli_pracownika`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: status_usterki
CREATE TABLE `status_usterki` (
  `id_statusu` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_statusu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: typ_platnosci
CREATE TABLE `typ_platnosci` (
  `id_typu_platnosci` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_typu_platnosci` varchar(60) NOT NULL,
  PRIMARY KEY (`id_typu_platnosci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: umowa
CREATE TABLE `umowa` (
  `id_umowy` int(11) NOT NULL AUTO_INCREMENT,
  `data_podpisania` date NOT NULL,
  `odstepne` int(11) NOT NULL,
  `waznosc_umowy` date NOT NULL,
  `klient_id_klienta` int(11) NOT NULL,
  `pracownicy_id_pracownika` int(11) NOT NULL,
  `mieszkanie_id_mieszkania` int(11) NOT NULL,
  PRIMARY KEY (`id_umowy`),
  KEY `umowa_klient_fk` (`klient_id_klienta`),
  KEY `umowa_mieszkanie_fk` (`mieszkanie_id_mieszkania`),
  KEY `umowa_pracownicy_fk` (`pracownicy_id_pracownika`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: usterka
CREATE TABLE `usterka` (
  `id_usterki` int(11) NOT NULL AUTO_INCREMENT,
  `opis_usterki` varchar(1000) NOT NULL,
  `data_zgloszenia_usterki` date NOT NULL,
  `serwis_id_serwisu` int(11) NOT NULL,
  `mieszkanie_id_mieszkania` int(11) NOT NULL,
  `status_usterki_id_statusu` int(11) NOT NULL,
  PRIMARY KEY (`id_usterki`),
  KEY `usterka_mieszkanie_fk` (`mieszkanie_id_mieszkania`),
  KEY `usterka_serwis_fk` (`serwis_id_serwisu`),
  KEY `usterka_status_usterki_fk` (`status_usterki_id_statusu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: wojewodztwo
CREATE TABLE `wojewodztwo` (
  `id_wojewodztwa` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_wojewodztwa` varchar(35) NOT NULL,
  `kraj_id_kraju` int(11) NOT NULL,
  PRIMARY KEY (`id_wojewodztwa`),
  KEY `wojewodztwo_kraj_fk` (`kraj_id_kraju`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: wykorzystane_media
CREATE TABLE `wykorzystane_media` (
  `wykorzystane_media_id` int(11) NOT NULL AUTO_INCREMENT,
  `media_id_media` int(11) NOT NULL,
  `mieszkanie_id_mieszkania` int(11) NOT NULL,
  `wolumen` float DEFAULT NULL,
  PRIMARY KEY (`wykorzystane_media_id`),
  KEY `wykorzystane_media_media_fk` (`media_id_media`),
  KEY `wykorzystane_media_mieszkanie_fk` (`mieszkanie_id_mieszkania`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: wyposazenie
CREATE TABLE `wyposazenie` (
  `id_wyposazenia` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_wyposazenia` varchar(80) NOT NULL,
  PRIMARY KEY (`id_wyposazenia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: zdjecia
CREATE TABLE `zdjecia` (
  `id_zdj` int(11) NOT NULL AUTO_INCREMENT,
  `sciezka_do_zdjecie` varchar(100) NOT NULL,
  PRIMARY KEY (`id_zdj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- WSTAWIANIE DANYCH (INSERTY)
-- --------------------------------------------------------

INSERT INTO `adres` VALUES
(1, 'Marszalkowska', '10A', '12', 1, '00-001'),
(2, 'Polwiejska', '25', NULL, 2, '61-001'),
(3, 'Rynek Glowny', '5', '3B', 3, '31-042'),
(4, 'Karlsplatz', '22', NULL, 4, '80335'),
(5, 'Zeil', '89', '5A', 5, '60313'),
(6, 'Champs-Elysees', '128', '12', 6, '75008'),
(7, 'La Canebiere', '76', NULL, 7, '13001'),
(8, 'Via Torino', '11', NULL, 8, '20123'),
(9, 'La Rambla', '44', '7C', 9, '08002'),
(10, 'Calle Sierpes', '8', '3', 10, '41004');

INSERT INTO `klient` (`id_klienta`, `imie_klienta`, `nazwisko_klienta`, `telefon_klienta`, `email_klienta`, `data_dolaczenia_klienta`, `adres_id_adresu`) VALUES
(1, 'Jan', 'Kowalski', '12345678901', 'jan.kowalski@email.com', '2023-01-15', 1),
(2, 'Anna', 'Nowak', '23456789012', 'anna.nowak@email.com', '2023-02-20', 2),
(3, 'Piotr', 'Zielinski', '34567890123', 'piotr.zielinski@email.com', '2023-03-05', 3),
(4, 'Maria', 'Wisniewska', '45678901234', 'maria.wisniewska@email.com', '2023-04-10', 4),
(5, 'Krzysztof', 'Wojcik', '56789012345', 'krzysztof.wojcik@email.com', '2023-05-15', 5),
(6, 'Ewa', 'Kwiatkowska', '67890123456', 'ewa.kwiatkowska@email.com', '2023-06-25', 6),
(7, 'Tomasz', 'Kaminski', '78901234567', 'tomasz.kaminski@email.com', '2023-07-30', 7),
(8, 'Barbara', 'Lewandowska', '89012345678', 'barbara.lewandowska@email.com', '2023-08-10', 8),
(9, 'Rafal', 'Dabrowski', '90123456789', 'rafal.dabrowski@email.com', '2023-09-05', 9),
(10, 'Magdalena', 'Ostrowska', '01234567890', 'magdalena.ostrowska@email.com', '2023-10-12', 10);

INSERT INTO `kraj` VALUES
(1, 'Polska'), (2, 'Niemcy'), (3, 'Francja'), (4, 'Wlochy'), (5, 'Hiszpania'), 
(6, 'Czechy'), (7, 'Rosja'), (8, 'Chiny'), (9, 'Japonia'), (10, 'Indie');

INSERT INTO `media` VALUES
(1, 'Internet', 49.99), (2, 'Telefon', 29.99), (3, 'Telewizja', 79.5), (4, 'Prad', 150), 
(5, 'Woda', 100.25), (6, 'Gaz', 120.75), (7, 'Ogrzewanie', 250), (8, 'Smieci', 20), 
(9, 'Abonament RTV', 22.7), (10, 'Kanalizacja', 35.5);

INSERT INTO `miasto` VALUES
(1, 'Warszawa', 1), (2, 'Poznan', 2), (3, 'Wroclaw', 3), (4, 'Monachium', 4), 
(5, 'Frankfurt', 5), (6, 'Paryz', 6), (7, 'Marsylia', 7), (8, 'Mediolan', 8), 
(9, 'Barcelona', 9), (10, 'Sewilla', 10);

INSERT INTO `standard_mieszkania` VALUES
(1, 'Standard podstawowy', 'Mieszkanie bez dodatkowych udogodnien, podstawowe wykonczenie.'),
(2, 'Standard sredni', 'Mieszkanie z podstawowym wyposazeniem, wyzszej jakosci materialy wykonczeniowe.'),
(3, 'Standard wysoki', 'Mieszkanie z dodatkowymi udogodnieniami, np. klimatyzacja, nowoczesne wykonczenia.'),
(4, 'Standard luksusowy', 'Mieszkanie w wysokim standardzie, pelne wyposazenie, dodatkowe uslugi jak basen, silownia.'),
(5, 'Standard ekonomiczny', 'Mieszkanie w prostym standardzie, tansze materialy wykonczeniowe, mniejsze powierzchnie.'),
(6, 'Standard premium', 'Mieszkanie o najwyzszym standardzie, designerskie wykonczenie, inteligentne systemy domu.');

INSERT INTO `mieszkanie` VALUES
(1, 45.5, 2, 'Wynajmowane', 1500, 3, 1),
(2, 60, 3, 'Wynajmowane', 2500, 4, 2),
(3, 30, 1, 'Dostepne', 1200, 2, 3),
(4, 80, 4, 'Wynajmowane', 3500, 5, 4),
(5, 50.5, 2, 'Dostepne', 1700, 3, 5),
(6, 100, 5, 'Wynajmowane', 4500, 6, 6),
(7, 70, 3, 'Dostepne', 2200, 4, 7),
(8, 55, 2, 'Wynajmowane', 1900, 2, 8),
(9, 40, 2, 'Dostepne', 1600, 3, 9),
(10, 90, 4, 'Wynajmowane', 3700, 5, 10);

INSERT INTO `mieszkanie_media` VALUES
(2, 1), (4, 1), (6, 1), (9, 1), (1, 2), (4, 2), (5, 2), (7, 2), (10, 2),
(1, 3), (3, 3), (8, 3), (10, 3), (2, 4), (5, 4), (7, 4), (9, 4), (3, 5), (6, 5), (8, 5);

INSERT INTO `wyposazenie` VALUES
(1, 'Klimatyzacja'), (2, 'Nawigacja GPS'), (3, 'Podgrzewane fotele'), (4, 'Radio FM/AM'),
(5, 'Czujniki parkowania'), (6, 'Kamera cofania'), (7, 'Panoramiczny dach'),
(8, 'System audio premium'), (9, 'Tempomat'), (10, 'Bluetooth');

INSERT INTO `mieszkanie_wyposazenie` VALUES
(2, 1), (6, 1), (1, 2), (5, 2), (9, 2), (2, 3), (7, 3), (1, 4), (8, 4),
(3, 5), (7, 5), (4, 6), (10, 6), (3, 7), (10, 7), (4, 8), (8, 8), (5, 9), (9, 9), (6, 10);

INSERT INTO `typ_platnosci` VALUES
(1, 'Gotowka'), (2, 'Karta platnicza'), (3, 'Przelew bankowy'), (4, 'Blik'),
(5, 'PayPal'), (6, 'Kryptowaluty'), (7, 'Platnosc za pobraniem');

INSERT INTO `stanowisko` VALUES
(1, 'Kierownik'), (2, 'Programista'), (3, 'Specjalista ds. marketingu'), (4, 'Analityk'),
(5, 'HR Manager'), (6, 'Asystent biura'), (7, 'Tester oprogramowania'), (8, 'Dyrektor finansowy'),
(9, 'Project Manager'), (10, 'Administrator systemu');

INSERT INTO `pracownicy` VALUES
(1, 'Marek', 'Zawisza', '12345678901', 'marek.zawisza@email.com', 1, 1),
(2, 'Anna', 'Kwiatkowska', '23456789012', 'anna.kwiatkowska@email.com', 2, 2),
(3, 'Piotr', 'Bak', '34567890123', 'piotr.bak@email.com', 3, 3),
(4, 'Karolina', 'Nowak', '45678901234', 'karolina.nowak@email.com', 4, 4),
(5, 'Tomasz', 'Lewandowski', '56789012345', 'tomasz.lewandowski@email.com', 5, 5),
(6, 'Ewa', 'Gorska', '67890123456', 'ewa.gorska@email.com', 6, 1),
(7, 'Michał', 'Wojcik', '78901234567', 'michal.wojcik@email.com', 7, 2),
(8, 'Alicja', 'Ostrowska', '89012345678', 'alicja.ostrowska@email.com', 8, 3),
(9, 'Robert', 'Michałowski', '90123456789', 'robert.michalowski@email.com', 9, 4),
(10, 'Magdalena', 'Zielinska', '01234567890', 'magdalena.zielinska@email.com', 10, 5);

INSERT INTO `umowa` VALUES
(1, '2023-01-01', 500, '2024-01-01', 1, 1, 1),
(2, '2023-02-10', 300, '2024-02-10', 2, 2, 2),
(3, '2023-03-15', 700, '2024-03-15', 3, 3, 3),
(4, '2023-04-05', 400, '2024-04-05', 4, 4, 4),
(5, '2023-05-20', 600, '2024-05-20', 5, 5, 5),
(6, '2023-06-10', 550, '2024-06-10', 6, 6, 6),
(7, '2023-07-01', 450, '2024-07-01', 7, 7, 7);

INSERT INTO `platnosc` VALUES
(1, '2025-01-10', 150, 1, 1),
(2, '2025-01-11', 250, 2, 2),
(3, '2025-01-12', 400, 3, 3),
(4, '2025-01-13', 300, 4, 4),
(5, '2025-01-14', 120, 5, 5),
(6, '2025-01-14', 500, 6, 6),
(7, '2025-01-15', 200, 7, 7);

INSERT INTO `wykorzystane_media` VALUES
(1, 1, 1, 15.5), (2, 2, 1, 50), (3, 3, 1, 120), (4, 1, 2, 18.75), (5, 4, 2, 220), 
(6, 2, 3, 55.5), (7, 5, 3, 100), (8, 3, 4, 110), (9, 1, 4, 19.25), (10, 4, 5, 215), 
(11, 2, 5, 45), (12, 1, 6, 17.3), (13, 5, 6, 95), (14, 3, 7, 130), (15, 4, 7, 210), 
(16, 2, 8, 60), (17, 1, 8, 21.1), (18, 3, 9, 115), (19, 5, 9, 90.5), (20, 4, 10, 220);

INSERT INTO `rachunek/faktura` VALUES
(1, '2023-01-15', 1, 1), (2, '2023-02-20', 2, 2), (3, '2023-03-05', 3, 3), (4, '2023-04-10', 4, 4),
(5, '2023-05-15', 5, 5), (6, '2023-06-25', 6, 6), (7, '2023-07-30', 7, 7);

INSERT INTO `rezerwacja` VALUES
(1, '2023-01-15', 500, 1, 1), (2, '2023-02-20', 300, 2, 2), (3, '2023-03-05', 400, 3, 3), (4, '2023-04-10', 250, 4, 4),
(5, '2023-05-15', 350, 5, 5), (6, '2023-06-25', 600, 6, 1), (7, '2023-07-30', 200, 7, 2), (8, '2023-08-10', 150, 8, 3),
(9, '2023-09-05', 450, 9, 4), (10, '2023-10-12', 500, 10, 5);

INSERT INTO `serwis` VALUES
(1, '2023-01-10', 'Wymiana uszkodzonego zamka w drzwiach wejsciowych mieszkania', 1),
(2, '2023-02-15', 'Naprawa awarii instalacji wodociagowej w kuchni', 2),
(3, '2023-03-20', 'Montaz nowego systemu grzewczego w łazience', 3),
(4, '2023-04-25', 'Naprawa instalacji elektrycznej w całym mieszkaniu', 4),
(5, '2023-05-30', 'Przeglad techniczny klimatyzacji', 5),
(6, '2023-06-05', 'Wymiana okien w sypialni', 6),
(7, '2023-07-15', 'Usuwanie awarii systemu alarmowego', 7),
(8, '2023-08-10', 'Montaz nowych drzwi w salonie', 8),
(9, '2023-09-10', 'Naprawa pieca grzewczego', 9),
(10, '2023-10-05', 'Konserwacja systemu wentylacji w mieszkaniu', 10);

INSERT INTO `status_usterki` VALUES
(1, 'Nowa'), (2, 'W trakcie'), (3, 'Naprawiona'), (4, 'Zakonczona'), (5, 'Odrzucona'), (6, 'Anulowana');

INSERT INTO `usterka` VALUES
(1, 'Zamek w drzwiach wejsciowych nie działa', '2023-01-10', 1, 1, 1),
(2, 'Nieszczelny kran w kuchni', '2023-02-15', 2, 2, 2),
(3, 'Awaria instalacji elektrycznej w salonie', '2023-03-20', 3, 3, 2),
(4, 'Uszkodzony piec grzewczy', '2023-04-05', 4, 4, 3),
(5, 'Zepsuta klimatyzacja w sypialni', '2023-05-10', 5, 5, 2),
(6, 'Nie działa system alarmowy', '2023-06-12', 6, 6, 4),
(7, 'Zatkany odpływ w łazience', '2023-07-18', 7, 7, 1),
(8, 'Uszkodzony system wentylacji', '2023-08-08', 8, 8, 3),
(9, 'Problem z ogrzewaniem w łazience', '2023-09-02', 9, 9, 4),
(10, 'Peknieta szyba w oknie salonu', '2023-10-11', 10, 10, 5);

INSERT INTO `wojewodztwo` VALUES
(1, 'Mazowieckie', 1), (2, 'Wielkopolskie', 1), (3, 'Dolnoslaskie', 1), (4, 'Bawaria', 2),
(5, 'Hesja', 2), (6, 'Ile-de-France', 3), (7, 'Prowansja-Alpy-Lazurowe Wybrzeze', 3), (8, 'Lombardia', 4),
(9, 'Katalonia', 5), (10, 'Andaluzja', 5);

-- --------------------------------------------------------
-- DEFINICJE KLUCZY OBCYCH (DODANE PO STWORZENIU TABEL)
-- --------------------------------------------------------

ALTER TABLE `adres` ADD CONSTRAINT `adres_miasto_fk` FOREIGN KEY (`miasto_id_miasta`) REFERENCES `miasto` (`id_miasta`);
ALTER TABLE `klient` ADD CONSTRAINT `klient_adres_fk` FOREIGN KEY (`adres_id_adresu`) REFERENCES `adres` (`id_adresu`);
ALTER TABLE `miasto` ADD CONSTRAINT `miasto_wojewodztwo_fk` FOREIGN KEY (`wojewodztwo_id_wojewodztwa`) REFERENCES `wojewodztwo` (`id_wojewodztwa`);
ALTER TABLE `mieszkanie` ADD CONSTRAINT `mieszkanie_adres_fk` FOREIGN KEY (`adres_id_adresu`) REFERENCES `adres` (`id_adresu`), ADD CONSTRAINT `mieszkanie_standard_mieszkania_fk` FOREIGN KEY (`standard_mieszkania_id_standardu`) REFERENCES `standard_mieszkania` (`id_standardu`);
ALTER TABLE `mieszkanie_media` ADD CONSTRAINT `mieszkanie_media_media_fk` FOREIGN KEY (`media_id_media`) REFERENCES `media` (`id_media`), ADD CONSTRAINT `mieszkanie_media_mieszkanie_fk` FOREIGN KEY (`mieszkanie_id_mieszkania`) REFERENCES `mieszkanie` (`id_mieszkania`);
ALTER TABLE `mieszkanie_wyposazenie` ADD CONSTRAINT `mieszkanie_wyposazenie_mieszkanie_fk` FOREIGN KEY (`mieszkanie_id_mieszkania`) REFERENCES `mieszkanie` (`id_mieszkania`), ADD CONSTRAINT `mieszkanie_wyposazenie_wyposazenie_fk` FOREIGN KEY (`wyposazenie_id_wyposazenia`) REFERENCES `wyposazenie` (`id_wyposazenia`);
ALTER TABLE `mieszkanie_zdjecia` ADD CONSTRAINT `mieszkanie_zdjecia_mieszkanie_fk` FOREIGN KEY (`mieszkanie_id_mieszkania`) REFERENCES `mieszkanie` (`id_mieszkania`), ADD CONSTRAINT `mieszkanie_zdjecia_zdjecia_fk` FOREIGN KEY (`zdjecia_id_zdj`) REFERENCES `zdjecia` (`id_zdj`);
ALTER TABLE `platnosc` ADD CONSTRAINT `fk_platnosc_do_umowy` FOREIGN KEY (`umowa_id_umowy`) REFERENCES `umowa` (`id_umowy`), ADD CONSTRAINT `platnosc_typ_platnosci_fk` FOREIGN KEY (`typ_platnosci_id_typu_platnosci`) REFERENCES `typ_platnosci` (`id_typu_platnosci`);
ALTER TABLE `pracownicy` ADD CONSTRAINT `pracownicy_adres_fk` FOREIGN KEY (`adres_id_adresu`) REFERENCES `adres` (`id_adresu`), ADD CONSTRAINT `pracownicy_stanowisko_fk` FOREIGN KEY (`stanowisko_id_roli_pracownika`) REFERENCES `stanowisko` (`id_roli_pracownika`);
ALTER TABLE `rachunek/faktura` ADD CONSTRAINT `Rachunek/Faktura_umowa_FK` FOREIGN KEY (`umowa_id_umowy`) REFERENCES `umowa` (`id_umowy`), ADD CONSTRAINT `Rachunek/Faktura_wykorzystane_media_FK` FOREIGN KEY (`wykorzystane_media_wykorzystane_media_id`) REFERENCES `wykorzystane_media` (`wykorzystane_media_id`);
ALTER TABLE `rezerwacja` ADD CONSTRAINT `rezerwacja_mieszkanie_fk` FOREIGN KEY (`mieszkanie_id_mieszkania`) REFERENCES `mieszkanie` (`id_mieszkania`), ADD CONSTRAINT `rezerwacja_pracownicy_fk` FOREIGN KEY (`pracownicy_id_pracownika`) REFERENCES `pracownicy` (`id_pracownika`);
ALTER TABLE `serwis` ADD CONSTRAINT `serwis_pracownicy_fk` FOREIGN KEY (`pracownicy_id_pracownika`) REFERENCES `pracownicy` (`id_pracownika`);
ALTER TABLE `umowa` ADD CONSTRAINT `umowa_klient_fk` FOREIGN KEY (`klient_id_klienta`) REFERENCES `klient` (`id_klienta`), ADD CONSTRAINT `umowa_mieszkanie_fk` FOREIGN KEY (`mieszkanie_id_mieszkania`) REFERENCES `mieszkanie` (`id_mieszkania`), ADD CONSTRAINT `umowa_pracownicy_fk` FOREIGN KEY (`pracownicy_id_pracownika`) REFERENCES `pracownicy` (`id_pracownika`);
ALTER TABLE `usterka` ADD CONSTRAINT `usterka_mieszkanie_fk` FOREIGN KEY (`mieszkanie_id_mieszkania`) REFERENCES `mieszkanie` (`id_mieszkania`), ADD CONSTRAINT `usterka_serwis_fk` FOREIGN KEY (`serwis_id_serwisu`) REFERENCES `serwis` (`id_serwisu`), ADD CONSTRAINT `usterka_status_usterki_fk` FOREIGN KEY (`status_usterki_id_statusu`) REFERENCES `status_usterki` (`id_statusu`);
ALTER TABLE `wojewodztwo` ADD CONSTRAINT `wojewodztwo_kraj_fk` FOREIGN KEY (`kraj_id_kraju`) REFERENCES `kraj` (`id_kraju`);
ALTER TABLE `wykorzystane_media` ADD CONSTRAINT `wykorzystane_media_media_fk` FOREIGN KEY (`media_id_media`) REFERENCES `media` (`id_media`), ADD CONSTRAINT `wykorzystane_media_mieszkanie_fk` FOREIGN KEY (`mieszkanie_id_mieszkania`) REFERENCES `mieszkanie` (`id_mieszkania`);

-- Przywracamy sprawdzanie kluczy
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;