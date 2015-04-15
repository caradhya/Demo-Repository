
window.onload = function(){    
//Replace this section with whatever you need to hide/replace/modify on the standard Salesforce screen
var selectobject=document.getElementByName("lea13");
for (var i=0; i<selectobject.length; i++){
if(selectobject.options[i].value == 'Converted')
{
	selectobject.remove(i);
}
}
}