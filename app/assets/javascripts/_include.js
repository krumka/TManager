//Get la page courante
var url = $(location).attr('href').split("/");
url = url[3];
url = url.split("?")[0];
console.log(url);

switch(url){
    case "games" :
        loadScript("games.js", null);
        break;
    case "tournaments" :
        loadScript("tournaments.js", null);
        break;
    case "users" :
        loadScript("users.js", null);
        break;
    case "matches" :
        loadScript("matches.js", null);
        break;
}
$( document ).ready(function() {
    $( window ).resize(function() {
        if($( window ).height()>=$( document ).height()){
            $("footer").css("bottom", 0);
            $("footer").css("position", "fixed");
        }else{
            $("footer").css("position", "relative");
        }
    });
    if($( window ).height()>=$( document ).height()){
        $("footer").css("bottom", 0);
        $("footer").css("position", "fixed");
    }
    $(window).scroll(function() {
        if ($(document).scrollTop() > 50) {
            $('nav').addClass('shrink');
        } else {
            $('nav').removeClass('shrink');
        }
    });
    $(".alert").delay(5000).hide('slow');
    $(".birthdate select").addClass("form-control form-control-inline");
});



function loadScript(url, callback){
    // Adding the script tag to the head as suggested before
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = "/assets/" + url;

    // Then bind the event to the callback function.
    // There are several events for cross browser compatibility.
    script.onreadystatechange = callback;
    script.onload = callback;

    // Fire the loading
    head.appendChild(script);
}