const sessionId = localStorage.getItem("sessionId");
if (!sessionId) {
  // Redirect to login page
  window.location.href = "/login.html";
}

fetch("/subscriptions")
.then((response) => response.json())
.then((data) => {
  data.forEach((subscription) => {
    console.log(subscription);
  });
});