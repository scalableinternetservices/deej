require 'net/http'
require 'json'

class PlaylistsController < ApplicationController
  

  def show_user_playlists
    @playlists = Playlist.where(user_id: params[:id])
    @user = User.find_by(id: params[:id])
    render 'playlists/user_playlists'
  end

  def new
  	@playlist = Playlist.new
  end

  def create
  	@playlist = Playlist.new(playlist_params)
  	user = User.find_by(id: session[:user_id])
  	@playlist.user = user
  	if @playlist.save
  		redirect_to @playlist
  	else
  		flash.now[:danger] = "Error creating playlist"
  		render 'playlists/new'
  	end
  end

  def updatePlaying
    value = params[:value]
    @playlist = Playlist.find_by(id: params[:id])
    @playlist.update_attribute(:playing, value)
  end

  def next_song
    if (playlist = Playlist.find_by(id: params[:id]))
      #check if the requester is owner of playlist
      if (isOwner(current_user, playlist))
        #check for songs on queued list (grabs one with most upvotes)
        psong = playlist ? playlist.psongs.where(played: false).where(queued: true).order(:upvotes).last : nil
        if (!psong)
          #if no songs left on the queue
          psong = playlist.psongs.where(played: false).where(queued: false).order(:upvotes).last
        end
        if (!psong)
          #if no songs in waiting queue
          render :json => nil 
        else
          #if song found on a queue
          psong.update(played: true)
          render :json => psong.song
        end
      else
        redirect_to playlist
      end
    else
      redirect_to root_url
    end

  end


  def add_song
    song_id = params[:sid]
    playlist_id = params[:pid]
    json_response = deezer_song(song_id)    
    playlist = Playlist.find(playlist_id)

    if (song = Song.find_by(deezer_id: song_id))
      psong = Psong.create(song_id: song.id, playlist_id: playlist_id)
      if (!is_logged_in || !isOwner(current_user, playlist))
        psong.update_column(:queued, false)
    end
    else
      puts json_response
      puts json_response['contributors']
      song = playlist.songs.create(name: json_response['title'], artist: json_response['contributors'].first['name'], deezer_id: song_id)
      psong = Psong.find_by(playlist_id: playlist_id, song_id: song.id)
      if (!is_logged_in || !isOwner(current_user, playlist))
        psong.update_column(:queued, false)
      end
    end
  end

  private
  	def playlist_params
      params.require(:playlist).permit(:title, :songs, :album, :artist)
  	end

    def isOwner(user, playlist)
      return user.playlists.exists?(playlist.id)
    end

    def deezer_song(id)
      url = "http://api.deezer.com/track/#{id}&output=json"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      return JSON.parse(response, symbolize_keys: true)
    end
end