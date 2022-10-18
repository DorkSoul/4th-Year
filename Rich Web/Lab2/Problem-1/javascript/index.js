const nameTag = document.querySelector("name"),
numberTag = document.querySelector("number"),
emailTag = document.querySelector("email");

const contacts = JSON.parse(localStorage.getItem("contacts") || "[]");
let isUpdate = false, updateId;

function addContact(){
    console.log("it worked");
    let name = nameTag.value.trim(),
    number = numberTag.value.trim(),
    email = emailTag.value.trim();
    
    if(name || number || email) {
        let contactInfo = {name, number, email}
        if(!isUpdate) {
            contacts.push(contactInfo);
        } else {
            isUpdate = false;
            contacts[updateId] = contactInfo;
        }
        localStorage.setItem("contacts", JSON.stringify(contacts));
        // showNotes();
        // addNote.classList.remove("show");
    }
};