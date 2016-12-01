require "rails_helper"

RSpec.describe Api::V1::AuthenticationsController, type: :controller do
  set_up

  before do
    set_authentication_header(authentication_token)
  end

  describe "#login", skip_before: true do
    context "with valid params" do
      let(:login_request) do
        post :login,
             params: {
               email: user.email,
               password: user.password
             }
      end

      before(:each) do
        login_request
      end

      it "returns http success" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:invalid_login_request) do
        post :login,
             params: {
               email: "",
               password: user.password
             }
      end

      before(:each) do
        invalid_login_request
      end

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "#logout" do
    context "with valid token" do
      before(:each) do
        get :logout
      end

      it "invalidates the user token" do
        authentication_token = Authentication.find(1)

        expect(authentication_token.status).to eq false
      end

      it "returns http success" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid token" do
      before(:each) do
        set_authentication_header("authentication_token")
        get :logout
      end

      it "notify the user of an invalid request" do
        expect(json_response(response.body).key?(:error)).to be true
        expect(json_response(response.body)[:error]).to eq "Invalid request."
      end

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
