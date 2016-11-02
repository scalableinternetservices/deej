//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

function openTab(evt, cityName) {
var i, tabcontent, tablinks;
tabcontent = document.getElementsByClassName("tabcontent");
for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
}
tablinks = document.getElementsByClassName("tablinks");
for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
}
document.getElementById(cityName).style.display = "block";
evt.currentTarget.className += " active";
}

function getPlaylist(d, s, id) { 
	var js, djs = d.getElementsByTagName(s)[0];
	if (d.getElementById(id)) return; 
	js = d.createElement(s); js.id = id; 
	js.src = "https://cdns-files.dzcdn.net/js/widget/loader.js"; 
	 djs.parentNode.insertBefore(js, djs);
}