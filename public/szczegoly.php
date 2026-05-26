<?php
    // --- 1. POŁĄCZENIE Z BAZĄ DANYCH ---
    $polaczenie = mysqli_connect('localhost', 'root', '', 'agencja_finalowa');

    if (!$polaczenie) {
        die("Błąd połączenia z bazą: " . mysqli_connect_error());
    }

    // --- 2. POBIERANIE DANYCH Z ŁĄCZENIEM 3 TABEL ---
    if (isset($_GET['id'])) {
        $id = intval($_GET['id']);
        
        // ZAPYTANIE SQL:
        // 1. Pobierz mieszkanie
        // 2. Dołącz Adres (po id_adresu)
        // 3. Dołącz Standard (po id_standardu)
        $sql = "SELECT * FROM mieszkanie 
                LEFT JOIN adres ON mieszkanie.adres_id_adresu = adres.id_adresu 
                LEFT JOIN standard_mieszkania ON mieszkanie.standard_mieszkania_id_standardu = standard_mieszkania.id_standardu
                WHERE id_mieszkania = $id";
        
        $wynik = mysqli_query($polaczenie, $sql);
        $wiersz = mysqli_fetch_assoc($wynik);
    }
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Szczegóły ogłoszenia</title>
    
    <style>
        body {
            background-color: #121212;
            color: #e0e0e0;
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .szczegoly-box {
            background-color: #1e1e1e;
            width: 100%;
            max-width: 500px;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0, 0.7);
            border: 1px solid #333;
        }
        h1 {
            text-align: center;
            color: #ffffff;
            margin-top: 0;
            font-size: 28px;
            border-bottom: 2px solid #333;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        .dane-wiersz {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #2a2a2a;
            font-size: 16px;
        }
        .etykieta { color: #9e9e9e; }
        .wartosc { color: #ffffff; font-weight: bold; text-align: right; }
        .cena { color: #4CAF50; font-size: 18px; }
        .przycisk-powrot { margin-top: 30px; text-align: center; }
        .btn {
            background-color: #3a86ff;
            color: #e0e0e0;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: bold;
            transition: 0.3s;
            display: inline-block;
        }
        .btn:hover { background-color: #9965f4; }
    </style>
</head>
<body>

    <div class="szczegoly-box">
        <?php if (isset($wiersz) && $wiersz): ?>
            
            <h1>Mieszkanie nr <?php echo $wiersz['id_mieszkania']; ?></h1>
            
            <div class="dane-wiersz">
                <span class="etykieta">Status:</span>
                <span class="wartosc"><?php echo $wiersz['status_mieszkania']; ?></span>
            </div>

            <div class="dane-wiersz">
                <span class="etykieta">Cena wynajmu:</span>
                <span class="wartosc cena"><?php echo number_format($wiersz['cena_wynajmu'], 2, ',', ' '); ?> PLN</span>
            </div>

            <div class="dane-wiersz">
                <span class="etykieta">Metraż:</span>
                <span class="wartosc"><?php echo $wiersz['metraz_mieszkania']; ?> m²</span>
            </div>

            <div class="dane-wiersz">
                <span class="etykieta">Liczba pokoi:</span>
                <span class="wartosc"><?php echo $wiersz['liczba_pokoi']; ?></span>
            </div>
            
            <div class="dane-wiersz">
               <span class="etykieta">Standard:</span>
               <span class="wartosc">
                   <?php echo $wiersz['nazwa_standardu']; ?>
               </span>
            </div>

             <div class="dane-wiersz">
               <span class="etykieta">Adres:</span>
               <span class="wartosc">
                   <?php 
                        echo $wiersz['ulica'] . ' ' . $wiersz['nr_domu'];
                        if(!empty($wiersz['nr_mieszkania'])) {
                            echo '/' . $wiersz['nr_mieszkania'];
                        }
                        echo '<br><small style="color:#888;">' . $wiersz['kod_pocztowy'] . '</small>';
                   ?>
               </span>
            </div>

            <div class="przycisk-powrot">
                <a href="index.html" class="btn">Powrót do listy</a>
            </div>

        <?php else: ?>
            <h1 style="border:none;">Brak danych</h1>
            <p style="text-align:center;">Nie znaleziono mieszkania o takim ID.</p>
            <div class="przycisk-powrot">
                <a href="index.html" class="btn">Wróć</a>
            </div>
        <?php endif; ?>
    </div>

    <?php mysqli_close($polaczenie); ?>

</body>
</html>