# 🏠 SzybkieMieszkanie.pl - System zarządzania agencją mieszkaniową

Projekt przedstawia w pełni działającą witrynę internetową agencji nieruchomości, zrealizowaną w architekturze klient-serwer. Celem projektu było stworzenie aplikacji internetowej z dużym naciskiem na zapewnienie jej odpowiednich zabezpieczeń i ochrony danych użytkowników. 

Projekt został zrealizowany na Wydziale Matematyki i Fizyki Stosowanej Politechniki Rzeszowskiej.

## 🛠️ Wykorzystane Technologie

* **Backend:** PHP (wykorzystujący pliki takie jak `api.php`, `auth.php`, `config.php`).
* **Frontend:** HTML, CSS (`style.css`), JavaScript (`app.js`).
* **Baza danych:** MySQL.

## ✨ Główne Funkcjonalności

* **Przeglądanie ofert:** Dostęp do bazy mieszkań ze szczegółowymi informacjami (metraż, liczba pokoi, cena, standard), do których dostęp mają tylko zalogowani użytkownicy.
* **Logowanie:** System logowania z mechanizmem obronnym nakładającym blokadę czasową na 60 sekund po 3 nieudanych próbach wpisania danych.
* **Rejestracja:** System dodawania nowych użytkowników wyposażony w walidację formatu adresu e-mail oraz wymagający hasła o długości minimum 6 znaków.
* **Wylogowywanie:** Bezpieczne usuwanie sesji użytkownika z systemu po wylogowaniu.
* **Ułatwienia dostępu (A11y):** Przyciski do zmiany rozmiaru czcionki, tryb wysokiego kontrastu oraz możliwość sterowania za pomocą skrótów klawiszowych.
* **Kontakt:** Stopka z danymi kontaktowymi, formularzem oraz interaktywną mapą z lokalizacją biura agencji.

## 🛡️ Architektura i Bezpieczeństwo (Security by Design)

Projekt kładzie duży nacisk na bezpieczeństwo od samego początku projektowania. Zaimplementowano następujące warstwy ochronne:

* **Ochrona przed SQL Injection:** Zastosowano bibliotekę PDO oraz zapytania przygotowane (Prepared Statements), co całkowicie uniemożliwia wstrzyknięcie złośliwego kodu SQL do bazy.
* **Bezpieczeństwo haseł:** Dane uwierzytelniające nie są zapisywane jawnym tekstem; poddawane są procesowi haszowania za pomocą silnej funkcji `password_hash()`.
* **Ochrona przed CSRF:** Wdrożono model Synchronizer Token Pattern generujący unikalne, losowe tokeny sesyjne sprawdzane przy każdej próbie logowania lub rejestracji.
* **Ochrona przed botami:** Zaimplementowano rozwiązanie Cloudflare Turnstile, które odróżnia człowieka od zautomatyzowanego skryptu bez konieczności rozwiązywania graficznych zagadek CAPTCHA.
* **Zarządzanie sesjami:** Bezpieczne mechanizmy autoryzacji chroniące przed atakami typu session hijacking poprzez dokładne niszczenie sesji po stronie serwera przy wylogowywaniu.

## 📂 Struktura Katalogów

* **`Backend/`**: Zawiera pliki kluczowe dla logiki strony i działania biznesowego API.
* **`Frontend/`**: Obejmuje pliki odpowiedzialne za wizualną prezentację strony oraz dynamiczną komunikację JavaScript z API.
* **`Baza danych/`**: Plik backupu (dump bazy), który należy zaimportować do serwera MySQL, aby poprawnie połączyć się z witryną.

## 🧪 Audyt i Testy

Aplikacja przeszła rygorystyczne testy bezpieczeństwa i jakości kodu:
* Kod HTML poddano walidacji narzędziem **Nu HTML Checker** pod kątem zgodności ze standardami HTML5.
* Przeprowadzono testy penetracyjne (pasywne i aktywne) przy użyciu skanera **OWASP ZAP (DAST)**.

## 👥 Autorzy

* Mateusz Gałda
* Paweł Górski
