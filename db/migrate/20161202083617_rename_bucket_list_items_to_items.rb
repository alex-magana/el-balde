class RenameBucketListItemsToItems < ActiveRecord::Migration[5.0]
  def changes
    rename_table :bucket_list_items, :items
  end
end
