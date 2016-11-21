module MicropostsHelper
	def cache_key_for_comments(comments)
    	"comments-#{comments}-#{comments.count}"
	end
end
