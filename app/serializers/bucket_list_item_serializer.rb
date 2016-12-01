class BucketListItemSerializer < ActiveModel::Serializer
  include Concerns::RecordRender

  attributes :id, :name, :date_created, :date_modified, :done
end
