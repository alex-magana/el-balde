class Authentication < ApplicationRecord
  belongs_to :user

  validates :token,
            presence: true

  def self.validate_token(token)
    authentication = Authentication.find_by(token: token)
    if authentication
      authentication.status
    else
      false
    end
  end

  def self.invalidate_token(user, status)
    authentication = Authentication.find_by(
      user_id: user.id,
      status: status
    )
    authentication.status = false
    authentication.save
  end

  def self.search_valid_token(user, status = true)
    find_by(user_id: user.id, status: status)
  end
end
