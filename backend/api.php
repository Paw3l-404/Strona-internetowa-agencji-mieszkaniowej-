<?php
// Plik: backend/api.php
require 'config.php';

$action = $_GET['action'] ?? null;
$response = ['status' => 'error', 'message' => 'Nieznana akcja'];

try {
    switch ($action) {

        // --- AUTH: REJESTRACJA ---
        case 'register':
            $data = json_decode(file_get_contents('php://input'), true);
            
            // Walidacja podstawowa
            if (empty($data['imie']) || empty($data['nazwisko']) || empty($data['email']) || empty($data['password'])) {
                throw new Exception('Wypełnij wszystkie pola.');
            }

            // Sprawdź czy email już istnieje
            $stmt = $pdo->prepare("SELECT id_klienta FROM klient WHERE email_klienta = ?");
            $stmt->execute([$data['email']]);
            if ($stmt->fetch()) {
                throw new Exception('Konto z tym adresem email już istnieje.');
            }

            // Hashowanie hasła (bezpieczeństwo!)
            $hashedPassword = password_hash($data['password'], PASSWORD_DEFAULT);

            // Wstawianie do bazy (Adres ID 1 jako domyślny, telefon "000" tymczasowo)
            $sql = "INSERT INTO klient (imie_klienta, nazwisko_klienta, telefon_klienta, email_klienta, haslo, data_dolaczenia_klienta, adres_id_adresu) 
                    VALUES (?, ?, '000000000', ?, ?, CURDATE(), 1)";
            
            $stmt = $pdo->prepare($sql);
            $stmt->execute([$data['imie'], $data['nazwisko'], $data['email'], $hashedPassword]);

            $response = ['status' => 'success', 'message' => 'Konto utworzone pomyślnie. Możesz się zalogować.'];
            break;

        // --- AUTH: LOGOWANIE ---
        case 'login':
            $data = json_decode(file_get_contents('php://input'), true);
            $email = $data['email'] ?? '';
            $pass = $data['password'] ?? '';

            $stmt = $pdo->prepare("SELECT * FROM klient WHERE email_klienta = ?");
            $stmt->execute([$email]);
            $user = $stmt->fetch();

            if ($user && password_verify($pass, $user['haslo'])) {
                // Logowanie poprawne -> zapisz w sesji
                $_SESSION['user_id'] = $user['id_klienta'];
                $_SESSION['user_name'] = $user['imie_klienta'] . ' ' . $user['nazwisko_klienta'];
                $_SESSION['user_email'] = $user['email_klienta'];

                $response = [
                    'status' => 'success', 
                    'message' => 'Zalogowano pomyślnie.',
                    'user' => [
                        'name' => $_SESSION['user_name'],
                        'email' => $_SESSION['user_email']
                    ]
                ];
            } else {
                throw new Exception('Błędny login lub hasło.');
            }
            break;

        // --- AUTH: SPRAWDŹ CZY ZALOGOWANY ---
        case 'check_session':
            if (isset($_SESSION['user_id'])) {
                $response = [
                    'status' => 'logged_in',
                    'user' => [
                        'name' => $_SESSION['user_name'],
                        'email' => $_SESSION['user_email']
                    ]
                ];
            } else {
                $response = ['status' => 'guest'];
            }
            break;

        // --- AUTH: WYLOGUJ ---
        case 'logout':
            session_destroy();
            $response = ['status' => 'success', 'message' => 'Wylogowano.'];
            break;

        // --- ISTNIEJĄCE AKCJE (BEZ ZMIAN) ---
        case 'list_wolne_mieszkania':
            $stmt = $pdo->query("
                SELECT m.*, a.ulica, a.nr_domu, mi.nazwa_miasta, s.nazwa_standardu
                FROM mieszkanie m
                JOIN adres a ON m.adres_id_adresu = a.id_adresu
                JOIN miasto mi ON a.miasto_id_miasta = mi.id_miasta
                JOIN standard_mieszkania s ON m.standard_mieszkania_id_standardu = s.id_standardu
                WHERE m.status_mieszkania = 'Dostepne'
                ORDER BY m.cena_wynajmu
            ");
            $response = ['status' => 'success', 'data' => $stmt->fetchAll()];
            break;

        // ... Reszta kodu (submit_rezerwacja itp.) pozostaje bez zmian ...
        // Uwaga: W submit_rezerwacja warto dodać obsługę user_id z sesji, 
        // ale na potrzeby zadania logowania/rejestracji to wystarczy.

        default:
            // Obsługa nieznanej akcji wewnątrz switcha lub pusta
            if ($action !== 'register' && $action !== 'login' && $action !== 'check_session' && $action !== 'logout' && $action !== 'list_wolne_mieszkania') {
                 // Tu możesz wkleić resztę starego kodu switcha (list_mieszkania itp dla admina)
                 // lub po prostu zostawić obsługę błedu jeśli to tylko plik dla klienta.
            }
            break;
    }
} catch (Exception $e) {
    $response['message'] = $e->getMessage();
}

echo json_encode($response);
?>