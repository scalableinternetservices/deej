class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
    @users_ordered_followers = User.all.sort_by(&:follower_count).reverse
  end

  def show
    @user = User.find(params[:id])
    @following = @user.following.paginate(page: params[:page])
    @followers = @user.followers.paginate(page: params[:page])
    @micropost  = current_user.microposts.build
    @comments = @user.comments.paginate(page: params[:page])
    ids = @user.song_ids
    @songs = @user.display_songs(ids)
  end

  def new
    @user = User.new
  end

  def add_song
    deezer_id = params[:did]
    user_id = params[:uid]
    title = params[:title]
    artist_name = params[:artist]
    album_name = params[:album]   
    @user = User.find(user_id)
    if (@song = Song.find_by(deezer_id: deezer_id))
      print "Found song"
      @user.songs << @song
      print "Found song and added user song relation"
    else
      print "No song found"
      @song = Song.create(title: title, artist: artist_name, album: album_name, deezer_id: deezer_id)
      print "Song created"
      @user.songs << @song
      print "Song created and added to user's songs"
    end
  end

  def set_song
    user_id = params[:uid]
    deezer_id = params[:did]
    @user = User.find(user_id)
    @user.update_attribute(:current_song_id, deezer_id)
  end


  def remove_song
    song_id = params[:sid]
    user_id = params[:uid]
    @user = User.find(user_id)
    @song = Song.find(song_id)
    @user.songs.destroy(@song)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the deej!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private

    def deezer_song(id)
      url = "http://api.deezer.com/track/#{id}&output=json"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      return JSON.parse(response, symbolize_keys: true)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :about,
                                   :password_confirmation, :avatar)
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
