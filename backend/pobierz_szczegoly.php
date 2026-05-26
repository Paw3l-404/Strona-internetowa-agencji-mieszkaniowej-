<?php
// backend/pobierz_szczegoly.php
header('Content-Type: application/json; charset=utf-8');
require_once 'config.php'; // Zakładam, że tu masz połączenie $pdo lub $conn

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($id > 0) {
    try {
        // ZAPYTANIE SQL - Dostosowane do Twoich nazw kolumn z poprzedniego app.js
        // Zakładam, że masz tabele połączone lub widok, który zwraca miasto i ulicę.
        // Jeśli nie, musisz dostosować JOINy. Poniżej bezpieczna wersja:
        
        $sql = "SELECT 
                    m.id_mieszkania, 
                    m.metraz_mieszkania, 
                    m.pietro, 
                    m.liczba_pokoi, 
                    m.cena_wynajmu, 
                    m.status_mieszkania,
                    m.opis, -- Zakładam, że masz kolumnę opis, jeśli nie - usuń to
                    a.ulica, 
                    mi.nazwa_miasta
                FROM mieszkania m
                LEFT JOIN adresy a ON m.id_adresu = a.id_adresu
                LEFT JOIN miasta mi ON a.id_miasta = mi.id_miasta
                WHERE m.id_mieszkania = :id";

        $stmt = $pdo->prepare($sql); // Używam $pdo z config.php
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();
        
        $mieszkanie = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($mieszkanie) {
            echo json_encode(['success' => true, 'data' => $mieszkanie]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Nie znaleziono oferty']);
        }

    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Błąd bazy: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Błędne ID']);
}
?>