require "rails_helper"

RSpec.describe BucketListItem, type: :model do
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:done).of_type(:boolean) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to(:bucket_list) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.not_to allow_value("1234").for(:name) }
  it do
    is_expected.to validate_length_of(:name).is_at_least(3).
      with_message("Too short. The minimum length is 3 characters.")
  end

  describe ".paginate" do
    let(:role) { create :role }
    let(:user) { create :user, role: role }
    let(:bucket_list) { create :bucket_list, user: user }
    before do
      create_list(:bucket_list_item, 50, bucket_list: bucket_list)
    end

    it "returns the required number of records" do
      parameter_page = 2
      parameter_limit = 5
      bucket_lists = BucketListItem.paginate(parameter_page, parameter_limit)
      bucket_lists_active_record = BucketListItem.limit(parameter_limit).
        offset(parameter_page * parameter_limit).order("id ASC")

      expect(bucket_lists.count).to eq parameter_limit
      expect(bucket_lists[0]).to eq bucket_lists_active_record[0]
    end
  end
end
