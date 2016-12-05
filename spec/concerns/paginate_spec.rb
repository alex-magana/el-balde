require "rails_helper"

describe "Concerns::Paginate" do
  set_up

  context "as instance methods" do
    it "defines a module Concerns::Paginate" do
      expect(defined?(Concerns::Paginate)).to be_truthy
      expect(Concerns::Paginate).to be_a(Module)
    end

    class ModelClass
      include Concerns::Paginate
    end

    model_class = ModelClass.new

    it "returns 0 for values less than 1" do
      expect(model_class.validate_page_number(-1)).to eq 0
    end

    it "returns 0 for nil values" do
      expect(model_class.validate_page_number(nil)).to eq 0
    end

    it "returns 0 for values equal to 1" do
      expect(model_class.validate_page_number(1)).to eq 0
    end

    it "returns n-1 for page number n which is greater than 1" do
      expect(model_class.validate_page_number(3)).to eq 2
    end

    it "returns default limit for values less than 0" do
      expect(
        model_class.validate_required_records(-1)
      ).to eq ModelClass::DEFAULT_RECORDS
    end

    it "returns default limit for values equal to 0" do
      expect(
        model_class.validate_required_records(0)
      ).to eq ModelClass::DEFAULT_RECORDS
    end

    it "returns default limit for nil values" do
      expect(
        model_class.validate_required_records(nil)
      ).to eq ModelClass::DEFAULT_RECORDS
    end

    it "returns max limit for values greater than 100" do
      expect(
        model_class.validate_required_records(200)
      ).to eq ModelClass::MAX_RECORDS
    end
  end

  context "as class methods" do
    class ModelClass
      extend Concerns::Paginate
    end

    it "invokes validate_page_number" do
      expect(ModelClass).to respond_to(:validate_page_number)
    end

    it "invokes validate_required_records" do
      expect(ModelClass).to respond_to(:validate_required_records)
    end

    it "invokes paginate" do
      expect(ModelClass).to respond_to(:paginate)
    end
  end
end
