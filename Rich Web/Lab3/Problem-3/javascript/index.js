//set rxjs constants
const { observable, fromEvent } = rxjs;

//set constants
const newNote = document.getElementById('newNoteButton')

//subscribe to new note button click to create a new note
rxjs.fromEvent(newNote, 'click').subscribe(() => {
    createNote(document.body)
    })

//fucntion to create new note
function createNote(createPosition) {
    //constant to create new div element
    const note = document.createElement('div') 
    
    //add class note to new div
    note.classList.add('note')  

    //add html to make the note in new div
    note.innerHTML = 
    `
    <div class="noteBackground">   
        <textarea class="noteBody"}></textarea>
        <div class="noteOptions">    
            <button class="delete">delete</button>   
            <button class="createChild">create child note</button>
        </div>  
    </dib>
    `  

    //add delete and create child buttions to new note
    const deleteBtn = note.querySelector('.delete')  
    const createChildBtn = note.querySelector('.createChild')  

    //subscribe to the new delete button to delete the note
    rxjs.fromEvent(deleteBtn, 'click').subscribe(() => {
    note.remove() 
    })

    //subscribe to the new create child note button to add a child note
    rxjs.fromEvent(createChildBtn, 'click').subscribe(() => {
    createNote(note)
    })

    //link the new note to a parent note
    createPosition.appendChild(note)  
}  