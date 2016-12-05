require "rails_helper"

RSpec.describe "Lists", type: :request do
  set_up

  subject!(:list) { create :list, user: user }

  describe "GET /api/v1/bucketlists" do
    before(:each) do
      parameter_page = 1
      parameter_limit = 1
      get "/api/v1/bucketlists",
          params: { page: parameter_page, limit: parameter_limit },
          headers: set_request_authentication_header
    end

    it "returns a list of created bucket lists" do
      endpoint_response = json_response(response.body)

      expect(endpoint_response[0][:name]).to eq json_response(
        list.to_json
      )[:name]
    end

    it "returns a status code denoting success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /api/v1/bucketlists/:id" do
    before(:each) do
      get "/api/v1/bucketlists/#{list.id}",
          headers: set_request_authentication_header
    end

    it "returns an existing bucket list" do
      endpoint_response = json_response(response.body)

      expect(endpoint_response[:name]).to eq json_response(
        list.to_json
      )[:name]
    end

    it "returns a status code denoting success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/v1/bucketlists" do
    context "with valid params" do
      let(:create_list_request) do
        post "/api/v1/bucketlists",
             params: {
               list: attributes_for(:list)
             },
             headers: set_request_authentication_header
      end

      it "creates a new bucket_list" do
        create_list_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:name]).to eq request.params[:list][:name]
      end

      it "returns http success" do
        create_list_request
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid valid params" do
      let(:invalid_create_list_request) do
        post "/api/v1/bucketlists",
             params: {
               list: attributes_for(:list, name: "1234")
             },
             headers: set_request_authentication_header
      end

      it "returns errors indicating invalid params" do
        invalid_create_list_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:name]).to include "is invalid"
      end

      it "returns http unprocessable_entity" do
        invalid_create_list_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/bucketlists/:id" do
    context "with valid params" do
      let(:new_attributes) do
        { name: Faker::Name.title }
      end

      before(:each) do
        put "/api/v1/bucketlists/#{list.id}",
            params: {
              list: new_attributes
            },
            headers: set_request_authentication_header
      end

      it "updates the name of the requested bucket list" do
        endpoint_response = json_response(response.body)

        expect(endpoint_response[:name]).to eq new_attributes[:name]
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:new_attributes) do
        { name: Faker::Number.number(10) }
      end

      before(:each) do
        put "/api/v1/bucketlists/#{list.id}",
            params: {
              list: new_attributes
            },
            headers: set_request_authentication_header
      end

      it "updates the name of the requested bucket list" do
        endpoint_response = json_response(response.body)

        expect(endpoint_response[:name]).to include "is invalid"
        expect(list.name).to_not eq new_attributes[:name]
      end

      it "returns http unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/bucketlists/:id" do
    let(:delete_list_request) do
      delete "/api/v1/bucketlists/#{list.id}",
             headers: set_request_authentication_header
    end

    before(:each) do
      delete_list_request
    end

    it "destroys a bucket_list" do
      expect(List.where(id: list.id)).not_to exist
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end