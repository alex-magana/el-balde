require "rails_helper"

RSpec.describe "Users", type: :request do
  set_up

  describe "GET /users/:id" do
    context "with valid user id" do
      let(:show_user_request) do
        get "/api/v1/users/#{user.id}",
            headers: set_request_authentication_header
      end

      before(:each) do
        show_user_request
      end

      it "returns a user" do
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:name]).to include user.first_name
        expect(endpoint_response[:email]).to include user.email
      end

      it "returns a status code denoting success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid user id" do
      let(:invalid_show_user_request) do
        get "/api/v1/users/#{0}",
            headers: set_request_authentication_header
      end

      before(:each) do
        invalid_show_user_request
      end

      it "returns an error" do
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:error]).to eq "Record not found."
      end

      it "returns a status code denoting not_found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/users" do
    context "with valid params" do
      let(:create_user_request) do
        post "/api/v1/users",
             params: attributes_for(:user),
             headers: set_request_authentication_header
      end

      before(:each) do
        create_user_request
      end

      it "creates a new user" do
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:email]).to eq request.params[:email]
      end

      it "returns a status code denoting success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_create_user_request) do
        post "/api/v1/users",
             params: attributes_for(:user, first_name: nil),
             headers: set_request_authentication_header
      end

      before(:each) do
        invalid_create_user_request
      end

      it "returns an error" do
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:error][:first_name]).to include "is invalid"
      end

      it "returns a status code denoting unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/users/:id" do
    context "with valid params" do
      let(:new_attributes) do
        {
          first_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          password: user.password
        }
      end

      before(:each) do
        put "/api/v1/users/#{user.id}",
            params: new_attributes,
            headers: set_request_authentication_header
      end

      it "updates the user first_name and email" do
        endpoint_response = json_response(response.body)

        expect(endpoint_response[:name]).to include new_attributes[:first_name]
        expect(endpoint_response[:email]).to eq new_attributes[:email]
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:new_attributes) do
        {
          first_name: nil,
          email: nil,
          password: user.password
        }
      end

      before(:each) do
        put "/api/v1/users/#{user.id}",
            params: new_attributes,
            headers: set_request_authentication_header
      end

      it "does not update the user first_name and email" do
        endpoint_response = json_response(response.body)

        expect(endpoint_response[:first_name]).to include "Too short. The "\
          "minimum length is 3 characters."
        expect(endpoint_response[:email]).to include "can't be blank"
      end

      it "returns http status unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/users/:id" do
    let(:delete_user_request) do
      delete "/api/v1/users/#{user.id}",
             headers: set_request_authentication_header
    end

    before(:each) do
      delete_user_request
    end

    it "destroys a user" do
      expect(User.where(id: user.id)).not_to exist
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
