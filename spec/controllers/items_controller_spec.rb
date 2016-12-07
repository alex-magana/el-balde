require "rails_helper"

RSpec.describe Api::V1::ItemsController, type: :controller do
  set_up

  before do
    set_authentication_header(authentication_token)
  end

  let!(:list) { create :list, user: user }

  describe "#index" do
    context "with valid params" do
      parameter_page = 2
      parameter_limit = 5

      before do
        create_list(:item, 50, list_id: list.id)
        request_params = {
          list_id: list.id,
          page: parameter_page,
          limit: parameter_limit
        }

        get :index,
            params: request_params
      end

      it "returns bucket list items equivalent to the set limit" do
        expect(json_response(response.body).count).to eq parameter_limit
      end

      it "returns a status code denoting success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      parameter_page = "$#%!1}"
      parameter_limit = "$#%!1}"

      before do
        create_list(:item, 40, list_id: list.id)
        request_params = {
          list_id: list.id,
          page: parameter_page,
          limit: parameter_limit
        }

        get :index,
            params: request_params
      end

      it "returns results equal to the default limit of 20" do
        expect(json_response(response.body).count).to eq 20
      end

      it "returns a status code denoting success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid bucket list id" do
      parameter_page = "$#%!1}"
      parameter_limit = "$#%!1}"

      before do
        request_params = {
          list_id: list.id * 0,
          page: parameter_page,
          limit: parameter_limit
        }

        get :index,
            params: request_params
      end

      it "returns an error message denoting absence of record" do
        expect(json_response(response.body).key?(:error)).to be true
        expect(json_response(response.body)[:error]).to eq "Record not found."
      end

      it "returns a status code denoting not_found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#show" do
    context "with valid params" do
      before(:each) do
        create_list(:item, 20, list_id: list.id)
        item = Item.find(10)
        request_params = { list_id: list.id, id: item.id }

        get :show, params: request_params
      end

      it "returns a response with a record of an existing bucket list item" do
        item = Item.find(10)

        expect(json_response(response.body)[:name]).to eq(item.name)
      end

      it "returns a status code denoting success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      before(:each) do
        request_params = { list_id: 0, id: "$%^^%2" }

        get :show, params: request_params
      end

      it "returns a message denoting record is absent" do
        expect(json_response(response.body).key?(:error)).to be true
        expect(json_response(response.body)[:error]).to eq "Record not found."
      end

      it "returns a status code denoting not_found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#create" do
    context "with valid params" do
      let(:create_item_request) do
        request_params = attributes_for(:item, list_id: list.id)

        post :create,
             params: request_params
      end

      it "creates a new bucket_list" do
        expect { create_item_request }.to change(Item, :count).by(1)
      end

      it "sets @user to the newly created user" do
        create_item_request

        expect(assigns(:item)).to be_a(Item)
        expect(assigns(:item)).to be_persisted
      end

      it "returns http success" do
        create_item_request

        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_create_item_request) do
        request_params = attributes_for(
          :item,
          name: nil,
          list_id: list.id
        )

        post :create,
             params: request_params
      end

      it "does not create a new item" do
        expect { invalid_create_item_request }.to_not change(Item, :count)
      end

      it "sets @item to a newly "\
        "created but unsaved item" do
        invalid_create_item_request

        expect(assigns(:item)).to be_a_new(Item)
      end

      it "returns unprocessable_entity status" do
        invalid_create_item_request

        expect(response.status).to eq 422
      end
    end
  end

  describe "#update" do
    subject(:item) do
      create :item, list_id: list.id
    end

    context "with valid params" do
      let(:new_attributes) do
        { name: "Three Peaks Challenge", done: true }
      end

      before(:each) do
        put :update,
            params: new_attributes.merge(
              list_id: list.id,
              id: item.id
            )
        item.reload
      end

      it "updates the name of the requested item" do
        expect(item.name).to eq new_attributes[:name]
      end

      it "updates the status of the requested bucket_list" do
        expect(item.done).to eq new_attributes[:done]
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
        put :update,
            params: invalid_new_attributes.merge(
              list_id: list.id,
              id: item.id
            )
        list.reload
      end

      it "sets @item to item" do
        expect(assigns(:item)).to eq(item)
      end

      it "does not update the name of the requested item" do
        expect(item.name).to_not eq invalid_new_attributes[:name]
      end

      it "returns unprocessable_entity status" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "#destroy" do
    subject(:item) do
      create :item, list_id: list.id
    end

    let(:delete_item_request) do
      delete :destroy,
             params: { list_id: list.id, id: item.id }
    end

    before(:each) do
      delete_item_request
    end

    it "destroys a bucket_list" do
      expect(Item.where(id: item.id)).not_to exist
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
