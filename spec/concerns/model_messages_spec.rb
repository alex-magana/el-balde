require "rails_helper"

describe "Concerns::ModelMessages" do
  extend Concerns::ModelMessages

  context "as class methods" do
    it "defines a module Concerns::ModelMessages" do
      expect(defined?(Concerns::ModelMessages)).to be_truthy
      expect(Concerns::ModelMessages).to be_a(Module)
    end

    class Model
      extend Concerns::ModelMessages
    end

    it "invokes name_length" do
      expect(Model).to respond_to(:name_length)
    end

    it "invokes list_name_uniqueness" do
      expect(Model).to respond_to(:list_name_uniqueness)
    end
  end
end
