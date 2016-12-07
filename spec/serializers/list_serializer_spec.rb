require "rails_helper"

RSpec.describe ListSerializer, type: :serializer do
  set_up

  let(:list) { create :list, user: user }

  describe "attributes" do
    it "should have the correct attributes" do
      serialized = serialize(list)

      expect(serialized.key?(:id)).to be true
      expect(serialized.key?(:name)).to be true
      expect(serialized.key?(:items)).to be true
      expect(serialized.key?(:date_modified)).to be true
      expect(serialized.key?(:date_modified)).to be true
      expect(serialized.key?(:created_by)).to be true
    end
  end
end
