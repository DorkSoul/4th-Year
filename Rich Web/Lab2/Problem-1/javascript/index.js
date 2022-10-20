const nameTag = document.getElementById("contactname").value,
numberTag = document.getElementById("contactnumber").value,
emailTag = document.getElementById("contactemail").value,
nextrow = document.querySelector(".grid-container");

const contacts = JSON.parse(localStorage.getItem("contacts") || "[]");
let isUpdate = false, updateId;

function  addcontact() {
    let nameTag = document.getElementById("contactname").value,
    numberTag = document.getElementById("contactnumber").value,
    emailTag = document.getElementById("contactemail").value;
    
    if(nameTag || numberTag || emailTag) {
        let contactInfo = {nameTag, numberTag, emailTag}
        if(!isUpdate) {
            contacts.push(contactInfo);
        } else {
            isUpdate = false;
            contacts[updateId] = contactInfo;
        }
        localStorage.setItem("contacts", JSON.stringify(contacts));
        showContatcs();
    }
    document.getElementById("contactname").value = "";
    document.getElementById("contactnumber").value = "";
    document.getElementById("contactemail").value = "";
};
function showContatcs() {
    if(!contacts) return; 

    document.querySelectorAll(".grid-item").forEach(li => li.remove());

    contacts.forEach((contact) => {
        let liTag = `<li class="grid-item">${contact.nameTag}</li>
                    <li class="grid-item">${contact.numberTag}</li>
                    <li class="grid-item">${contact.emailTag}</li>
                    `;
        nextrow.insertAdjacentHTML("beforeend", liTag);
    });
}
showContatcs();

function sortname(){
    console.log("im in");
    let contacts = JSON.parse(localStorage.getItem('contacts'));
    let allContacts = contacts.sort((a, b) => a[nameTag].localeCompare(b[nameTag]));
    // showContatcs();
    console.log(allContacts);
};

function sortnumber(){
    console.log("im in");
    let contacts = JSON.parse(localStorage.getItem('contacts'));
    let allContacts = contacts.sort(function(a, b){
        return b.numberTag - a.numberTag
      });
    // showContatcs();
    console.log(allContacts);
};

function sortemail(){
    console.log("im in");
    let contacts = JSON.parse(localStorage.getItem('contacts'));
    let allContacts = contacts.sort(function(a, b){
        return b.emailTag - a.emailTag
      });
    // showContatcs();
    console.log(allContacts);
};