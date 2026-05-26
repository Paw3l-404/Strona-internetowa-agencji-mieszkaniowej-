<?php
// PLIK: backend/auth.php
session_start();
header('Content-Type: application/json');

// Połączenie z bazą
$host = 'localhost';
$db_name = 'agencja_finalowa';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(['success' => false, 'message' => 'Błąd bazy: ' . $e->getMessage()]));
}

// Odczyt danych z JSON
$input = json_decode(file_get_contents('php://input'), true);

if (isset($input['email']) && isset($input['password'])) {
    $email = $input['email'];
    $pass = $input['password'];

    $stmt = $pdo->prepare("SELECT id_klienta, imie_klienta, haslo FROM klient WHERE email_klienta = :email");
    $stmt->execute(['email' => $email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($pass, $user['haslo'])) {
        $_SESSION['user_id'] = $user['id_klienta'];
        $_SESSION['user_name'] = $user['imie_klienta'];

        echo json_encode([
            'success' => true,
            'message' => 'Zalogowano!',
            'user_name' => $user['imie_klienta'],
            'redirect' => '../public/index.html'  // Dostosuj jeśli struktura inna
        ]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Błędny email lub hasło']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Brak danych logowania']);
}
?>