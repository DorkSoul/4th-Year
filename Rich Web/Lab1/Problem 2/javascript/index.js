const note = document.querySelector(".add-box"),
addNote = document.querySelector(".popup-box"),
addText = addNote.querySelector("header p"),
closeIcon = addNote.querySelector("header i"),
titleTag = addNote.querySelector("input"),
descTag = addNote.querySelector("textarea"),
addButton = addNote.querySelector("button");

const notes = JSON.parse(localStorage.getItem("notes") || "[]");
let isUpdate = false, updateId;

note.addEventListener("click", () => {
    addText.innerText = "Add Note";
    addButton.innerText = "Add Note";
    addNote.classList.add("show");
    document.querySelector("body").style.overflow = "hidden";
});

addButton.addEventListener("click", e => {
    e.preventDefault();
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

        addNote.classList.remove("show");
    }
});