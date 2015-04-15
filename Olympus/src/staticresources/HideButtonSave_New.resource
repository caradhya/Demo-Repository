window.onload = function() {
    var url = window.location.href;
    /*var tabUrlL = "/00Q";
    var selectobject = document.getElementById("lea13")
    if (url.indexOf(tabUrlL) !== -1) {
        for (var i = 0; i < selectobject.length; i++) {
            if (selectobject.options[i].value == 'Converted') {
                selectobject.remove(i);
            }
        }
    }*/
	console.log('hello');
    var tabUrlQ = "/a0i";
    var x = document.getElementsByName("save_new"); //Here's where you hide your button
	if(url.indexOf(tabUrlQ) == -1){
		
		preventDefault();
	}else{
		for (var i = 0; i < x.length; i++) {
            x[i].style.visibility = "hidden";
            x[i].style.display = "none";
        }
    }
}