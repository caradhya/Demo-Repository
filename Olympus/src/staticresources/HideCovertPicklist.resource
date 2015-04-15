window.onload = function(){
var selectobject=document.getElementById("lea13")
for (var i=0; i<selectobject.length; i++){
if(selectobject.options[i].value=='Converted'){
selectobject.remove(i);
}
}
}