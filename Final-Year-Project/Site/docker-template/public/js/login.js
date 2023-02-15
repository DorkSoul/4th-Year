// Handle the login form submission
const loginForm = document.getElementById('wf-form-Subscription-Form');
loginForm.addEventListener('submit', (event) => {
  event.preventDefault();

  const username = document.getElementById('user_username').value;
  const password = document.getElementById('user_password').value;

  fetch('/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password })
  })
  .then(response => {
    if (response.ok) {
      // If the login is successful, store the session ID in a cookie or local storage
      return response.json();
    } else {
      throw new Error('Invalid username or password');
    }
  })
  .then(data => {
    // Store the session ID in a cookie or local storage
    localStorage.setItem('sessionId', data.sessionId);
    localStorage.setItem('username', username);
    localStorage.setItem('password', password);
    window.location.href = '/index.html'; // Redirect to the account page
  })
  .catch(error => {
    console.error(error);
    alert(error.message);
  });
});
