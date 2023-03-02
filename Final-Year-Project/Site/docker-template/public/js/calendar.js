const sessionId = localStorage.getItem("sessionId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");

const calendarMonthYear = document.getElementById("calendar-month-year");
const prevMonthBtn = document.getElementById("prev-month");
const nextMonthBtn = document.getElementById("next-month");
const calendarGrid = document.querySelector(".calendar-grid");

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
    // Get monthly subscription costs and next payment dates
    let monthlyCosts = Array(12).fill(0);
    let nextPaymentDates = {};
    let nextPaymentNames = {};
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
        const totalCost = Math.floor((nextPaymentDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24 * 30)) * cost;
        monthlyCosts[nextPaymentMonth] += totalCost;
    });
  })
  .catch((error) => {
    console.error(error);
    alert(error.message);
  });



  

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
      }

      calendarRow.appendChild(calendarDay);
    }

    calendarGrid.appendChild(calendarRow);
  }
}