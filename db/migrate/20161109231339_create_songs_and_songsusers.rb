class CreateSongsAndSongsusers < ActiveRecord::Migration[5.0]

  def change
    create_table :songs do |t|
    	t.string :title
    	t.string :artist
    	t.string :album
    	t.integer :deezer_id
      t.timestamps
    end

    create_table :songs_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :song, index: true
    end

  end
end
