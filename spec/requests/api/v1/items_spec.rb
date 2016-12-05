require "rails_helper"

RSpec.describe "Items", type: :request do
  set_up

  let!(:list) { create :list, user: user }

  subject!(:item) do
    create :item,
           list_id: list.id
  end

  describe "GET /bucketlists/:list_id/items" do
    before(:each) do
      parameter_page = 1
      parameter_limit = 1

      get "/api/v1/bucketlists/#{list.id}/items",
          params: { page: parameter_page, limit: parameter_limit },
          headers: set_request_authentication_header
    end

    it "returns a list of created bucket list items" do
      endpoint_response = json_response(response.body)

      expect(endpoint_response[0][:name]).to eq json_response(
        list.items.to_json
      )[0][:name]
    end

    it "returns a status code denoting success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /bucketlists/:list_id/items/:id" do
    before(:each) do
      get "/api/v1/bucketlists/#{list.id}/items/#{item.id}",
          headers: set_request_authentication_header
    end

    it "returns an existing bucket list item" do
      endpoint_response = json_response(response.body)

      expect(endpoint_response[:name]).to eq json_response(
        item.to_json
      )[:name]
    end

    it "returns a status code denoting success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /bucketlists/:list_id/items" do
    context "with valid params" do
      let(:create_item_request) do
        post "/api/v1/bucketlists/#{list.id}/items",
             params: {
               item: attributes_for(
                 :item,
                 list_id: list.id
               )
             },
             headers: set_request_authentication_header
      end

      it "creates a new list" do
        create_item_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:name]).to eq json_response(
          item.to_json
        )[:name]
      end

      it "returns http success" do
        create_item_request
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_create_item_request) do
        post "/api/v1/bucketlists/#{list.id}/items",
             params: {
               item: attributes_for(
                 :item,
                 name: nil,
                 list_id: list.id
               )
             },
             headers: set_request_authentication_header
      end

      it "does not create a new item" do
        expect { invalid_create_item_request }.to_not change(
          Item, :count
        )
      end

      it "sets @item to a newly "\
        "created but unsaved item" do
        invalid_create_item_request
        endpoint_response = json_response(response.body)
        expect(endpoint_response[:name][0]).to include("can't be blank")
      end

      it "returns unprocessable_entity status" do
        invalid_create_item_request
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT /bucketlists/:list_id/items/:id" do
    context "with valid params" do
      let(:new_attributes) do
        { name: "Three Peaks Challenge", done: true }
      end

      before(:each) do
        put "/api/v1/bucketlists/"\
              "#{list.id}/items/#{item.id}",
            params: {
              item: new_attributes
            },
            headers: set_request_authentication_header
        item.reload
      end

      it "updates the name of the requested item" do
        endpoint_response = json_response(response.body)

        expect(item.name).to eq new_attributes[:name]
        expect(item.name).to eq endpoint_response[:name]
      end

      it "updates the status of the requested list" do
        endpoint_response = json_response(response.body)

        expect(item.done).to eq new_attributes[:done]
        expect(item.done).to eq endpoint_response[:done]
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
        put "/api/v1/bucketlists/"\
              "#{list.id}/items/#{item.id}",
            params: {
              list: invalid_new_attributes
            },
            headers: set_request_authentication_header
        item.reload
      end

      it "sets @list _item to item" do
        endpoint_response = json_response(response.body)
        expect(assigns(:item)).to eq(item)
        expect(endpoint_response[:error]).to include(
          "param is missing or the value"
        )
      end

      it "does not update the name of the requested item" do
        expect(item.name).to_not eq invalid_new_attributes[:name]
      end

      it "returns unprocessable_entity status" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /bucketlists/:list_id/items/:id" do
    let(:delete_item_request) do
      delete "/api/v1/bucketlists/"\
               "#{list.id}/items/#{item.id}",
             headers: set_request_authentication_header
    end

    before(:each) do
      delete_item_request
    end

    it "destroys a list" do
      expect(Item.where(id: item.id)).not_to exist
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
