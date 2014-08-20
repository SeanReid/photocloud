class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :url
      t.string :taken_date
      t.string :uid

      t.timestamps
    end
  end
end
