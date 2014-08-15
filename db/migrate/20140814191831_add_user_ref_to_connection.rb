class AddUserRefToConnection < ActiveRecord::Migration
  def change
    add_reference :connections, :user, index: true
  end
end
