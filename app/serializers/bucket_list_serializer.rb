class BucketListSerializer < ActiveModel::Serializer
  include Concerns::RecordRender

  attributes :id, :name, :items, :date_created, :date_modified, :created_by
  has_many :items

  def items
    object.bucket_list_items
  end

  def created_by
    object.user.user_name
  end
end
