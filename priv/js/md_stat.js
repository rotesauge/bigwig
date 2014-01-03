$(document).ready(function(){
    $('#md_title').html($('<h2>MD Statistic</h2>'));
    $("#counter").flipCounter({
        number:0, // the initial number the counter should display, overrides the hidden field
        numIntegralDigits:1, // number of places left of the decimal point to maintain
        numFractionalDigits:0, // number of places right of the decimal point to maintain
        digitClass:"counter-digit", // class of the counter digits
        counterFieldName:"counter-value", // name of the hidden field
        digitHeight:40, // the height of each digit in the flipCounter-medium.png sprite image
        digitWidth:30, // the width of each digit in the flipCounter-medium.png sprite image
        imagePath:"../images/flipCounter-medium.png", // the path to the sprite image relative to your html document
        easing: false, // the easing function to apply to animations, you can override this with a jQuery.easing method
        duration:10000, // duration of animations
        onAnimationStarted:false, // call back for animation upon starting
        onAnimationStopped:false, // call back for animation upon stopping
        onAnimationPaused:false, // call back for animation upon pausing
        onAnimationResumed:false // call back for animation upon resuming from pause
    });
    $("#counter").flipCounter(
        "startAnimation", // scroll counter from the current number to the specified number
        {
                number: 5, // the number we want to scroll from
                end_number: 1024, // the number we want the counter to scroll to
                easing: jQuery.easing.easeOutCubic, // this easing function to apply to the scroll.
                duration: 5000, // number of ms animation should take to complete
                onAnimationStarted: myStartFunction, // the function to call when animation starts
                onAnimationStopped: myStopFunction, // the function to call when animation stops
                onAnimationPaused: myPauseFunction, // the function to call when animation pauses
                onAnimationResumed: myResumeFunction // the function to call when animation resumes from pause
        }
    );
    connect("/md/stream");
});

function connect(to)
{
       var host = document.location.host;
       websocket = new WebSocket("ws://"+host+to);
       websocket.onopen = function(evt) { onOpen(evt) }; 
       websocket.onclose = function(evt) { onClose(evt) }; 
       websocket.onmessage = function(evt) { onMessage(evt) }; 
};  
      
function onOpen(evt) { 
};  

function onClose(evt) { 
};  

function onMessage(evt) {
    document.getElementById("md_statistic").innerHTML="";
    var msg = JSON.parse(evt.data);
    for(var node in msg)
	  {
    	$('#md_statistic').append('<p>' + "MDNode: " + node + '</p>');
    	$('#md_statistic').append('<p>' + "Count: " + msg[node] + '</p>');
	  }
    

};  
