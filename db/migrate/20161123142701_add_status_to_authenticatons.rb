class AddStatusToAuthenticatons < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :status, :boolean
  end
end
