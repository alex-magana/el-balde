class UserSerializer < ActiveModel::Serializer
  include Concerns::RecordRender

  attributes :name, :email, :date_created, :date_modified

  def name
    object.user_name
  end
end
