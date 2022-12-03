const { observable, fromEvent, tap } = rxjs;
  
function createNote(locationNode) {  
    const note = document.createElement('div') 
    
    note.classList.add('note')  
    note.innerHTML = 
    `
    <div class="noteGroup">   
        <textarea class="noteBody"}></textarea>
        <div class="noteOptions">    
            <button class="delete">delete</button>   
            <button class="createChild">create child note</button>
        </div>  
    </dib>
    `  

    const deleteBtn = note.querySelector('.delete')  
    const createChildBtn = note.querySelector('.createChild')  

    rxjs.fromEvent(deleteBtn, 'click').pipe(rxjs.tap(() => {
    note.remove() 
    })).subscribe()

    rxjs.fromEvent(createChildBtn, 'click').pipe(rxjs.tap(() => {
    createNote(note)
    })).subscribe()

    locationNode.appendChild(note)  
}  
    
    
function showNotes(){
    const newNote = document.getElementById('newNoteButton')  
    rxjs.fromEvent(newNote, 'click').pipe(rxjs.tap(() => {
    createNote(document.body)
    })).subscribe()
}

showNotes()