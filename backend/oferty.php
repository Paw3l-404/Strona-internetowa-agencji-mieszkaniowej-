<?php
// PLIK: agencja/backend/oferty.php
require_once 'config.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

try {
    // Pobieramy mieszkania wraz z miastem i ulicą (łączenie tabel JOIN)
    $sql = "SELECT 
                m.id_mieszkania, 
                m.metraz_mieszkania, 
                m.liczba_pokoi, 
                m.cena_wynajmu, 
                m.status_mieszkania,
                a.ulica,
                mi.nazwa_miasta
            FROM mieszkanie m
            JOIN adres a ON m.adres_id_adresu = a.id_adresu
            JOIN miasto mi ON a.miasto_id_miasta = mi.id_miasta";

    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    $mieszkania = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode(["success" => true, "data" => $mieszkania], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Błąd bazy: " . $e->getMessage()]);
}
?>