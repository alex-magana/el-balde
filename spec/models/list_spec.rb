require "rails_helper"

RSpec.describe List, type: :model do
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:items) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.not_to allow_value("1234").for(:name) }
  it do
    is_expected.to validate_length_of(:name).is_at_least(3).
      with_message("Too short. The minimum length is 3 characters.")
  end
  it do
    is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id).
      with_message("A list with a similar name already exists.")
  end

  describe ".search_by_name" do
    let(:role) { create :role }
    let(:user) { create :user, role: role }
    before do
      create_list(:list, 50, user: user)
    end

    it "returns buckets lists whose name contains the submitted text" do
      parameter_q = List.find(1).name
      lists = List.search_by_name(parameter_q)

      expect(lists.count).to_not eq 0
    end
  end

  describe ".catalog" do
    let(:role) { create :role }
    let(:user) { create :user, role: role }
    before do
      create_list(:list, 50, user: user)
    end

    it "returns the required number of records" do
      parameter_page = 2
      parameter_limit = 5
      lists = List.catalog(user, parameter_page, parameter_limit)
      lists_active_record = List.where(user_id: user.id).limit(parameter_limit).
        offset((parameter_page - 1) * parameter_limit).order("id ASC")

      expect(lists.count).to eq parameter_limit
      expect(lists[0]).to eq lists_active_record[0]
      expect(lists[0][:name]).to eq lists_active_record[0][:name]
    end
  end

  describe "#paginate" do
    let(:role) { create :role }
    let(:user) { create :user, role: role }
    before do
      create_list(:list, 50, user: user)
    end

    it "returns the required number of records" do
      parameter_page = 2
      parameter_limit = 5
      lists = List.paginate(parameter_page, parameter_limit)
      lists_active_record = List.limit(parameter_limit).
        offset((parameter_page - 1) * parameter_limit).order("id ASC")

      expect(lists.count).to eq parameter_limit
      expect(lists[0]).to eq lists_active_record[0]
    end
  end
end
