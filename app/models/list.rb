class List < ApplicationRecord
  extend Concerns::ModelMessages
  extend Concerns::Paginate

  belongs_to :user
  has_many :items, dependent: :destroy

  VALID_REGEX_NAME = /[a-zA-Z]+/

  validates :name,
            presence: true,
            format: { with: VALID_REGEX_NAME },
            length: { minimum: 3,
                      message: name_length },
            uniqueness: {
              scope: :user_id,
              message: list_name_uniqueness
            }

  def self.search_by_name(name)
    where("lower(name) LIKE ?", "%#{name}%")
  end

  def self.catalog(user, page, limit)
    where(user_id: user.id).paginate(page, limit)
  end
end
