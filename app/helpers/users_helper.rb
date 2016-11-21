module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  	def cache_key_for_topdjs(djs)
    	"djs-#{djs.count}-#{User.maximum(:updated_at)}"
	end

	def cache_key_for_user_info(user)
		"user-#{user.updated_at}"
	end

	def cache_key_for_songs(user)
		"songs-#{user.songs.size}-#{user.song_ids}"
	end

	def cache_key_for_followers(user)
		"followers-#{user.followers.count}-#{Relationship.where("followed_id = :user_id", user_id: user.id)}"
	end

	def cache_key_for_following(user)
		"following-#{user.followers.count}-#{Relationship.where("follower_id = :user_id", user_id: user.id)}"
	end
end