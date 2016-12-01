require "rails_helper"

RSpec.describe "Authentications", type: :request do
  set_up

  describe "POST /auth/login" do
    context "with valid params" do
      let(:login_request) do
        post "/api/v1/auth/login",
             params: { email: user.email, password: user.password }
      end

      it "creates a token for the user" do
        login_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:auth_token]).to_not be nil
        expect(endpoint_response[:message]).to_not be nil
      end

      it "returns http success" do
        login_request
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_login_request) do
        post "/api/v1/auth/login",
             params: { email: "", password: "password" }
      end

      it "notify's the user of invalid credentials" do
        invalid_login_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:error]).to include "Invalid"
      end

      it "returns http unathorized" do
        invalid_login_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /auth/logout" do
    context "with valid token" do
      let(:logout_request) do
        get "/api/v1/auth/logout",
            headers: set_request_authentication_header
      end

      it "terminates the user's session" do
        logout_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:message]).to eq "Logout successful."
      end

      it "returns http success" do
        logout_request
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid token" do
      let(:invalid_logout_request) do
        get "/api/v1/auth/logout",
            headers: { Authorization: "Bearer token" }
      end

      it "fails to terminate the user's session" do
        invalid_logout_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:error]).to eq "Invalid request."
      end

      it "returns http unathorized" do
        invalid_logout_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
