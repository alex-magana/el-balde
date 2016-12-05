require "rails_helper"

RSpec.describe Item, type: :model do
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:done).of_type(:boolean) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to(:list) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.not_to allow_value("1234").for(:name) }
  it do
    is_expected.to validate_length_of(:name).is_at_least(3).
      with_message("Too short. The minimum length is 3 characters.")
  end

  describe ".catalog" do
    let(:role) { create :role }
    let(:user) { create :user, role: role }
    let(:list) { create :list, user: user }
    before do
      create_list(:item, 50, list: list)
    end

    it "returns the required number of records" do
      parameter_page = 2
      parameter_limit = 5
      lists = Item.catalog(list, parameter_page, parameter_limit)
      lists_active_record = Item.where(list_id: list.id).limit(parameter_limit).
        offset(parameter_page * parameter_limit).order("id ASC")

      expect(lists.count).to eq parameter_limit
      expect(lists[0][:name]).to eq lists_active_record[0][:name]
      expect(lists[0][:list_id]).to eq lists_active_record[0][:list_id]
    end
  end

  describe "#paginate" do
    let(:role) { create :role }
    let(:user) { create :user, role: role }
    let(:list) { create :list, user: user }
    before do
      create_list(:item, 50, list: list)
    end

    it "returns the required number of records" do
      parameter_page = 2
      parameter_limit = 5
      lists = Item.paginate(parameter_page, parameter_limit)
      lists_active_record = Item.limit(parameter_limit).
        offset(parameter_page * parameter_limit).order("id ASC")

      expect(lists.count).to eq parameter_limit
      expect(lists[0][:name]).to eq lists_active_record[0][:name]
      expect(lists[0][:list_id]).to eq lists_active_record[0][:list_id]
    end
  end
end
