document.addEventListener('DOMContentLoaded', function() {
    console.log("Skrypt app.js został załadowany poprawnie.");

    // --- LOGOWANIE ---
    const loginForm = document.getElementById('loginForm');
    const loginSection = document.getElementById('login-section');
    const registerSection = document.getElementById('register-section');
    const switchToRegister = document.getElementById('switch-to-register');
    const switchToLogin = document.getElementById('switch-to-login');

    if (!loginForm) {
        console.error("BŁĄD KRYTYCZNY: Nie znaleziono formularza o id='loginForm' w pliku HTML!");
    } else {
        console.log("Sukces: Znaleziono formularz logowania. Podpinam obsługę.");
        
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault(); 
            console.log("Kliknięto przycisk 'Zaloguj' - JavaScript przejmuje kontrolę.");

            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const messageBox = document.getElementById('message');

            if (!emailInput || !passwordInput) {
                console.error("Błąd: Nie znaleziono inputów o id='email' lub id='password'");
                if(messageBox) messageBox.innerText = "Błąd formularza (brak ID w polach).";
                return;
            }

            const emailVal = emailInput.value;
            const passVal = passwordInput.value;

            console.log("Wysyłanie zapytania do serwera...");

            fetch('../backend/api.php?action=login', {  // Użyj api.php z action=login
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email: emailVal, password: passVal })
            })
            .then(response => {
                console.log("Otrzymano odpowiedź z serwera (status):", response.status);
                return response.json();
            })
            .then(data => {
                console.log("Dane z serwera:", data);
                if (data.status === 'success') {
                    localStorage.setItem('klient_imie', data.user.name);
                    window.location.href = '../public/index.html';  // Przekierowanie po logowaniu
                } else {
                    if (messageBox) messageBox.innerText = data.message;
                    else alert(data.message);
                }
            })
            .catch(error => {
                console.error('Błąd połączenia:', error);
                if (messageBox) messageBox.innerText = "Błąd połączenia z serwerem. Sprawdź konsolę (F12).";
            });
        });
    }

    // --- REJESTRACJA ---
    const registerForm = document.getElementById('registerForm');

    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log("Kliknięto przycisk 'Zarejestruj się'.");

            const imieInput = document.getElementById('imie');
            const nazwiskoInput = document.getElementById('nazwisko');
            const emailInput = document.getElementById('reg-email');
            const passwordInput = document.getElementById('reg-password');
            const regMessageBox = document.getElementById('reg-message');

            if (!imieInput.value || !nazwiskoInput.value || !emailInput.value || !passwordInput.value) {
                regMessageBox.innerText = "Wypełnij wszystkie pola.";
                return;
            }

            const data = {
                imie: imieInput.value,
                nazwisko: nazwiskoInput.value,
                email: emailInput.value,
                password: passwordInput.value
            };

            fetch('../backend/api.php?action=register', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    regMessageBox.style.color = 'green';
                    regMessageBox.innerText = data.message;
                    // Po 2s przełącz na logowanie
                    setTimeout(() => {
                        switchToLogin.click();
                    }, 2000);
                } else {
                    regMessageBox.innerText = data.message;
                }
            })
            .catch(error => {
                console.error('Błąd:', error);
                regMessageBox.innerText = "Błąd połączenia z serwerem.";
            });
        });
    }

    // --- PRZEŁĄCZANIE MIĘDZY FORMULARZAMI ---
    if (switchToRegister && switchToLogin && loginSection && registerSection) {
        switchToRegister.addEventListener('click', function(e) {
            e.preventDefault();
            loginSection.classList.add('hidden');
            registerSection.classList.remove('hidden');
        });

        switchToLogin.addEventListener('click', function(e) {
            e.preventDefault();
            registerSection.classList.add('hidden');
            loginSection.classList.remove('hidden');
        });
    }

    // --- ZMIANA MENU (Cześć [imię]! z wylogowaniem) ---
    const imieKlienta = localStorage.getItem('klient_imie');
    if (imieKlienta) {
        const linki = document.querySelectorAll('a');
        linki.forEach(link => {
            if (link.textContent.toLowerCase().includes('zaloguj')) {
                link.textContent = `Cześć, ${imieKlienta}!`;
                link.href = "#";
                link.style.fontWeight = 'bold';
                link.style.cursor = 'pointer';  // Dodane: wskaźnik myszy jak przycisk
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    if (confirm("Czy chcesz się wylogować?")) {
                        localStorage.removeItem('klient_imie');
                        fetch('../backend/logout.php')
                            .then(() => window.location.reload())
                            .catch(() => window.location.reload());
                    }
                });
            }
        });
    }
});