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

fetch("/subscriptions", {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username, password })
})
  .then((response) => response.json())
  .then((data) => {
    // Get weekly and monthly subscription costs
    let monthlyCosts = Array(12).fill(0);
    data.forEach(subscription => {
        const{id, name, category, image, cost, start_date, recurring_length, sort_group} = subscription;
        const startDate = new Date(start_date);
      const startMonth = startDate.getMonth();

      if (recurring_length === 'weekly') {
        for (let i = startMonth; i < 12; i++) {
          const totalCost = Math.floor((new Date().getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24 * 30)) * (cost * 4);
          monthlyCosts[i] += totalCost;
        }
      } else if (recurring_length === 'monthly') {
        for (let i = startMonth; i < 12; i++) {
          const totalCost = Math.floor((new Date().getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24 * 30)) * cost;
          monthlyCosts[i] += totalCost;
        }
      }
    });

    // Create chart
    const ctx = document.getElementById('myChart').getContext('2d');
const chart = new Chart(ctx, {
  type: 'bar', // change to bar chart
  data: {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    datasets: [{
      label: 'Monthly cost',
      data: monthlyCosts,
      backgroundColor: 'rgb(0, 123, 255)',
      borderWidth: 1,
      borderColor: 'rgb(0, 123, 255)',
      hoverBackgroundColor: 'rgb(0, 150, 255)',
      hoverBorderColor: 'rgb(0, 150, 255)',
    }]
  },
  options: {
    scales: {
      yAxes: [{
        ticks: {
          beginAtZero: true,
          callback: function(value, index, values) {
            return '€' + value;
          },
          fontColor: 'black',
        },
        gridLines: {
          color: 'rgba(0, 0, 0, 0.1)',
          zeroLineColor: 'rgba(0, 0, 0, 0.25)',
          display: true,
          drawBorder: false,
        },
      }],
      xAxes: [{
        ticks: {
          fontColor: 'black',
        },
        gridLines: {
          color: 'rgba(0, 0, 0, 0.1)',
          display: true,
          drawBorder: false,
        },
      }],
    },
    legend: {
      display: true,
      labels: {
        fontColor: 'black',
      },
    },
  },
});


// Create pie chart
const sortGroups = data.reduce((groups, { sort_group }) => {
    if (groups[sort_group]) {
      groups[sort_group]++;
    } else {
      groups[sort_group] = 1;
    }
    return groups;
  }, {});
  
  const sortGroupData = Object.entries(sortGroups).map(([label, value]) => ({
    label,
    value,
  }));
  
  const ctx2 = document.getElementById('myPieChart').getContext('2d');
  const pieChart = new Chart(ctx2, {
    type: 'pie',
    data: {
      datasets: [{
        data: sortGroupData.map(d => d.value),
        backgroundColor: ['#99c2ff', '#ffb3ba', '#bcf5bc', '#ffdfba', '#bae1ff'],
      }],
      labels: sortGroupData.map(d => `${d.label}: ${Math.round((d.value/ sortGroupData.reduce((sum, currVal) => sum += currVal.value, 0)) * 100)}%`),
    },
    options: {
      legend: {
        display: true,
        labels: {
          fontColor: 'black',
        },
      },
      tooltips: {
        callbacks: {
          label: (tooltipItem, data) => {
            const dataset = data.datasets[tooltipItem.datasetIndex];
            const index = tooltipItem.index;
            const value = dataset.data[index];
            const total = dataset.data.reduce((sum, currVal) => sum += currVal, 0);
            const percentage = `${Math.round((value / total) * 100)}%`;
            return `${data.labels[index]}: ${percentage}`;
          }
        }
      }
    },
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