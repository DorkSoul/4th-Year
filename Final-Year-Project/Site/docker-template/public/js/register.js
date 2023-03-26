const sessionId = localStorage.getItem("sessionId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");
const userId = localStorage.getItem("userId");

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

const form = document.getElementById('wf-form-Subscription-Form');
form.addEventListener('submit', (event) => {
  event.preventDefault();

  const usernameInput = document.getElementById('user_username-2');
  const passwordInput = document.getElementById('user_password');
  const firstNameInput = document.getElementById('user_first-2');
  const lastNameInput = document.getElementById('user_second-2');
  const phoneNumberInput = document.getElementById('user_num-2');
  const currencyInput = document.getElementById('user_cur-2');
  const timeZoneInput = document.getElementById('user_time-2');
  const emailInput = document.getElementById('user_email-2');
  const ageInput = document.getElementById('user_age-2');
  const genderInput = document.getElementById('user_gender-2');
  const addressInput = document.getElementById('user_address-2');
  const countryInput = document.getElementById('user_country-2');

  const username = usernameInput.value.trim();
  const password = passwordInput.value.trim();
  const firstName = firstNameInput.value.trim();
  const lastName = lastNameInput.value.trim();
  const phoneNumber = phoneNumberInput.value.trim();
  const currency = currencyInput.value.trim();
  const timeZone = timeZoneInput.value.trim();
  const email = emailInput.value.trim();
  const age = ageInput.value.trim();
  const gender = genderInput.value.trim();
  const address = addressInput.value.trim();
  const country = countryInput.value.trim();

  const formData = {
    username,
    password,
    first_name: firstName,
    last_name: lastName,
    phone_number: phoneNumber,
    currency,
    time_zone: timeZone,
    email,
    age,
    gender,
    address,
    country
  };

  fetch('/register', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(formData)
})
.then((response) => {
    if (response.ok) {
        alert('Account created successfully');
        // Redirect to the login page
        window.location.href = '/login.html';
    } else {
        // Get the error message from the server response
        return response.json().then((errorData) => {
            throw new Error(errorData.error);
        });
    }
})
.catch((error) => {
    console.error(error);
    alert(error.message);
});
});




