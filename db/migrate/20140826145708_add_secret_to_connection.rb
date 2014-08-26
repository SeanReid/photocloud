class AddSecretToConnection < ActiveRecord::Migration
  def change
    add_column :connections, :secret, :string
  end
end
