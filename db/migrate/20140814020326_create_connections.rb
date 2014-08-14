class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :uid
      t.string :token
      t.string :name

      t.timestamps
    end
  end
end
