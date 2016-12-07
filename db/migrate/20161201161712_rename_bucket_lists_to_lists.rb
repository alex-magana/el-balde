class RenameBucketListsToLists < ActiveRecord::Migration[5.0]
  def change
    rename_table :bucket_lists, :lists
  end
end
