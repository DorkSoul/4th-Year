// Get session information from local storage
const sessionId = localStorage.getItem("sessionId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");
const userId = localStorage.getItem("userId");

const recurringPayments = [];

// Check if the user is logged in
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

// Fetch user's subscriptions
fetch("/subscriptions", {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username, password })
})
  .then((response) => response.json())
  .then((data) => {
    const gridContainer = document.querySelector('.w-layout-grid.grid');
    gridContainer.innerHTML = '';

    data.forEach((subscription) => {
      // Check if the subscription is not cancelled
      if (!subscription.cancelled) {
        const { id, name, category, image, cost, start_date, recurring_length, sort_group, description, cancelled, rating } = subscription;

        const subMain = document.createElement('a');
        subMain.classList.add('sub_main', 'w-inline-block');

        const gridLogo = document.createElement('div');
        gridLogo.classList.add('grid-logo');
        const logoImg = document.createElement('img');
        logoImg.setAttribute('src', image);
        logoImg.setAttribute('loading', 'lazy');
        logoImg.setAttribute('sizes', '100vw');
        logoImg.setAttribute('srcset', `${image}-p-500.png 500w, ${image}-p-800.png 800w, ${image}-p-1080.png 1080w, ${image}.png 1440w`);
        logoImg.setAttribute('alt', `${name} logo`);
        gridLogo.appendChild(logoImg);
        subMain.appendChild(gridLogo);

        const subInfo = document.createElement('div');
        subInfo.classList.add('sub_info');

        const subCost = document.createElement('div');
        subCost.classList.add('sub_data');
        const costLabel = document.createElement('div');
        costLabel.classList.add('text-block-2');
        costLabel.textContent = 'Cost';
        costLabel.style.backgroundColor = '#0096ff';
        costLabel.style.marginBottom = '10px';
        subCost.appendChild(costLabel);
        const costValue = document.createElement('div');
        costValue.classList.add('text-block-2');
        costValue.textContent = `€${cost}`;
        subCost.appendChild(costValue);
        subInfo.appendChild(subCost);

        const subRenew = document.createElement('div');
        subRenew.classList.add('sub_data');
        const renewLabel = document.createElement('div');
        renewLabel.classList.add('text-block-2');
        renewLabel.textContent = 'Start Date';
        renewLabel.style.backgroundColor = '#0096ff';
        renewLabel.style.marginBottom = '10px';
        subRenew.appendChild(renewLabel);
        const renewValue = document.createElement('div');
        renewValue.classList.add('text-block-2');
        const date = new Date(start_date);
        const formattedDate = `${date.getDate()}/${date.getMonth() + 1}/${date.getFullYear()}`;
        renewValue.textContent = formattedDate;
        subRenew.appendChild(renewValue);
        subInfo.appendChild(subRenew);

        const subStart = document.createElement('div');
        subStart.classList.add('sub_data');
        const startLabel = document.createElement('div');
        startLabel.classList.add('text-block-3');
        startLabel.textContent = 'sort group';
        startLabel.style.backgroundColor = '#0096ff';
        startLabel.style.marginBottom = '10px';
        subStart.appendChild(startLabel);
        const startValue = document.createElement('div');
        startValue.classList.add('text-block-3');
        startValue.textContent = sort_group;
        subStart.appendChild(startValue);
        subInfo.appendChild(subStart);

        const subTotal = document.createElement('div');
        subTotal.classList.add('sub_data');
        const totalLabel = document.createElement('div');
        totalLabel.classList.add('text-block-4');
        totalLabel.textContent = 'recurring length';
        totalLabel.style.backgroundColor = '#0096ff';
        totalLabel.style.marginBottom = '10px';
        subTotal.appendChild(totalLabel);
        const totalValue = document.createElement('div');
        totalValue.classList.add('text-block-4');
        totalValue.textContent = `${recurring_length}`;
        subTotal.appendChild(totalValue);
        subInfo.appendChild(subTotal);

        subMain.appendChild(subInfo);
        gridContainer.appendChild(subMain);

        subMain.addEventListener('click', () => {
          window.location.href = `/subscription-info.html?id=${subscription.id}`;

        });
      }
    });
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

// Fetch all subscriptions from the database
function fetchSubscriptions() {
  return fetch('/all-subscriptions')
    .then((response) => response.json())
    .then((data) => {
      const subscriptions = data.map((subscription) => {
        const { id, name, category, image, description } = subscription;
        return { id, name, category, image, description };
      });

      return subscriptions;
    })
    .catch((error) => {
      console.error(error);
      alert(error.message);
    });
}



// Import subscriptions from a excel file
document.getElementById('import-subscriptions').addEventListener('change', (event) => {
  const file = event.target.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = (e) => {
      const data = e.target.result;
      const workbook = XLSX.read(data, { type: 'binary' });
      const sheet = workbook.Sheets[workbook.SheetNames[0]];
      const rows = XLSX.utils.sheet_to_json(sheet, { header: 1 });

      // Ignore the first few rows (header)
      rows.splice(0, 13);

      // Filter out rows with empty cells
      const filteredRows = rows.filter(row => {
        return row[1] || row[2] || row[4];
      });

      // Remove 'Money In' and 'Balance' columns and format the remaining data
      const formattedRows = filteredRows.map(row => {
        return {
          date: convertDateFormat(row[0]),
          name: row[2]
            ? row[2]
              .toLowerCase()
              .split(' ')
              .filter(word => !(/[0-9\/\*\-\+:]+/g).test(word))
              .join(' ')
            : '',
          cost: row[4]
        };
      });




      // console.log(formattedRows);


      // Group the transactions by name and sort them by date
      const groupedTransactions = {};

      formattedRows.forEach((transaction) => {
        const existingKey = Object.keys(groupedTransactions).find(key => hasCommonWords(key, transaction.name, 2));
        if (existingKey) {
          groupedTransactions[existingKey].push(transaction);

          // Sort the transactions by date
          groupedTransactions[existingKey].sort((a, b) => {
            const dateA = new Date(a.date);
            const dateB = new Date(b.date);
            return dateA - dateB;
          });
        } else {
          groupedTransactions[transaction.name] = [transaction];
        }
      });


      // console.log("groupedTransactions: ", groupedTransactions);


      Object.keys(groupedTransactions).forEach((name) => {
        const transactions = groupedTransactions[name];

        const intervals = [];
        for (let i = 0; i < transactions.length - 1; i++) {
          const date1 = new Date(transactions[i].date);
          // console.log("transactions :", transactions[i], " date1: ", date1);

          const date2 = new Date(transactions[i + 1].date);
          // console.log("transactions :", transactions[i + 1], " date2: ", date2);

          const diffInDays = Math.floor((date2 - date1) / (1000 * 60 * 60 * 24));
          // console.log(diffInDays);

          intervals.push(diffInDays);
        }
        // console.log(groupedTransactions[name], " intervals: ", intervals);

        if (intervals.length > 0) {
          const avgInterval = intervals.reduce((sum, value) => sum + value, 0) / intervals.length;
          let recurringLength = '';
          if (avgInterval >= 6 && avgInterval <= 9) {
            recurringLength = 'weekly';
          } else if (avgInterval >= 27 && avgInterval <= 35) {
            recurringLength = 'monthly';
          } else {
            recurringLength = 'other';
          }

          // Get the most recent transaction cost
          const mostRecentCost = transactions[transactions.length - 1].cost;

          // Check if the last payment date is within the expected recurring length
          const lastPaymentDate = new Date(transactions[transactions.length - 1].date);
          const currentDate = new Date();
          console.log("subscription: ", groupedTransactions[name], " current date: ", currentDate, " payment date: ", lastPaymentDate);
          const daysSinceLastPayment = Math.floor((currentDate - lastPaymentDate) / (1000 * 60 * 60 * 24));
          console.log("days since last payment: ", daysSinceLastPayment)

          let shouldAddToRecurringPayments = false;

          if (recurringLength === 'weekly' && daysSinceLastPayment <= 9) {
            shouldAddToRecurringPayments = true;
          } else if (recurringLength === 'monthly' && daysSinceLastPayment <= 35) {
            shouldAddToRecurringPayments = true;
          } else if (recurringLength === 'other') {
            shouldAddToRecurringPayments = true;
          }
          console.log(shouldAddToRecurringPayments);

          if (shouldAddToRecurringPayments) {
            recurringPayments.push({
              name: name,
              start_date: transactions[0].date,
              recurring_length: recurringLength,
              cost: mostRecentCost,
            });
          }
        }
      });

      console.log(recurringPayments);


      // Check if any of the recurring payments match a subscription in the database
      fetchSubscriptions().then((subscriptions) => {
        console.log("returned subscriptions: ", subscriptions);
        const subscriptionNames = subscriptions.map(subscription => subscription.name.toLowerCase());
        const matchingSubscriptions = recurringPayments.filter(payment => {
          console.log("payment.name: ", payment.name);
          console.log("subscriptionNames: ", subscriptionNames);
          console.log(subscriptionNames.some(name => payment.name.toLowerCase().includes(name)));
          return subscriptionNames.some(name => payment.name.toLowerCase().includes(name));
        });

        console.log(matchingSubscriptions);

        matchingSubscriptions.forEach((payment) => {
          // Find the matching subscription object from the fetched subscriptions array
          const matchingSubscription = subscriptions.find(subscription => payment.name.toLowerCase().includes(subscription.name.toLowerCase()));

          if (matchingSubscription) {
            console.log(matchingSubscription)
            const subData = {
              user_id: userId,
              sub_id: matchingSubscription.id,
              cost: payment.cost,
              start_date: payment.start_date,
              recurring_length: payment.recurring_length,
              sort_group: matchingSubscription.category,
              user_notes: ''
            };

            console.log("subData: ", subData);
            addSubscription(subData);
          }
        });
        alert('Import finished');
      });




    };
    reader.readAsBinaryString(file);
  }
});

// Trigger the file input when the import button is clicked
document.getElementById('import-subscriptions-button').addEventListener('click', () => {
  document.getElementById('import-subscriptions').click();
});

// Check if two strings have a minimum number of common words
function hasCommonWords(s1, s2, minCommonWords = 2) {
  if (!s1 || !s2) return false;

  const words1 = s1.toLowerCase().split(' ');
  const words2 = s2.toLowerCase().split(' ');
  let commonWordsCount = 0;

  words1.forEach(word1 => {
    if (words2.includes(word1)) {
      commonWordsCount++;
    }
  });

  return commonWordsCount >= minCommonWords;
}

// Convert date format from DD/MM/YYYY to YYYY-MM-DD
function convertDateFormat(dateStr) {
  if (!dateStr) return '';

  const [day, month, year] = dateStr.split('/');
  return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
}


// Add a subscription to the database
function addSubscription(subData) {
  fetch('/add-subscription', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(subData),
  })
    .then((response) => {
      if (response.ok) {
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
      } else {
        // Reload the page after adding all the subscriptions
        location.reload();
      }
    })
    .catch((error) => {
      console.error(error);
      alert(error.message);
    });
}

