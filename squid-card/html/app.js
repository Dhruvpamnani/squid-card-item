const closeKey = [27];

window.addEventListener("message", function(event) {
    let action = event.data.action
    
    if (action == "show") {
        $('body').show();

    } else if (action == "close") {
        $('body').hide();

    } else if (action == "newnumber") {
        $('.number-text').text(event.data.number)
    }
});

$('.card-outer').tilt({
    scale: 1.05,
    perspective: 500
})

$('.card-outer').tilt({
    glare: false,
    maxGlare: .5
})

$("body").on("keyup", function (key) {
    if (closeKey.includes(key.which)) {
        $('body').hide();
        $.post("http://squid-card/closeCard", JSON.stringify({}))
    }
  });

function flip(event) {
	var element = event.currentTarget;
	if (element.className === "card") {
    if(element.style.transform == "rotateY(180deg)") {
        element.style.transform = "rotateY(0deg)";

        setTimeout(function() { 
            $('.card-back').hide();
            $('.card-front').show();
        }, 300);
    }
    else {
        element.style.transform = "rotateY(180deg)";
        setTimeout(function() { 
            $('.card-front').hide();
            $('.card-back').show();
        }, 300);
    }
  }
};
