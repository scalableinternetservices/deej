class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
    	t.string :title
    	t.string :artist
    	t.string :url
    	t.string :album
    	t.string :cover_art_url
    	t.integer :deezer_id
    	t.integer :playlist_id
      t.timestamps
    end
  end
end
