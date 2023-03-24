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
      return
    } else {
      window.location.href = '/login.html';
    }
  })
  .catch(error => {
    console.error(error);
    alert(error.message);
  });
}

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

fetch('/all-subscriptions')
  .then((response) => response.json())
  .then((data) => {
    subscriptions = data;
    const categories = extractCategories(subscriptions);
    populateSubscriptionNames(subscriptions);
    populateGroupCategories(categories);

    data.forEach((subscription) => {
      const { id, name, company, website, category, image, description, rating } = subscription;
      console.log(subscription);
    });
  })
  .catch((error) => {
    console.error(error);
    alert(error.message);
  });



  function populateSubscriptionNames(subscriptions) {
    const subNameDatalist = document.getElementById('subscription-names');
  
    // Sort the subscriptions alphabetically by name
    subscriptions.sort((a, b) => a.name.localeCompare(b.name));
  
    subscriptions.forEach((subscription) => {
      const { id, name } = subscription;
      const option = document.createElement('option');
      option.value = name;
      subNameDatalist.appendChild(option);
    });
  };

  function extractCategories(subscriptions) {
    const categories = [];
    subscriptions.forEach(subscription => {
      if (!categories.includes(subscription.category)) {
        categories.push(subscription.category);
      }
    });
    return categories;
  }
  
  function populateGroupCategories(categories) {
    const groupCategoriesDatalist = document.getElementById('group-categories');
  
    categories.sort((a, b) => a.localeCompare(b));
  
    categories.forEach((category) => {
      const option = document.createElement('option');
      option.value = category;
      groupCategoriesDatalist.appendChild(option);
    });
  }
  
  
  
      