const sessionId = localStorage.getItem("sessionId");
const username = localStorage.getItem("username");
const password = localStorage.getItem("password");
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
    const gridContainer = document.querySelector('.w-layout-grid.grid');
    gridContainer.innerHTML = '';

    data.forEach((subscription) => {
      const{name, category, image, cost, start_date, recurring_length, sort_group} = subscription;

      const subMain = document.createElement('a');
      subMain.setAttribute('href', 'subscription-info.html');
      subMain.classList.add('sub_main', 'w-inline-block');

      const gridLogo = document.createElement('div');
      gridLogo.classList.add('grid-logo');
      const logoImg = document.createElement('img');
      logoImg.setAttribute('src', image);
      logoImg.setAttribute('loading', 'lazy');
      logoImg.setAttribute('sizes', '100vw');
      logoImg.setAttribute('srcset', `${image}-p-500.png 500w, ${image}-p-800.png 800w, ${image}-p-1080.png 1080w, ${image}.png 1440w`);
      logoImg.setAttribute('alt', `${name} logo`);
      gridLogo.appendChild(logoImg);
      subMain.appendChild(gridLogo);

      const subInfo = document.createElement('div');
      subInfo.classList.add('sub_info');

      const subCost = document.createElement('div');
      subCost.classList.add('sub_data');
      const costLabel = document.createElement('div');
      costLabel.classList.add('text-block');
      costLabel.textContent = 'Cost';
      subCost.appendChild(costLabel);
      const costValue = document.createElement('div');
      costValue.classList.add('text-block');
      costValue.textContent = `€${cost}`;
      subCost.appendChild(costValue);
      subInfo.appendChild(subCost);

      const subRenew = document.createElement('div');
      subRenew.classList.add('sub_data');
      const renewLabel = document.createElement('div');
      renewLabel.classList.add('text-block-2');
      renewLabel.textContent = 'start_date';
      subRenew.appendChild(renewLabel);
      const renewValue = document.createElement('div');
      renewValue.classList.add('text-block-2');
      renewValue.textContent = start_date;
      subRenew.appendChild(renewValue);
      subInfo.appendChild(subRenew);

      const subStart = document.createElement('div');
      subStart.classList.add('sub_data');
      const startLabel = document.createElement('div');
      startLabel.classList.add('text-block-3');
      startLabel.textContent = 'sort group';
      subStart.appendChild(startLabel);
      const startValue = document.createElement('div');
      startValue.classList.add('text-block-3');
      startValue.textContent = sort_group;
      subStart.appendChild(startValue);
      subInfo.appendChild(subStart);

      const subTotal = document.createElement('div');
      subTotal.classList.add('sub_data');
      const totalLabel = document.createElement('div');
      totalLabel.classList.add('text-block-4');
      totalLabel.textContent = 'recurring length';
      subTotal.appendChild(totalLabel);
      const totalValue = document.createElement('div');
      totalValue.classList.add('text-block-4');
      totalValue.textContent = `${recurring_length}`;
      subTotal.appendChild(totalValue);
      subInfo.appendChild(subTotal);

      subMain.appendChild(subInfo);
      gridContainer.appendChild(subMain);
    });
  })
  .catch((error) => {
    console.error(error);
    alert(error.message);
  });


