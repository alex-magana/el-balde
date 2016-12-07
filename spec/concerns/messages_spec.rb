require "rails_helper"

describe "Concerns::Messages" do
  include Concerns::Messages

  context "as instance methods" do
    it "defines a module Concerns::Paginate" do
      expect(defined?(Concerns::Messages)).to be_truthy
      expect(Concerns::Messages).to be_a(Module)
    end

    class Controller
      include Concerns::Messages
    end

    controller = Controller.new

    it "invokes record_not_found" do
      expect(controller.record_not_found).to eq record_not_found
    end

    it "invokes unauthorized_request" do
      expect(controller.unauthorized_request).to eq unauthorized_request
    end

    it "invokes login_successful" do
      expect(controller.login_successful).to eq login_successful
    end

    it "invokes already_logged_in" do
      expect(controller.already_logged_in).to eq already_logged_in
    end

    it "invokes invalid_login_credentials" do
      expect(
        controller.invalid_login_credentials
      ).to eq invalid_login_credentials
    end

    it "invokes logout_successful" do
      expect(controller.logout_successful).to eq logout_successful
    end

    it "invokes user_deletion_successful" do
      expect(controller.user_deletion_successful).to eq user_deletion_successful
    end

    it "invokes bucket_list_deletion_successful" do
      expect(
        controller.bucket_list_deletion_successful
      ).to eq bucket_list_deletion_successful
    end

    it "invokes bucket_list_item_deletion_successful" do
      expect(
        controller.bucket_list_item_deletion_successful
      ).to eq bucket_list_item_deletion_successful
    end
  end

  context "as class methods" do
    class Controller
      extend Concerns::Messages
    end

    it "invokes record_not_found" do
      expect(Controller).to respond_to(:record_not_found)
    end

    it "invokes unauthorized_request" do
      expect(Controller).to respond_to(:unauthorized_request)
    end

    it "invokes login_successful" do
      expect(Controller).to respond_to(:login_successful)
    end

    it "invokes already_logged_in" do
      expect(Controller).to respond_to(:already_logged_in)
    end

    it "invokes invalid_login_credentials" do
      expect(Controller).to respond_to(:invalid_login_credentials)
    end

    it "invokes logout_successful" do
      expect(Controller).to respond_to(:logout_successful)
    end

    it "invokes user_deletion_successful" do
      expect(Controller).to respond_to(:user_deletion_successful)
    end

    it "invokes bucket_list_deletion_successful" do
      expect(Controller).to respond_to(:bucket_list_deletion_successful)
    end

    it "invokes bucket_list_item_deletion_successful" do
      expect(Controller).to respond_to(:bucket_list_item_deletion_successful)
    end
  end
end
