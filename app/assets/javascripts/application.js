//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

function openTab(evt, tabName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
}

function getPlaylist(d, s, id) { 
	var js, djs = d.getElementsByTagName(s)[0];
	if (d.getElementById(id)) return; 
	js = d.createElement(s); js.id = id; 
	js.src = "https://cdns-files.dzcdn.net/js/widget/loader.js"; 
	 djs.parentNode.insertBefore(js, djs);
}

function getSong() {
	var song = $('#deezer-search').val();

	$.ajax({
    url: "https://api.deezer.com/search?q=" + song + "&output=jsonp" + "&callback=?",
    dataType: 'jsonp',
    type: 'GET',
    success: function (data) {
        console.log(data);
        listSongs(data);
    }
	});

}

function listSongs(data) {
$('#songs').empty();
for (var i = 0; i < data.data.length; i++) {
$('#songs').append("<tr song_id=" + data.data[i].id + "><td>" + data.data[i].title + "</td><td>" + data.data[i].artist.name + "</td><td><button class='add-button'><span>Add</span></button></td></tr>");
    }
}