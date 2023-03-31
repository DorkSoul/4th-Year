// D20125299 - Luke Hallinan
// Retrieve user data from local storage
const sessionId = localStorage.getItem("sessionId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");
const userId = localStorage.getItem("userId");

// Attach a submit event listener to the login form
const loginForm = document.getElementById('wf-form-Subscription-Form');
loginForm.addEventListener('submit', (event) => {
  event.preventDefault();

  // Get input values for username and password from the form
  const username = document.getElementById('user_username').value;
  const password = document.getElementById('user_password').value;

  // Send a POST request to the server to log in the user
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
    localStorage.setItem('userId', data.userId);
    localStorage.setItem('username', username);
    localStorage.setItem('password', password);
    window.location.href = '/index.html'; // Redirect to the account page
  })
  .catch(error => {
    console.error(error);
    alert(error.message);
  });
});

// Check if the user is logged in and update the login-logout button accordingly
function updateLoginLogoutButton() {
  const loginLogoutButton = document.getElementById('login-logout');

  if (localStorage.getItem('sessionId')) {
    loginLogoutButton.textContent = 'Logout';
    loginLogoutButton.href = 'javascript:void(0)';
  } else {
    loginLogoutButton.textContent = 'Login';
    loginLogoutButton.href = 'login.html';
  }
}

// Call the updateLoginLogoutButton function to set the button state on page load
updateLoginLogoutButton();

// Handle the logout process
document.getElementById('login-logout').addEventListener('click', (event) => {
  if (localStorage.getItem('sessionId')) {
    event.preventDefault();
    // Clear the user data from local storage
    localStorage.removeItem('sessionId');
    localStorage.removeItem('userId');
    localStorage.removeItem('username');
    localStorage.removeItem('password');

    // Update the login-logout button
    updateLoginLogoutButton();

    // Redirect the user to the login page
    window.location.href = 'login.html';
  }
});

