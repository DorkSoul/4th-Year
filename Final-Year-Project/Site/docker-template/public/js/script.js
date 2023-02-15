fetch("/subscriptions")
.then((response) => response.json())
.then((data) => {
  data.forEach((subscription) => {
    console.log(subscription);
  });
});
  