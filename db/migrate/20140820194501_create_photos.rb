class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos, :uid => false do |t|
      t.references :connection
      t.string :url
      t.datetime :taken_date
      t.integer :uid, :limit => 8

      t.timestamps
    end
  end
end
