<?php
// Ten plik nie ma wyglądu - on tylko zwraca dane dla index.html
header('Content-Type: application/json');

// 1. Połączenie z bazą (Twoja nazwa: agencja_finalowa)
$polaczenie = mysqli_connect('localhost', 'root', '', 'agencja_finalowa');

if (!$polaczenie) {
    echo json_encode([]); // W razie błędu zwróć pustą listę
    exit;
}

// 2. Pobranie wszystkich mieszkań
$sql = "SELECT * FROM mieszkanie";
$wynik = mysqli_query($polaczenie, $sql);

$mieszkania = [];
while ($wiersz = mysqli_fetch_assoc($wynik)) {
    $mieszkania[] = $wiersz;
}

// 3. Wysłanie danych do JavaScript
echo json_encode($mieszkania);

mysqli_close($polaczenie);
?>