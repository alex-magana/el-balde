require "rails_helper"

RSpec.describe UserSerializer, type: :serializer do
  set_up

  describe "attributes" do
    it "should have the correct attributes" do
      serialized = serialize(user)

      expect(serialized.key?(:name)).to be true
      expect(serialized.key?(:email)).to be true
      expect(serialized.key?(:date_modified)).to be true
      expect(serialized.key?(:date_modified)).to be true
    end
  end
end
