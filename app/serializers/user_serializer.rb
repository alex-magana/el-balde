class UserSerializer < ActiveModel::Serializer
  include Concerns::RecordRender

  attributes :id, :name, :email, :date_created, :date_modified

  def name
    object.user_name
  end
end
