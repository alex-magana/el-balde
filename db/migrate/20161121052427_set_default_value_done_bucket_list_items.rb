class SetDefaultValueDoneBucketListItems < ActiveRecord::Migration[5.0]
  def change
    change_column :bucket_list_items, :done, :boolean, default: false
  end
end
