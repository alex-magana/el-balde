class CreateBucketListItems < ActiveRecord::Migration[5.0]
  def change
    create_table :bucket_list_items do |t|
      t.string :name
      t.boolean :done
      t.belongs_to :bucket_list, foreign_key: true

      t.timestamps
    end
  end
end
