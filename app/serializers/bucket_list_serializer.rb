class BucketListSerializer < ActiveModel::Serializer
  attributes :id, :name, :items, :date_created, :date_modified, :created_by
  has_many :items

  def items
    object.bucket_list_items
  end

  def date_created
    object.created_at.strftime("%Y-%m-%d %l:%M:%S")
  end

  def date_modified
    object.updated_at.strftime("%Y-%m-%d %l:%M:%S")
  end

  def created_by
    "#{object.user.first_name} #{object.user.last_name}"
  end
end
