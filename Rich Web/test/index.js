// Handle form submission
document.getElementById("subscription-form").addEventListener("submit", function(e) {
  e.preventDefault(); // prevent form from refreshing page

  // Get form values
  const email = document.getElementById("email").value;
  const frequency = document.getElementById("frequency").value;

  // Add subscription to table
  const table = document.getElementById("subscription-list");
  const row = table.insertRow(-1);
  const emailCell = row.insertCell(0);
  const frequencyCell = row.insertCell(1);
  emailCell.innerHTML =
