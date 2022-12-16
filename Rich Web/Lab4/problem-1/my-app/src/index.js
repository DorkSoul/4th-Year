// some code refrenced from 
//https://www.codingnepalweb.com/build-a-notes-app-in-html-css-javascript/

//set rxjs constants
const { Observable, fromEvent } = rxjs;

//set constants
const addBox = document.querySelector(".add-box"),
addNote = document.querySelector(".popup-box"),
addText = addNote.querySelector("header p"),
closeIcon = addNote.querySelector("header i"),
titleTag = addNote.querySelector("input"),
descTag = addNote.querySelector("textarea"),
addButton = addNote.querySelector("button");

//create notes local storage
const notes = JSON.parse(localStorage.getItem("notes") || "[]");
let isUpdate = false, updateId;

//subscribe to the addBox click event to add a note when clicked
rxjs.fromEvent(addBox, 'click')
  .subscribe(() => addbox());

//funtion to display the box to add a note and enter information
//add title and button text, shows the box and sets overflow
function addbox() {
addText.innerText = "Add Note",
addButton.innerText = "Add Note",
addNote.classList.add("show"),
document.querySelector("body").style.overflow = "hidden";
};
  
//fuction to display notes
function showNotes() {
    //if there are no notes in storage stop function
    if(!notes) return;

    //if there are notes remove any on dom
    document.querySelectorAll(".note").forEach(li => li.remove());
    
    //get the note and id of every note in storage and loop through them
    notes.forEach((note, id) => {
        //create dom elements using html entering the data retrieved from storage for each note
        let newDesc = note.description.replaceAll("\n", '<br/>');
        let liTag = `<li class="note">
                        <div class="details">
                            <p>${note.title}</p>
                            <span>${newDesc}</span>
                        </div>
                        <div class="bottom-content">
                            <div class="settings">
                                <i onclick="showMenu(this)" class="options">options</i>
                                <ul class="menu">
                                    <li onclick="updateNote(${id}, '${note.title}', '${newDesc}')"><i class="fa fa-pencil"></i>Edit</li>
                                    <li onclick="deleteNote(${id})"><i class="fa fa-trash"></i>Delete</li>
                                    <li onclick="colorNote(${id})"><i class="fa fa-eyedropper"></i>Color</li>
                                </ul>
                            </div>
                        </div>
                    </li>`;
        //insert the created element into the html dom and loop to next note in storage. repeat until all notes have been parsed   
        addBox.insertAdjacentHTML("afterend", liTag);
    });
}
//display any notes currently in storage
showNotes();

//function to show the options menu on seleted note
function showMenu(elem) {
    elem.parentElement.classList.add("show");
    document.addEventListener("click", e => {
        if(e.target.tagName != "I" || e.target != elem) {
            elem.parentElement.classList.remove("show");
        }
    });
}

//funtion to delete selected note
function deleteNote(noteId) {
    notes.splice(noteId, 1);
    localStorage.setItem("notes", JSON.stringify(notes));
    showNotes();
}

//funtion to edit a selected note
function updateNote(noteId, title, newDesc) {
    let description = newDesc.replaceAll('<br/>', '\r\n');
    updateId = noteId;
    isUpdate = true;

    //click to display the edit box
    addBox.click();

    titleTag.value = title;
    descTag.value = description;
    addText.innerText = "Update Note";
    addButton.innerText = "Update Note";
}

//subscribe to the add note button on the add box
rxjs.fromEvent(addButton, 'click')
  .subscribe(() => addNoteButton());

//create a note with the entered title and description
function addNoteButton(){
    //get input data
    let title = titleTag.value.trim(),
    description = descTag.value.trim();
    
    //check if there is info in at least one field and create the note
    if(title || description) {
        let noteInfo = {title, description}
        if(!isUpdate) {
            notes.push(noteInfo);
        } else {
            isUpdate = false;
            notes[updateId] = noteInfo;
        }
        //add note to local storage
        localStorage.setItem("notes", JSON.stringify(notes));

        //show all notes
        showNotes();
        
        //hide add box
        addNote.classList.remove("show");
    }
}