require "rails_helper"

RSpec.describe Api::V1::AuthenticationsController, type: :controller do
  include Concerns::Messages

  set_up

  describe "#login" do
    context "with valid params" do
      let(:login_request) do
        request_params = { email: user.email, password: user.password }
        post :login,
             params: request_params
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
        request_params = { email: "", password: user.password }
        post :login,
             params: request_params
      end

      before(:each) do
        invalid_login_request
      end

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with an existing valid token" do
      let(:login_request) do
        request_params = { email: user.email, password: user.password }
        post :login,
             params: request_params
      end

      before(:each) do
        login_request
      end

      it "returns http success" do
        endpoint_response = json_response(response.body)

        expect(endpoint_response.key?(:auth_token)).to be true
        expect(endpoint_response.key?(:message)).to be true
        expect(endpoint_response[:message]).to eq already_logged_in
      end
    end

    context "without an existing token" do
      let(:login_request) do
        request_params = { email: user.email, password: user.password }
        post :login,
             params: request_params
      end

      before(:each) do
        Authentication.destroy_all
        login_request
      end

      it "returns http success" do
        endpoint_response = json_response(response.body)

        expect(endpoint_response.key?(:auth_token)).to be true
        expect(endpoint_response.key?(:message)).to be true
        expect(endpoint_response[:message]).to eq login_successful
      end
    end
  end

  describe "#logout" do
    context "with valid token" do
      before(:each) do
        set_authentication_header(authentication_token)
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
        expect(json_response(response.body)[:error]).to eq unauthorized_request
      end

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with an expired token" do
      before(:each) do
        set_invalid_token(-2)
        get :logout
      end

      it "notify the user of an invalid request" do
        expect(json_response(response.body).key?(:error)).to be true
        expect(json_response(response.body)[:error]).to eq unauthorized_request
      end

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with a token with invalid registered claims" do
      before(:each) do
        set_invalid_token(7)
        get :logout
      end

      it "notify the user of an invalid request" do
        expect(json_response(response.body).key?(:error)).to be true
        expect(json_response(response.body)[:error]).to eq unauthorized_request
      end

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
