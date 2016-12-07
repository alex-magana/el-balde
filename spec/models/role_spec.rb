require "rails_helper"

RSpec.describe Role, type: :model do
  subject(:role) { create(:role) }

  it { is_expected.to have_db_column(:role_name).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to have_many(:users) }

  it { is_expected.to validate_presence_of :role_name }
end
