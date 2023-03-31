// Retrieve the user's session 
const sessionId = localStorage.getItem("sessionId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");
const userId = localStorage.getItem("userId");

// Get DOM elements for calendar and navigation buttons
const calendarMonthYear = document.getElementById("calendar-month-year");
const prevMonthBtn = document.getElementById("prev-month");
const nextMonthBtn = document.getElementById("next-month");
const calendarGrid = document.querySelector(".calendar-grid");

let nextPaymentDates = {};
let nextPaymentNames = {};

if (!sessionId) {
  // Redirect to login page
  window.location.href = "/login.html";
} else {
  fetch('/user_session', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ sessionId })
  }) 
  // Fetch user's subscriptions and populate next payment dates and names
    .then(response => {
      if (response.ok) {
        return fetch("/subscriptions", {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ username, password })
        })
      } else {
        throw new Error('User session not valid');
      }
    })
    .then((response) => response.json())
    .then((data) => {
      data.forEach(subscription => {
        if (!subscription.cancelled) {
          const { id, name, start_date, recurring_length } = subscription;
          const startDate = new Date(start_date);

          nextPaymentDates[id] = getPaymentDates(startDate, recurring_length);
          nextPaymentNames[id] = name;
        }
      });

      renderCalendar(currentDate);
    })
    .catch(error => {
      console.error(error);
      alert(error.message);
      window.location.href = '/login.html';
    });
}


let currentDate = new Date();

// Set initial month and year in header
calendarMonthYear.innerText = currentDate.toLocaleString("default", { month: "long", year: "numeric" });

// Render calendar for current month
renderCalendar(currentDate);

// Add click listeners to buttons to change month
// Navigate to the previous month in the calendar
prevMonthBtn.addEventListener("click", () => {
  currentDate.setMonth(currentDate.getMonth() - 1);
  calendarMonthYear.innerText = currentDate.toLocaleString("default", { month: "long", year: "numeric" });
  renderCalendar(currentDate);
});

// Navigate to the next month in the calendar
nextMonthBtn.addEventListener("click", () => {
  currentDate.setMonth(currentDate.getMonth() + 1);
  calendarMonthYear.innerText = currentDate.toLocaleString("default", { month: "long", year: "numeric" });
  renderCalendar(currentDate);
});

// Render the calendar for a given month
function renderCalendar(date) {
  // Clear previous calendar grid
  calendarGrid.innerHTML = '';

  // Get first day of the month and number of days in the month
  const firstDayOfMonth = new Date(date.getFullYear(), date.getMonth(), 1).getDay();
  const daysInMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();

  // Calculate number of rows needed for calendar
  const numRows = Math.ceil((firstDayOfMonth + daysInMonth) / 7);

  // Render days in calendar grid
  let dayNumber = 1;
  for (let i = 0; i < numRows; i++) {
    const calendarRow = document.createElement("div");
    calendarRow.classList.add("calendar-row");

    for (let j = 0; j < 7; j++) {
      const calendarDay = document.createElement("div");
      calendarDay.classList.add("calendar-day");

      if (i === 0 && j < firstDayOfMonth) {
        // Empty cell before first day of month
      } else if (dayNumber > daysInMonth) {
        // Empty cell after last day of month
      } else {
        const dayNumberElement = document.createElement("span");
        dayNumberElement.classList.add("day-number");
        dayNumberElement.innerText = dayNumber;
        calendarDay.appendChild(dayNumberElement);


        const subscriptionsContainer = document.createElement("div");
        subscriptionsContainer.classList.add("subscriptions-container");

        Object.keys(nextPaymentDates).forEach(subscriptionId => {
          const paymentDates = nextPaymentDates[subscriptionId];
          paymentDates.forEach(paymentDate => {
            if (paymentDate.getFullYear() === currentDate.getFullYear() && paymentDate.getMonth() === currentDate.getMonth() && paymentDate.getDate() === dayNumber) {
              const subscriptionName = nextPaymentNames[subscriptionId];
              const subscriptionColor = getSubscriptionColor(subscriptionId);

              const subscriptionElement = document.createElement("div");
              subscriptionElement.classList.add("subscription");
              subscriptionElement.style.backgroundColor = subscriptionColor;
              subscriptionElement.innerText = subscriptionName;
              subscriptionsContainer.appendChild(subscriptionElement);
            }
          });
        });

        calendarDay.appendChild(subscriptionsContainer);
        dayNumber++;
      }

      calendarRow.appendChild(calendarDay);
    }

    calendarGrid.appendChild(calendarRow);
  }
}


const subscriptionColors = [
  "#FF0000", // Red
  "#FF8000", // Orange
  "#FFFF00", // Yellow
  "#80FF00", // Lime
  "#00FF00", // Green
  "#00FF80", // Spring Green
  "#00FFFF", // Cyan
  "#0080FF", // Sky Blue
  "#0000FF", // Blue
  "#8000FF", // Purple
  "#FF00FF", // Magenta
  "#FF0080", // Pink
  "#C00000", // Dark Red
  "#C08000", // Dark Orange
  "#C0C000", // Olive
  "#60C000", // Dark Lime
  "#00C000", // Dark Green
  "#00C060", // Teal
  "#00C0C0", // Dark Cyan
  "#0060C0", // Dark Blue
  "#0000C0", // Navy
  "#6000C0", // Dark Purple
  "#C000C0", // Dark Magenta
  "#FF80C0", // Light Pink
  "#800000", // Maroon
  "#804000", // Brown
  "#808000", // Olive Drab
  "#408000", // Green Yellow
  "#008000", // Dark Green
  "#008040", // Sea Green
  "#008080", // Dark Cyan
  "#004080", // Dark Blue
  "#000080", // Navy
  "#400080", // Dark Purple
  "#800080", // Purple
  "#BF4080", // Rose
  "#404040", // Dark Gray
  "#808080", // Gray
  "#C0C0C0", // Light Gray
];

// Get the color for a subscription based on its ID
function getSubscriptionColor(id) {
  const index = parseInt(id, 10) % subscriptionColors.length;
  return subscriptionColors[index];
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

// Calculate payment dates for a subscription given its start date and recurring length
function getPaymentDates(startDate, recurring_length, targetMonth = currentDate.getMonth(), targetYear = currentDate.getFullYear()) {
  let paymentDates = [];
  let nextPaymentDate = new Date(startDate);
  const maxDate = new Date(currentDate);
  maxDate.setFullYear(maxDate.getFullYear() + 3);

  while (nextPaymentDate <= maxDate) {
    if (nextPaymentDate.getFullYear() >= targetYear && nextPaymentDate.getFullYear() <= maxDate.getFullYear()) {
      paymentDates.push(new Date(nextPaymentDate));
    }

    if (recurring_length === 'weekly') {
      nextPaymentDate.setDate(nextPaymentDate.getDate() + 7);
    } else if (recurring_length === 'monthly') {
      nextPaymentDate.setMonth(nextPaymentDate.getMonth() + 1);
    } else if (recurring_length === 'yearly') {
      nextPaymentDate.setFullYear(nextPaymentDate.getFullYear() + 1);
    } else {
      break;
    }
  }
  return paymentDates;
}




