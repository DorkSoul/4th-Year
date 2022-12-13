fetch("/add_subscriptions")
.then((response) => {
    if (!response.ok) {
      throw new Error('Network response was not OK');
    }
    else {
        console.log('Subscription inserted')
    }})
  .catch((error) => {
    console.error('There has been a problem with your fetch operation:', error);
  });