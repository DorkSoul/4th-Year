// variables
const nameTag = document.getElementById("contactname").value,
numberTag = document.getElementById("contactnumber").value,
emailTag = document.getElementById("contactemail").value,
nextrow = document.querySelector(".grid-container");

const contacts = JSON.parse(localStorage.getItem("contacts") || "[]");
let isUpdate = false, updateId;

//adding contacts
function  addcontact() {
    //variables
    let nameTag = document.getElementById("contactname").value,
    numberTag = document.getElementById("contactnumber").value,
    emailTag = document.getElementById("contactemail").value;
    
    //check if at least one values are present
    if(nameTag || numberTag || emailTag) {
        //store values in variable
        let contactInfo = {nameTag, numberTag, emailTag}
        //assign variable info
        if(!isUpdate) {
            contacts.push(contactInfo);
        } else {
            isUpdate = false;
            contacts[updateId] = contactInfo;
        }
        //make a string and sorte it
        localStorage.setItem("contacts", JSON.stringify(contacts));
        //display new contacts
        showContatcs();
    }
    //empty fields when done
    document.getElementById("contactname").value = "";
    document.getElementById("contactnumber").value = "";
    document.getElementById("contactemail").value = "";
};

//display contacts
function showContatcs() {
    //return if no contacts are available
    if(!contacts) return; 
    document.querySelectorAll(".grid-item").forEach(li => li.remove());

    //step through contacts and store them in a variable
    contacts.forEach((contact) => {
        let liTag = `<li class="grid-item">${contact.nameTag}</li>
                    <li class="grid-item">${contact.numberTag}</li>
                    <li class="grid-item">${contact.emailTag}</li>
                    `;
        //add items to the end of the grid container            
        nextrow.insertAdjacentHTML("beforeend", liTag);
    });
}
//display contacts
showContatcs();

//sort  contacts by name
function sortname(){
    console.log("im in");
    let contacts = JSON.parse(localStorage.getItem('contacts'));
    let allContacts = contacts.sort((a, b) => a[nameTag].localeCompare(b[nameTag]));
    // showContatcs();
    console.log(allContacts);
};

//sort contacts by number
function sortnumber(){
    console.log("im in");
    let contacts = JSON.parse(localStorage.getItem('contacts'));
    let allContacts = contacts.sort(function(a, b){
        return b.numberTag - a.numberTag
      });
    // showContatcs();
    console.log(allContacts);
};

//sort contacts by email
function sortemail(){
    console.log("im in");
    let contacts = JSON.parse(localStorage.getItem('contacts'));
    let allContacts = contacts.sort(function(a, b){
        return b.emailTag - a.emailTag
      });
    // showContatcs();
    console.log(allContacts);
};