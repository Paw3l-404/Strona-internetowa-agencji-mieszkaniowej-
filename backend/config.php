<?php
// backend/config.php

// Ustawienia bazy danych - domyślne dla XAMPP
$host = 'localhost';
$db_name = 'agencja_finalowa'; // Nazwa z Twojego zrzutu ekranu
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8", $username, $password);
    // Ustawienie trybu błędów na wyjątki
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    // W przypadku błędu zwróć JSON i zakończ
    die(json_encode(['success' => false, 'message' => 'Błąd połączenia z bazą: ' . $e->getMessage()]));
}
?>