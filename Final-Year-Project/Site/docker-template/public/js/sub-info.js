const queryString = window.location.search;
const urlParams = new URLSearchParams(window.location.search);
const subId = urlParams.get('id');

if (!subId) {
  window.location.href = "/index.html";
}

const sessionId = localStorage.getItem("sessionId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");

if (!sessionId) {
  // Redirect to login page
  window.location.href = "/login.html";
} else {
  fetch('/user_session', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ sessionId })
  })
  .then(response => {
    if (response.ok) {
      return;
    } else {
      window.location.href = '/login.html';
    }
  })
  .catch(error => {
    console.error(error);
    alert(error.message);
  });
}

fetch(`/subscriptions/${subId}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username: username })
  })
  .then((response) => response.json())
  .then((data) => {
    const { name, category, image, cost, start_date, recurring_length, sort_group, description } = data[0];

    const subscriptionName = document.querySelector('#subscription-name');
    subscriptionName.textContent = name;

    const subscriptionImage = document.querySelector('#subscription-image');
    subscriptionImage.setAttribute('src', image);
    subscriptionImage.setAttribute('alt', `${name} logo`);

    const subscriptionCategory = document.querySelector('#subscription-category');
    subscriptionCategory.textContent = category;

    const subscriptionCost = document.querySelector('#subscription-cost');
    subscriptionCost.textContent = `€${cost}`;

    const subscriptionStartDate = document.querySelector('#subscription-start-date');
    const startDateObj = new Date(start_date);
    const formattedStartDate = `${startDateObj.getDate()}/${startDateObj.getMonth()+1}/${startDateObj.getFullYear()}`;
    subscriptionStartDate.textContent = formattedStartDate;

    const subscriptionRecurringLength = document.querySelector('#subscription-renewal-date');
    subscriptionRecurringLength.textContent = recurring_length;

    const subscriptionSortGroup = document.querySelector('#subscription-total-paid');
    const currentDate = new Date();
    const daysInMonth = 30;
    const daysInWeek = 7;
    const timeDiff = Math.abs(currentDate.getTime() - startDateObj.getTime());
    const diffDays = Math.floor(timeDiff / (1000 * 3600 * 24)); 
    let totalPaid = 0;
    if (recurring_length === 'monthly') {
      totalPaid = Math.floor(diffDays/daysInMonth)*cost;
    } else if (recurring_length === 'weekly') {
      totalPaid = Math.floor(diffDays/daysInWeek)*cost;
    }
    subscriptionSortGroup.textContent = `€${totalPaid}`;

    // const subscriptionDescription = document.querySelector('.subscription_description');
    // subscriptionDescription.textContent = description;
  })
  .catch((error) => {
    console.error(error);
    alert(error.message);
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

  