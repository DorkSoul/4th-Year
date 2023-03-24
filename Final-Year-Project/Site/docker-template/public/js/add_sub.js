const sessionId = localStorage.getItem("sessionId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");
const userId = localStorage.getItem("userId");

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
  }
);



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


// Get the subscription ID from the selected subscription name
function getSubscriptionId(subscriptionName) {
  const selectedSubscription = subscriptions.find(subscription => subscription.name === subscriptionName);
  return selectedSubscription.id;
}

// Handle the form submission
document.querySelector('form').addEventListener('submit', (event) => {
event.preventDefault();

const subNameInput = document.getElementById('sub_name-2');
const subFreqInput = document.getElementById('sub_freq-2');
const subDescInput = document.getElementById('sub_desc-2');
const subCostInput = document.getElementById('sub_cost-2');
const subDateInput = document.getElementById('sub_date-2');
const subMethodInput = document.getElementById('sub_method-2');
const subGroupInput = document.getElementById('sub_group-2');
const subNoteInput = document.getElementById('sub_note-2');

const subscriptionName = subNameInput.value.trim();
const subscriptionId = getSubscriptionId(subscriptionName);
const frequency = subFreqInput.value.trim();
const description = subDescInput.value.trim();
const cost = parseFloat(subCostInput.value.trim());
const startDate = subDateInput.value.trim();
const paymentMethod = subMethodInput.value.trim();
const group = subGroupInput.value.trim();
const notes = subNoteInput.value.trim();
const userId = localStorage.getItem('userId');

// Create an object with the form data
const formData = {
  user_id: userId,
  sub_id: subscriptionId,
  cost,
  start_date: startDate,
  recurring_length: frequency,
  sort_group: group,
  user_notes: notes,
};

// Send the POST request to add the subscription to the server
fetch('/add-subscription', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(formData),
})
  .then((response) => {
    if (response.ok) {
      // Clear the form
      subNameInput.value = '';
      subFreqInput.value = '';
      subDescInput.value = '';
      subCostInput.value = '';
      subDateInput.value = '';
      subMethodInput.value = '';
      subGroupInput.value = '';
      subNoteInput.value = '';

      alert('Subscription added successfully');
    } else if (response.status === 400) {
      // Handle the "Subscription already exists" error
      return response.json();
    } else {
      throw new Error('Subscription creation failed');
    }
  })
  .then((data) => {
    if (data && data.error) {
      alert(data.error);
    }
  })
  .catch
  ((error) => {
    console.error(error);
    alert(error.message);
    });
    });



    