class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.string :token
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
