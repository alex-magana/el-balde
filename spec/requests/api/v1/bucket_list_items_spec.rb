require "rails_helper"

RSpec.describe "BucketListItems", type: :request do
  set_up

  let!(:bucket_list) { create :bucket_list, user: user }

  subject!(:bucket_list_item) do
    create :bucket_list_item,
           bucket_list_id: bucket_list.id
  end

  describe "GET /bucketlists/:bucket_list_id/items" do
    before(:each) do
      parameter_page = 1
      parameter_limit = 1
      get "/api/v1/bucketlists/#{bucket_list.id}/items",
          params: { page: parameter_page, limit: parameter_limit },
          headers: { Authorization: "Bearer #{authentication_token}" }
    end

    it "returns a list of created bucket list items" do
      endpoint_response = json_response(response.body)

      expect(endpoint_response[0][:name]).to eq json_response(
        bucket_list.bucket_list_items.to_json
      )[0][:name]
    end

    it "returns a status code denoting success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /bucketlists/:bucket_list_id/items/:id" do
    before(:each) do
      get "/api/v1/bucketlists/#{bucket_list.id}/items/#{bucket_list_item.id}",
        headers: { Authorization: "Bearer #{authentication_token}" }
    end

    it "returns an existing bucket list item" do
      endpoint_response = json_response(response.body)

      expect(endpoint_response[:name]).to eq json_response(
        bucket_list_item.to_json
        )[:name]
    end

    it "returns a status code denoting success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /bucketlists/:bucket_list_id/items" do
    context "with valid params" do
      let(:create_bucket_list_item_request) do
        post "/api/v1/bucketlists/#{bucket_list.id}/items",
             params: {
               bucket_list_item: attributes_for(
                 :bucket_list_item,
                 bucket_list_id: bucket_list.id
               )
             },
             headers: { Authorization: "Bearer #{authentication_token}" }
      end

      it "creates a new bucket_list" do
        create_bucket_list_item_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:name]).to eq json_response(
          bucket_list_item.to_json
        )[:name]
      end

      it "returns http success" do
        create_bucket_list_item_request
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_create_bucket_list_item_request) do
        post "/api/v1/bucketlists/#{bucket_list.id}/items",
             params: {
               bucket_list_item: attributes_for(
                 :bucket_list_item,
                 name: nil,
                 bucket_list_id: bucket_list.id
               )
             },
             headers: { Authorization: "Bearer #{authentication_token}" }
      end

      it "does not create a new bucket_list_item" do
        expect { invalid_create_bucket_list_item_request }.to_not change(
          BucketListItem, :count
        )
      end

      it "sets @bucket_list_item to a newly "\
        "created but unsaved bucket_list_item" do
        invalid_create_bucket_list_item_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:name][0]).to include("can't be blank")
      end

      it "returns unprocessable_entity status" do
        invalid_create_bucket_list_item_request
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT /bucketlists/:bucket_list_id/items/:id" do
    context "with valid params" do
      let(:new_attributes) do
        { name: "Three Peaks Challenge", done: true }
      end

      before(:each) do
        put "/api/v1/bucketlists/#{bucket_list.id}/items/#{bucket_list_item.id}",
            params: {
              bucket_list_item: new_attributes
            },
            headers: { Authorization: "Bearer #{authentication_token}" }
        bucket_list_item.reload
      end

      it "updates the name of the requested bucket_list_item" do
        endpoint_response = json_response(response.body)

        expect(bucket_list_item.name).to eq new_attributes[:name]
        expect(bucket_list_item.name).to eq endpoint_response[:name]
      end

      it "updates the status of the requested bucket_list" do
        endpoint_response = json_response(response.body)

        expect(bucket_list_item.done).to eq new_attributes[:done]
        expect(bucket_list_item.done).to eq endpoint_response[:done]
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_new_attributes) do
        { name: nil, done: true }
      end

      before(:each) do
        put "/api/v1/bucketlists/#{bucket_list.id}/items/#{bucket_list_item.id}",
            params: {
              bucket_list: invalid_new_attributes
            },
            headers: { Authorization: "Bearer #{authentication_token}" }
        bucket_list_item.reload
      end

      it "sets @bucket_list _item to bucket_list_item" do
        endpoint_response = json_response(response.body)
        expect(assigns(:bucket_list_item)).to eq(bucket_list_item)
        expect(endpoint_response[:error]).to include("param is missing or the value")
      end

      it "does not update the name of the requested bucket_list_item" do
        expect(bucket_list_item.name).to_not eq invalid_new_attributes[:name]
      end

      it "returns unprocessable_entity status" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /bucketlists/:bucket_list_id/items/:id" do
    let(:delete_bucket_list_item_request) do
      delete "/api/v1/bucketlists/#{bucket_list.id}/items/#{bucket_list_item.id}",
             headers: { Authorization: "Bearer #{authentication_token}" }
    end

    before(:each) do
      delete_bucket_list_item_request
    end

    it "destroys a bucket_list" do
      expect(BucketListItem.where(id: bucket_list_item.id)).not_to exist
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
