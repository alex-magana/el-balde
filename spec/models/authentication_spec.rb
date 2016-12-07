require "rails_helper"

RSpec.describe Authentication, type: :model do
  let!(:role) { create :role }
  let!(:user) { create :user, role: role }

  it { is_expected.to have_db_column(:token).of_type(:string) }
  it { is_expected.to have_db_column(:status).of_type(:boolean) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:token) }

  describe ".validate_token" do
    context "with an existing token" do
      it "is expected to return the status of a token" do
        auth = create :authentication, user: user, status: true

        expect(
          Authentication.validate_token(auth.token)
        ).to eq auth.status
      end
    end

    context "with an non-existing token" do
      it "returnsvalue false" do
        expect(
          Authentication.validate_token("token")
        ).to eq false
      end
    end
  end

  describe ".invalidate_token" do
    it "is expected to update token status to false" do
      auth = create :authentication, user: user, status: true
      Authentication.invalidate_token(user, true)
      auth.reload

      expect(auth.status).to eq false
    end
  end

  describe ".search_valid_token" do
    it "is expected to check the database for a valid token" do
      create :authentication, user: user, status: true
      auth = Authentication.search_valid_token(user)

      expect(auth).to_not be nil
      expect(auth.status).to eq true
    end
  end
end
