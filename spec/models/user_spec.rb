require "rails_helper"

RSpec.describe User, type: :model do
  let(:role) { create :role }
  subject(:user) { create :user, role: role }

  it { is_expected.to have_db_column(:first_name).of_type(:string) }
  it { is_expected.to have_db_column(:last_name).of_type(:string) }
  it { is_expected.to have_db_column(:email).of_type(:string) }
  it { is_expected.to have_db_column(:password_digest).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to(:role) }
  it { is_expected.to have_many(:authentications) }
  it { is_expected.to have_many(:lists) }

  it { is_expected.to have_secure_password }

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.not_to allow_value("1234").for(:first_name) }
  it do
    is_expected.to validate_length_of(:first_name).is_at_least(3).
      with_message("Too short. The minimum length is 3 characters.")
  end

  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.not_to allow_value("1234").for(:last_name) }
  it do
    is_expected.to validate_length_of(:last_name).is_at_least(3).
      with_message("Too short. The minimum length is 3 characters.")
  end

  it { is_expected.to validate_presence_of :email }
  it do
    is_expected.to validate_uniqueness_of :email
  end
  it do
    is_expected.not_to allow_value(
      "person.ide%ntity[]()@.gmail.com"
    ).for(:email)
  end

  it { is_expected.to validate_length_of(:password).is_at_least(8) }

  it do
    expect(
      User.new(
        first_name: nil,
        last_name: nil,
        email: "user@email.com",
        password: nil,
        role: role
      ).save
    ).to be_falsey
  end

  it do
    expect(
      User.new(
        first_name: "ryan",
        last_name: "michael",
        email: "user@email.com",
        password: "foo",
        role: role
      ).save
    ).to be_falsey
  end

  it do
    expect(
      User.new(
        first_name: "ryan",
        last_name: "michael",
        email: "user@email.com",
        password: "8734yrh928h4h7282",
        role: role
      ).save
    ).to be_truthy
  end

  describe "#user_name" do
    it "returns the user's full name" do
      expect(user.user_name).to eq "#{user.first_name} #{user.last_name}"
    end
  end
end
