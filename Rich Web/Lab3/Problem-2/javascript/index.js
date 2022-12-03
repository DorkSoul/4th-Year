const { Observable, fromEvent } = rxjs;

const hoursBox = document.getElementById("hoursBox");
const minutesBox = document.getElementById("minutesBox");
const secondsBox = document.getElementById("secondsBox");

let state = false;

rxjs.fromEvent(document.getElementById("startButton"), 'click').subscribe(() => stateStartStop());

function stateStartStop(){
    if(!state){

        state = !state;

        total_time = hoursBox.value * 3600 + minutesBox.value * 60 + parseInt(secondsBox.value);
        
        timerObs = rxjs.timer(0, 1000).subscribe(i => TimerDisplay(total_time - i));

        document.getElementById("startButton").innerHTML = "Stop";
        document.getElementById("startButton").style.backgroundColor = "red"
        document.getElementById("display").style.visibility = "visible";

        document.getElementById("hoursBox").value = "00";
        document.getElementById("minutesBox").value = "00";
        document.getElementById("secondsBox").value = "00";
        
    }
    else{
        state = !state;

        document.getElementById("startButton").innerHTML = "Start";
        document.getElementById("startButton").style.backgroundColor = "lawngreen";
        document.getElementById("display").style.visibility = "hidden";
        
        timerObs.unsubscribe();
        document.getElementById("timeDisplay").innerHTML = "";
    }
}

function TimerDisplay(untilEnd){

    if (untilEnd == 0){
        timerObs.unsubscribe();

        document.getElementById("startButton").innerHTML = "Start";
        document.getElementById("startButton").style.backgroundColor = "lawngreen";
        document.getElementById("timeDisplay").innerHTML = "Time's Up!";

        state = !state;
    }
    else{

        let hours, minutes, seconds;
        
        hours = (untilEnd - untilEnd % 3600) / 3600;
        untilEnd = untilEnd - hours * 3600;

        minutes = (untilEnd - untilEnd % 60) / 60;
        seconds = untilEnd - minutes * 60;

        document.getElementById("timeDisplay").innerHTML = hours + " hours " + minutes + " minutes " + seconds + " seconds";
    }
}



