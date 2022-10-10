// some code refrenced from 
//https://www.codingnepalweb.com/build-a-notes-app-in-html-css-javascript/

const addBox = document.querySelector(".add-box"),
addNote = document.querySelector(".popup-box"),
addText = addNote.querySelector("header p"),
closeIcon = addNote.querySelector("header i"),
titleTag = addNote.querySelector("input"),
descTag = addNote.querySelector("textarea"),
addButton = addNote.querySelector("button");

const notes = JSON.parse(localStorage.getItem("notes") || "[]");
let isUpdate = false, updateId;

addBox.addEventListener("click", () => {
    addText.innerText = "Add Note";
    addButton.innerText = "Add Note";
    addNote.classList.add("show");
    document.querySelector("body").style.overflow = "hidden";
});

function showNotes() {
    if(!notes) return;
    document.querySelectorAll(".note").forEach(li => li.remove());
    notes.forEach((note, id) => {
        let newDesc = note.description.replaceAll("\n", '<br/>');
        let liTag = `<li class="note">
                        <div class="details">
                            <p>${note.title}</p>
                            <span>${newDesc}</span>
                        </div>
                        <div class="bottom-content">
                            <span> options </span>
                            <div class="settings">
                                <i onclick="showMenu(this)" class="fa fa-ellipsis-h"></i>
                                <ul class="menu">
                                    <li onclick="updateNote(${id}, '${note.title}', '${newDesc}')"><i class="fa fa-pencil"></i>Edit</li>
                                    <li onclick="deleteNote(${id})"><i class="fa fa-trash"></i>Delete</li>
                                    <li onclick="colorNote(${id})"><i class="fa fa-eyedropper"></i>Color</li>
                                </ul>
                            </div>
                        </div>
                    </li>`;
        addBox.insertAdjacentHTML("afterend", liTag);
    });
}
showNotes();

function showMenu(elem) {
    elem.parentElement.classList.add("show");
    document.addEventListener("click", e => {
        if(e.target.tagName != "I" || e.target != elem) {
            elem.parentElement.classList.remove("show");
        }
    });
}

function deleteNote(noteId) {
    notes.splice(noteId, 1);
    localStorage.setItem("notes", JSON.stringify(notes));
    showNotes();
}

function updateNote(noteId, title, newDesc) {
    let description = newDesc.replaceAll('<br/>', '\r\n');
    updateId = noteId;
    isUpdate = true;
    addBox.click();
    titleTag.value = title;
    descTag.value = description;
    addText.innerText = "Update Note";
    addButton.innerText = "Update Note";
}

addButton.addEventListener("click", () => {
    let title = titleTag.value.trim(),
    description = descTag.value.trim();
    
    if(title || description) {
        let noteInfo = {title, description}
        if(!isUpdate) {
            notes.push(noteInfo);
        } else {
            isUpdate = false;
            notes[updateId] = noteInfo;
        }
        localStorage.setItem("notes", JSON.stringify(notes));
        showNotes();
        addNote.classList.remove("show");
    }
});