const sessionId = localStorage.getItem("sessionId");
const userId = localStorage.getItem("userId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");
const recommendationsDiv = document.getElementById('recommendations');


let recommendations = [];
let subscriptions = [];

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

document.addEventListener("DOMContentLoaded", function () {
  var statsPopup = document.getElementById("stats-popup");
  var closeButton = document.querySelector(".button-2");

  function togglePopup() {
    if (statsPopup.style.display === "none" || statsPopup.style.display === "") {
      statsPopup.style.display = "block";
      statsPopup.style.visibility = "visible";
    } else {
      statsPopup.style.display = "none";
      statsPopup.style.visibility = "hidden";
    }
    statsPopup.style.pointerEvents = statsPopup.style.display === "block" ? "auto" : "none";
  }

  function fillStatsPopup(subscription) {
    const statTextDataElements = statsPopup.querySelectorAll(".stat_text_data");
  
    statTextDataElements[0].innerText = subscription.name;
    statTextDataElements[1].innerText = subscription.category;
    statTextDataElements[2].innerText = subscription.description;
  
    const starRatingContainer = statTextDataElements[3];
    starRatingContainer.innerHTML = ''; // Clear the previous star rating
  
    const rating = subscription.rating;
    const totalStars = 5;
  
    for (let i = 1; i <= totalStars; i++) {
      const star = document.createElement('span');
      star.classList.add('star');
      star.innerText = '★';
  
      if (i <= rating) {
        star.style.color = 'yellow';
      } else {
        star.style.color = 'gray';
      }
  
      starRatingContainer.appendChild(star);
    }
  }
  

  function getSubscriptionById(id) {
    return subscriptions.find(sub => sub.id === id);
  }

  closeButton.addEventListener("click", function (e) {
    e.preventDefault();
    togglePopup();
  });
  
    function fetchSubscriptions() {
      return fetch('/all-subscriptions')
        .then((response) => response.json())
        .then((data) => {
          subscriptions = data;    
          data.forEach((subscription) => {
            const { id, name, category, image, description } = subscription;
            console.log(subscription);
    
            // Add content (e.g., image, name, etc.) to the subscription element
            const newDiv = document.createElement('div');
            newDiv.classList.add('grid-item');
            newDiv.innerHTML = `
              <a href="#" class="show-popup">
                <img src="${image}" loading="lazy" alt="">
              </a>
            `;
            recommendationsDiv.appendChild(newDiv);
          });
    
          // Add the show-popup class to each image element
          const imageElements = document.querySelectorAll('.grid-item a img');
          imageElements.forEach(img => {
            img.parentNode.classList.add('show-popup');
          });
    
        })
        .catch((error) => {
          console.error(error);
          alert(error.message);
        });
    }

    function setupEventListeners() {
      var showPopupButtons = document.querySelectorAll(".show-popup");
  
      showPopupButtons.forEach(function (button) {
        button.addEventListener("click", function (e) {
          e.preventDefault();
          const subscriptionId = parseInt(button.dataset.subscriptionId);
          const subscription = getSubscriptionById(subscriptionId);
  
          if (subscription) {
            fillStatsPopup(subscription);
            togglePopup();
          }
        });
      });
    }
  

    function fetchRecommendations() {
      return fetch('/recommendations', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userId })
      })
        .then((response) => response.json())
        .then((data) => {
          // Convert the response object into an array of objects with key-value pairs
          const recommendationArray = Object.entries(data[0]).map(([key, value]) => ({
            id: parseInt(key.substring(4)), // Remove "sub_" and convert the remaining string to an integer
            rating: parseFloat(value),
          }));

          // Sort the array by size from biggest to smallest
          recommendations = recommendationArray.sort((a, b) => b.rating - a.rating);
          console.log(recommendations);

        })
        .catch((error) => {
          console.error(error);
          alert(error.message);
        });
    }

    function displayRecommendations() {
      recommendationsDiv.innerHTML = '';
  
      const topRecommendations = recommendations.slice(0, 5);
      topRecommendations.forEach((rec) => {
        const subscriptionImage = getSubscriptionImageById(rec.id);
  
        const newDiv = document.createElement('div');
        newDiv.classList.add('grid-item');
        newDiv.innerHTML = `
          <a href="#" class="show-popup" data-subscription-id="${rec.id}">
            <img src="${subscriptionImage}" loading="lazy" alt="">
          </a>
        `;
        recommendationsDiv.appendChild(newDiv);
      });
  
      // Call setupEventListeners after displaying the recommendations
      setupEventListeners();
    }
  
    
    
    
    
    function getSubscriptionImageById(id) {
      const subscription = subscriptions.find(sub => sub.id === id);
      return subscription ? subscription.image : '';
    }
    
    // Fetch subscriptions and recommendations, and then display recommendations
    Promise.all([fetchSubscriptions(), fetchRecommendations()])
    .then(() => {
      displayRecommendations();
    })
    .catch((error) => {
      console.error(error);
      alert(error.message);
    });
});

