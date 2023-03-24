const sessionId = localStorage.getItem("sessionId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");

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
    // Get monthly subscription costs and next payment dates
    let monthlyCosts = Array(12).fill(0);
    data.forEach(subscription => {
        const{id, name, category, image, cost, start_date, recurring_length, sort_group} = subscription;
        const startDate = new Date(start_date);
        const startMonth = startDate.getMonth();
        let nextPaymentDate = new Date(start_date);

        if (recurring_length === 'weekly') {
          while (nextPaymentDate < new Date()) {
            nextPaymentDate.setDate(nextPaymentDate.getDate() + 7);
          }
        } else if (recurring_length === 'monthly') {
          while (nextPaymentDate < new Date()) {
            nextPaymentDate.setMonth(nextPaymentDate.getMonth() + 1);
          }
        }

        nextPaymentDates[id] = nextPaymentDate;
        nextPaymentNames[id] = name;

        const nextPaymentMonth = nextPaymentDate.getMonth();
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
prevMonthBtn.addEventListener("click", () => {
  currentDate.setMonth(currentDate.getMonth() - 1);
  calendarMonthYear.innerText = currentDate.toLocaleString("default", { month: "long", year: "numeric" });
  renderCalendar(currentDate);
});

nextMonthBtn.addEventListener("click", () => {
  currentDate.setMonth(currentDate.getMonth() + 1);
  calendarMonthYear.innerText = currentDate.toLocaleString("default", { month: "long", year: "numeric" });
  renderCalendar(currentDate);
});

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
        calendarDay.innerText = dayNumber;
        dayNumber++;

        const nextPaymentDate = nextPaymentDates[dayNumber - 1];
        if (nextPaymentDate) {
          const subscriptionId = Object.keys(nextPaymentDates).find(id => nextPaymentDates[id].getTime() === nextPaymentDate.getTime());
          const subscriptionName = nextPaymentNames[subscriptionId];
          const subscriptionColor = getSubscriptionColor(subscriptionId);
          
          const subscriptionElement = document.createElement("div");
          subscriptionElement.classList.add("subscription");
          subscriptionElement.style.backgroundColor = subscriptionColor;
          subscriptionElement.innerText = subscriptionName;
          calendarDay.appendChild(subscriptionElement);
        }
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
