require "rails_helper"

RSpec.describe Api::V1::BucketListItemsController, type: :controller do
  set_up

  before do
    set_authentication_header(authentication_token)
  end

  let!(:bucket_list) { create :bucket_list, user: user }

  describe "#index" do
    context "with valid params" do
      parameter_page = 2
      parameter_limit = 5

      before do
        create_list(:bucket_list_item, 50, bucket_list_id: bucket_list.id)

        get :index,
            params: {
              bucket_list_id: bucket_list.id,
              page: parameter_page,
              limit: parameter_limit
            }
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
        create_list(:bucket_list_item, 40, bucket_list_id: bucket_list.id)

        get :index,
            params: {
              bucket_list_id: bucket_list.id,
              page: parameter_page,
              limit: parameter_limit
            }
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
        get :index,
            params: {
              bucket_list_id: bucket_list.id * 0,
              page: parameter_page,
              limit: parameter_limit
            }
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
        create_list(:bucket_list_item, 20, bucket_list_id: bucket_list.id)
        bucket_list_item = BucketListItem.find(10)
        get :show, params: {
          bucket_list_id: bucket_list.id,
          id: bucket_list_item.id
        }
      end

      it "returns a response with a record of an existing bucket list item" do
        bucket_list_item = BucketListItem.find(10)

        expect(json_response(response.body)[:name]).to eq(bucket_list_item.name)
      end

      it "returns a status code denoting success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      before(:each) do
        get :show, params: {
          bucket_list_id: 0,
          id: "$%^^%2"
        }
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
      let(:create_bucket_list_item_request) do
        post :create,
             params: {
               bucket_list_id: bucket_list.id,
               bucket_list_item: attributes_for(
                 :bucket_list_item,
                 bucket_list_id: bucket_list.id
               )
             }
      end

      it "creates a new bucket_list" do
        expect { create_bucket_list_item_request }.to change(
          BucketListItem, :count
        ).by(1)
      end

      it "sets @user to the newly created user" do
        create_bucket_list_item_request
        expect(assigns(:bucket_list_item)).to be_a(BucketListItem)
        expect(assigns(:bucket_list_item)).to be_persisted
      end

      it "returns http success" do
        create_bucket_list_item_request
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_create_bucket_list_item_request) do
        post :create,
             params: {
               bucket_list_id: bucket_list.id,
               bucket_list_item: attributes_for(
                 :bucket_list_item,
                 name: nil,
                 bucket_list_id: bucket_list.id
               )
             }
      end

      it "does not create a new bucket_list_item" do
        expect { invalid_create_bucket_list_item_request }.to_not change(
          BucketListItem, :count
        )
      end

      it "sets @bucket_list_item to a newly "\
        "created but unsaved bucket_list_item" do
        invalid_create_bucket_list_item_request
        expect(assigns(:bucket_list_item)).to be_a_new(BucketListItem)
      end

      it "returns unprocessable_entity status" do
        invalid_create_bucket_list_item_request
        expect(response.status).to eq(422)
      end
    end
  end

  describe "#update" do
    subject(:bucket_list_item) do
      create :bucket_list_item, bucket_list_id: bucket_list.id
    end

    context "with valid params" do
      let(:new_attributes) do
        { name: "Three Peaks Challenge", done: true }
      end

      before(:each) do
        put :update,
            params: {
              bucket_list_id: bucket_list.id,
              id: bucket_list_item.id,
              bucket_list_item: new_attributes
            }
        bucket_list_item.reload
      end

      it "updates the name of the requested bucket_list_item" do
        expect(bucket_list_item.name).to eq new_attributes[:name]
      end

      it "updates the status of the requested bucket_list" do
        expect(bucket_list_item.done).to eq new_attributes[:done]
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
            params: {
              bucket_list_id: bucket_list.id,
              id: bucket_list_item.id,
              bucket_list: invalid_new_attributes
            }
        bucket_list.reload
      end

      it "sets @bucket_list _item to bucket_list_item" do
        expect(assigns(:bucket_list_item)).to eq(bucket_list_item)
      end

      it "does not update the name of the requested bucket_list_item" do
        expect(bucket_list_item.name).to_not eq invalid_new_attributes[:name]
      end

      it "returns unprocessable_entity status" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "#destroy" do
    subject(:bucket_list_item) do
      create :bucket_list_item, bucket_list_id: bucket_list.id
    end

    let(:delete_bucket_list_item_request) do
      delete :destroy,
             params: { bucket_list_id: bucket_list.id, id: bucket_list_item.id }
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
