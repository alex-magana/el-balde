class Item < ApplicationRecord
  extend Concerns::ModelMessages
  extend Concerns::Paginate

  belongs_to :list

  VALID_REGEX_NAME = /[a-zA-Z]+/

  validates :name,
            presence: true,
            format: { with: VALID_REGEX_NAME },
            length: { minimum: 3,
                      message: name_length }

  def self.catalog(list, page, limit)
    where(list_id: list.id).paginate(page, limit)
  end
end
