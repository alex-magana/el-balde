class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :date_created, :date_modified

  def name
    "#{object.first_name} #{object.last_name}"
  end

  def date_created
    object.created_at.strftime("%Y-%m-%d %l:%M:%S")
  end

  def date_modified
    object.updated_at.strftime("%Y-%m-%d %l:%M:%S")
  end
end
