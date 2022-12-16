// code frerenced from tutorial https://www.youtube.com/watch?v=ulOKYl5sHGk

import { useState } from 'react';
import uuid from "react-uuid";
import './App.css';
import Sidebar from './Sidebar';
import Main from './Main';

function App() {
  const [notes, setNotes] = useState([])
  const [activeNote, setActiveNote] = useState(false);

  const onAddNote = () => {
    const newNote = {
      id: uuid(),
      title: "Untitled Note",
      body: "",
      lastModified: Date.now(),
    }
    setNotes([newNote, ...notes]);
  };

  const onUpdateNote = (updatedNote) => {
    const updatedNoteArray = notes.map((note) => {
      if (note.id === activeNote){
        return updatedNote;
      }
      return note;
    });
    setNotes(updatedNoteArray);
  }

  const onDeleteNote = (idToDelete) => {
    setNotes(notes.filter((note) => note.id !== idToDelete))
  };

  const getActiveNote = () => {
    return notes.find((note) => note.id === activeNote);
  }

  return (
    <div className="App">
      <Sidebar 
      notes={notes} 
      onAddNote={onAddNote} 
      onDeleteNote={onDeleteNote} 
      activeNote={activeNote}
      setActiveNote={setActiveNote}
      />
      <Main activeNote={getActiveNote()} onUpdateNote={onUpdateNote}/>
    </div>
  );
}

export default App;
