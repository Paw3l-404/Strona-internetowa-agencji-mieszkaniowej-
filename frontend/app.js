document.addEventListener('DOMContentLoaded', function() {
    
    // --- CZĘŚĆ A: Obsługa Logowania (tylko na stronie logowania) ---
    const loginForm = document.getElementById('loginForm');
    
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();

            // Upewnij się, że w HTML inputy mają id="email" i id="password"
            const emailVal = document.getElementById('email').value;
            const passVal = document.getElementById('password').value;

            // Ustal ścieżkę do backendu (zależnie czy jesteś w folderze public czy frontend)
            // Zakładam, że pliki backend są katalog wyżej w ../backend/
            const apiUrl = '../backend/auth.php'; 

            fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email: emailVal, password: passVal })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Zapisz imię w przeglądarce
                    localStorage.setItem('klient_imie', data.user_name);
                    // Przekieruj na stronę główną
                    window.location.href = data.redirect;
                } else {
                    alert(data.message);
                }
            })
            .catch(err => console.error('Błąd:', err));
        });
    }

    // --- CZĘŚĆ B: Wyświetlanie Imienia i Wylogowanie (na każdej stronie) ---
    const imieKlienta = localStorage.getItem('klient_imie');

    if (imieKlienta) {
        // Szukamy wszystkich linków
        const linki = document.querySelectorAll('a');
        
        linki.forEach(link => {
            // Szukamy linku, który ma tekst "Zaloguj" (lub Zaloguj się)
            if (link.textContent.toLowerCase().includes('zaloguj')) {
                // Zmieniamy tekst
                link.textContent = `Cześć, ${imieKlienta}!`;
                link.href = "#"; // Blokujemy przejście
                link.style.fontWeight = 'bold';
                
                // Dodajemy obsługę wylogowania
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    if (confirm("Czy chcesz się wylogować?")) {
                        // 1. Usuń z localStorage
                        localStorage.removeItem('klient_imie');
                        // 2. Usuń sesję PHP
                        fetch('../backend/logout.php')
                            .then(() => window.location.reload()) // Odśwież stronę
                            .catch(() => window.location.reload());
                    }
                });
            }
        });
    }
});