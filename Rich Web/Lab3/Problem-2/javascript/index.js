//set rxjs constants
const { Observable, fromEvent } = rxjs;

//set constants
const hoursBox = document.getElementById("hoursBox");
const minutesBox = document.getElementById("minutesBox");
const secondsBox = document.getElementById("secondsBox");

//set default state of timer to off
let state = false;

//subscribe to the start button to start / /stop the timer
rxjs.fromEvent(document.getElementById("startButton"), 'click')
.subscribe(() => stateStartStop());

//function to start stop the timer
function stateStartStop(){
    //if timer is not running begin the timer
    if(!state){

        //swap state to on
        state = !state;

        //calculate the total time input by the user in seconds
        totalTime = parseInt(hoursBox.value) * 3600 + parseInt(minutesBox.value) * 60 + parseInt(secondsBox.value);
        
        //subscribe to an rxjs timer to call the timer display and update it every second
        //total time in seconds is reduced by the amount of times this is run
        timerObs = rxjs.timer(0, 1000)
        .subscribe(i => timerDisplay(totalTime - i));

        //change the button to display stop, change its color to red and show the bottom box with the current timer
        document.getElementById("startButton").innerHTML = "Stop";
        document.getElementById("startButton").style.backgroundColor = "red"
        document.getElementById("display").style.visibility = "visible";

        //reset the input fields to 00
        document.getElementById("hoursBox").value = "00";
        document.getElementById("minutesBox").value = "00";
        document.getElementById("secondsBox").value = "00";
        
    }
    //if timer is already running
    else{
        //swap state to off
        state = !state;

        //change the button to display start, change its color to green and hide the bottom box with the current timer
        document.getElementById("startButton").innerHTML = "Start";
        document.getElementById("startButton").style.backgroundColor = "lawngreen";
        document.getElementById("display").style.visibility = "hidden";
        
        //unsubscribe from the rxjs timer as the counddown has been forcefully stopped
        timerObs.unsubscribe();
        
        //remove the countdown text and no timer is running
        document.getElementById("timeDisplay").innerHTML = "";
    }
}

//funtion to display the time and check if its finished
function timerDisplay(totalTime){

    //if timer is finished
    if (totalTime == 0){
        //unsubscribe from the rxjs timer as the countdown has finished
        timerObs.unsubscribe();

        //change the button to display start, change its color to green and and display the countdown end message
        document.getElementById("startButton").innerHTML = "Start";
        document.getElementById("startButton").style.backgroundColor = "lawngreen";
        document.getElementById("timeDisplay").innerHTML = "Countdown has finished";

        //swap state to off
        state = !state;
    }
    //if timer is running display time until end of countdown
    else{

        //set variables
        let hours, minutes, seconds;
        
        //split the remaining total time into hours, minutes and seconds
        //calulate hours using modulo remainder to drop minutes / seconds
        hours = (totalTime - totalTime % 3600) / 3600;

        //remove hours from the total time
        totalTime = totalTime - hours * 3600;

        //calulate minutes using modulo remainder to drop seconds
        minutes = (totalTime - totalTime % 60) / 60;

        //calculate seconds
        seconds = totalTime - minutes * 60;

        //display the calulated hours, minutes and seconds
        document.getElementById("timeDisplay").innerHTML = hours + " hours " + minutes + " minutes " + seconds + " seconds";
    }
}



