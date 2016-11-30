//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

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
        var deezer_id = data.data[i].id;
        var title = data.data[i].title;
        var artist = data.data[i].artist.name;
        var album = data.data[i].album.title;
        var titleF = title.replace(/ /g,"_");
        var artistF = artist.replace(/ /g,"_");
        var albumF = album.replace(/ /g,"_");
        $('#songs').append("<tr deezer_id=" + deezer_id + " titleF=" + titleF +" artistF=" + artistF + " albumF=" + albumF + "><td>" + title + "</td><td>" + artist + "</td><td>" + album + "</td><td><button class='add-button' onClick='addSongToUser(this);'><span>Add</span></button></td></tr>");
    }
}

function addSongToUser(song_element){
    var song = $(song_element).parent().parent();
    var song_did = song.attr('deezer_id');
    var song_title = song.attr('titleF');
    var song_artist = song.attr('artistF');
    var song_album = song.attr('albumF');
    $.post("/users/" + getUserId() + "/add_song/" + song_did + "/" + song_title + "/" + song_artist + "/" + song_album);
}

function playSong(deezer_id){
    $.post("/users/" + getUserId() + "/set_song/" + deezer_id);
    window.location.reload(true);
}

function removeSong(song_id, user_id){
    $.post("/users/" + song_id + "/remove_song/" + user_id);
    window.location.reload(true);
}

function getUserId(){
    var path = window.location.pathname;
    var uid = path.split('/')[2];
    return uid;
}

function refresh(){
    window.location.reload(true);
}