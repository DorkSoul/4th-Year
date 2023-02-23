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

    // const subscriptionSortGroup = document.querySelector('#subscription-total-paid');
    // subscriptionSortGroup.textContent = sort_group;

    // const subscriptionDescription = document.querySelector('.subscription_description');
    // subscriptionDescription.textContent = description;
  })
  .catch((error) => {
    console.error(error);
    alert(error.message);
  });