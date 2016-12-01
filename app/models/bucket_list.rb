class BucketList < ApplicationRecord
  extend Concerns::Paginate

  belongs_to :user
  has_many :bucket_list_items, dependent: :destroy

  VALID_REGEX_NAME = /[a-zA-Z]+/

  validates :name,
            presence: true,
            format: { with: VALID_REGEX_NAME },
            length: { minimum: 3,
                      message: "Too short. The minimum length"\
                               " is 3 characters." },
            uniqueness: {
              scope: :user_id,
              message: "A list with a similar name already exists."
            }

  def self.search_by_name(name)
    where("lower(name) LIKE ?", "%#{name}%")
  end
end
