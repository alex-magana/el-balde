class BucketListItem < ApplicationRecord
  extend Concerns::Paginate

  belongs_to :bucket_list

  VALID_REGEX_NAME = /[a-zA-Z]+/

  validates :name,
            presence: true,
            format: { with: VALID_REGEX_NAME },
            length: { minimum: 3,
                      message: "Too short. The minimum length"\
                               " is 3 characters." }
end
