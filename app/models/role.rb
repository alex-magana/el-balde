class Role < ApplicationRecord
  has_many :users

  enum role_name: { admin: "ADMIN", n_user: "N_USER" }

  validates :role_name,
            presence: true
end
