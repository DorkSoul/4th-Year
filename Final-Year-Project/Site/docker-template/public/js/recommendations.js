const sessionId = localStorage.getItem("sessionId");
const userId = localStorage.getItem("userId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");
const recommendationsDiv = document.getElementById('recommendations');
const userSuggestionsDiv = document.getElementById("user_suggestions");


let recommendations = [];
let subscriptions = [];
let userSuggestions = [];
let userSubscriptionIds = [];

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

  function fetchUserSubs() {
    return fetch("/subscriptions", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password }),
    })
      .then((response) => response.json())
      .catch((error) => {
        console.error(error);
        alert(error.message);
      });
  }
  
  
  function fetchSubscriptions() {
    return fetch('/all-subscriptions')
      .then((response) => response.json())
      .then((data) => {
        subscriptions = data;    
        data.forEach((subscription) => {
          const { id, name, category, image, description } = subscription;
          // console.log(subscription);
  
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
        return data;
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
        // console.log(recommendations);
        return recommendations;
      })
      .catch((error) => {
        console.error(error);
        alert(error.message);
      });
  }
  

  function displayRecommendations(userSubscriptions) {
    recommendationsDiv.innerHTML = '';
  
    // Filter out subscriptions the user already has
    const filteredRecommendations = recommendations.filter(
      (rec) => !userSubscriptions.some((userSub) => userSub.id === rec.id)
    );
  
    // Display only the top 5 filtered recommendations
    const topRecommendations = filteredRecommendations.slice(0, 5);
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
    // setupEventListeners();
  }

    

  // Modify fetchUserSuggestions function to process the data
  function fetchUserSuggestions() {
    return fetch('/user_user', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId })
    })
      .then((response) => response.json())
      .then((data) => {
        // Extract subscription IDs from the data
        const userSuggestions = Object.entries(data[0])
          .filter(([key]) => key.startsWith('sub_id_'))
          .map(([_, value]) => parseInt(value));
        
        // Return userSuggestions array
        return userSuggestions;
      })
      .catch((error) => {
        console.error(error);
        alert(error.message);
      });
  }

  function displayUserSuggestions(subscriptionIds) {
    userSuggestionsDiv.innerHTML = '';
  
    subscriptionIds.forEach((subscriptionId) => {
      const subscriptionImage = getSubscriptionImageById(subscriptionId);
  
      const newDiv = document.createElement('div');
      newDiv.classList.add('grid-item');
      newDiv.innerHTML = `
        <a href="#" class="show-popup" data-subscription-id="${subscriptionId}">
          <img src="${subscriptionImage}" loading="lazy" alt="">
        </a>
      `;
      userSuggestionsDiv.appendChild(newDiv);
    });
  
    // Call setupEventListeners after displaying the user suggestions
    // setupEventListeners();
  }
  

  function fetchSimilarSubs() {
    return fetch("/subscriptions", {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    })
    .then((response) => response.json())
    .then((data) => {
      userSubscriptionIds = data.map(sub => sub.id);
  
      const promises = userSubscriptionIds.map(subId => {
        return fetch('/sub_subs', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ subId })
        })
        .then(response => response.json());
      });
  
      return Promise.all(promises);
    })
    .then(results => {
      const similarSubsCounts = {};
      
      results.forEach(data => {
        data.forEach(subSub => {
          for (let i = 1; i <= 5; i++) {
            const similarSubId = subSub[`similar_sub_id_${i}`];
            if (similarSubId !== null && similarSubId !== undefined) {
              if (similarSubId in similarSubsCounts) {
                similarSubsCounts[similarSubId]++;
              } else {
                similarSubsCounts[similarSubId] = 1;
              }
            }
          }
        });
      });
  
      const sortedSimilarSubs = Object.entries(similarSubsCounts)
        .sort((a, b) => b[1] - a[1])
        .map(entry => parseInt(entry[0]))
        .slice(0, 5);
  
      return sortedSimilarSubs;
    })
    .catch((error) => {
      console.error(error);
      alert(error.message);
    });
  }
  
  function displaySimilarSubs(similarSubscriptionIds, userSubscriptions) {
    const subscriptionSuggestionsDiv = document.getElementById("subscription_suggestions");
    subscriptionSuggestionsDiv.innerHTML = '';
  
    // Filter out subscriptions the user already has
    const filteredSubscriptions = subscriptions.filter(
      (sub) => !userSubscriptions.some((userSub) => userSub.id === sub.id)
    );
  
    // Sort the filtered subscriptions by the number of times they appear in the similarSubscriptionIds array
    const sortedSubscriptions = filteredSubscriptions.sort((a, b) => {
      const countA = similarSubscriptionIds.filter((id) => id === a.id).length;
      const countB = similarSubscriptionIds.filter((id) => id === b.id).length;
      return countB - countA;
    });
  
    // Display only the top 5 filtered subscriptions
    const topSubscriptions = sortedSubscriptions.slice(0, 5);
    topSubscriptions.forEach((sub) => {
      const subscriptionImage = sub.image;
  
      const newDiv = document.createElement('div');
      newDiv.classList.add('grid-item');
      newDiv.innerHTML = `
        <a href="#" class="show-popup" data-subscription-id="${sub.id}">
          <img src="${subscriptionImage}" loading="lazy" alt="">
        </a>
      `;
      subscriptionSuggestionsDiv.appendChild(newDiv);
    });
  
    // Call setupEventListeners after displaying the subscription suggestions
    // setupEventListeners();
  }
  
  
  
  
  



  


  
    
    
    
    
function getSubscriptionImageById(id) {
  const subscription = subscriptions.find(sub => sub.id === id);
  return subscription ? subscription.image : '';
}

  
// Fetch subscriptions, recommendations, and user suggestions, and then display them
Promise.all([
  fetchSubscriptions(),
  fetchRecommendations(),
  fetchUserSuggestions(),
  fetchSimilarSubs(),
  fetchUserSubs(),
  ])
  .then(([_subscriptions, _recommendations, userSuggestions, similarSubscriptionIds, userSubscriptions]) => {
  subscriptions = _subscriptions;
  recommendations = _recommendations;
  displayRecommendations(userSubscriptions);
  displayUserSuggestions(userSuggestions);
  displaySimilarSubs(similarSubscriptionIds, userSubscriptions); // Pass userSubscriptions to displaySimilarSubs
  setupEventListeners();
  })
  .catch((error) => {
  console.error(error);
  alert(error.message);
  });
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

