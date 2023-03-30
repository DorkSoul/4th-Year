const queryString = window.location.search;
const urlParams = new URLSearchParams(window.location.search);
const subId = urlParams.get('id');

let subscriptionInfo = null;


if (!subId) {
  window.location.href = "/index.html";
}

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
    subscriptionInfo = data[0];
    const { name, category, image, cost, start_date, recurring_length, sort_group, description, rating } = data[0];

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

// Change the background color of all elements with class "text-block"
function changeTextBlockBackground() {
  const textBlocks = document.querySelectorAll('.text-block');
  textBlocks.forEach(textBlock => {
    textBlock.style.backgroundColor = '#0096ff';
  });
}

// Call the function to change the background color
changeTextBlockBackground();

// Function to make subscription information editable
function makeEditable(editable) {
  const subDataText = document.querySelectorAll('.sub_data .text-block-2, .sub_data .text-block-3, .sub_data .text-block-4');
  subDataText.forEach(textBlock => {
    if (editable) {
      textBlock.setAttribute('contentEditable', 'true');
    } else {
      textBlock.removeAttribute('contentEditable');
    }
  });
}

// Edit button click event listener
document.getElementById('edit-button').addEventListener('click', (event) => {
  const editButton = event.target;
  if (editButton.textContent === 'Edit') {
    makeEditable(true);
    editButton.textContent = 'Save';
  } else {
    makeEditable(false);
    editButton.textContent = 'Edit';
    // Save the updated subscription information
    updateSubscription(); // Call the updateSubscription function here
  }
});

// Cancel button click event listener
document.getElementById('cancel-button').addEventListener('click', () => {
  if (confirm('Are you sure you want to cancel this subscription?')) {
    cancelSubscription(); // Call the cancelSubscription function here
  }
});

function updateSubscription() {
  // Get values from the text elements
  const cost = parseFloat(document.querySelector('#subscription-cost').textContent.slice(1));
  const start_date = document.querySelector('#subscription-start-date').textContent;
  const recurring_length = document.querySelector('#subscription-renewal-date').textContent;
  const sort_group = document.querySelector('#subscription-total-paid').textContent;
  const user_notes = ''; // You can add a user_notes element if needed
  const cancelled = false; // Set to true if the subscription is cancelled
  
  // Convert start_date to the ISO 8601 format
  const [day, month, year] = start_date.split('/');
  const isoStartDate = `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;

  const updatedFields = {
    cost: cost,
    start_date: isoStartDate,
    recurring_length: recurring_length,
    sort_group: sort_group,
    user_notes: subscriptionInfo.user_notes,
    cancelled: subscriptionInfo.cancelled
  };

  fetch('/update-subscription', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      user_id: userId,
      sub_id: subId,
      ...updatedFields
    })
  })
    .then((response) => {
      if (response.ok) {
        return response.json();
      } else {
        throw new Error('Error updating the subscription');
      }
    })
    .then((data) => {
      console.log(data.message);
      alert('Subscription updated successfully');
      window.location.reload();
    })
    .catch((error) => {
      console.error(error);
      alert(error.message);
    });
}




function cancelSubscription() {
  if (!subscriptionInfo) {
    alert('Error: Subscription information not available.');
    return;
  }

  const updatedSubscription = { ...subscriptionInfo, cancelled: true };

  fetch('/update-subscription', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      user_id: userId,
      sub_id: subId,
      ...updatedSubscription
    })
  })
    .then((response) => {
      if (response.ok) {
        return response.json();
      } else {
        throw new Error('Error canceling the subscription');
      }
    })
    .then((data) => {
      console.log(data.message);
      alert('Subscription canceled successfully');
      window.location.href = "/index.html";
    })
    .catch((error) => {
      console.error(error);
      alert(error.message);
    });
}


