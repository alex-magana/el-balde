require "rails_helper"

RSpec.describe ItemSerializer, type: :serializer do
  set_up

  let(:list) { create :list, user: user }

  describe "attributes" do
    it "should have the correct attributes" do
      item = create :item, list: list
      serialized = serialize(item)

      expect(serialized.key?(:id)).to be true
      expect(serialized.key?(:name)).to be true
      expect(serialized.key?(:date_created)).to be true
      expect(serialized.key?(:date_modified)).to be true
      expect(serialized.key?(:date_modified)).to be true
    end
  end
end
