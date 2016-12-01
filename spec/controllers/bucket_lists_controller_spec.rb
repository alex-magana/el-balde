require "rails_helper"

RSpec.describe Api::V1::BucketListsController, type: :controller do
  set_up

  before do
    set_authentication_header(authentication_token)
  end

  subject(:bucket_list_unit) { create :bucket_list, user_id: user.id }

  it_behaves_like "api_controller"

  describe "#index" do
    context "with page and limit parameters" do
      parameter_page = 2
      parameter_limit = 5

      before(:each) do
        create_list(:bucket_list, 50, user: user)
        get :index, params: { page: parameter_page, limit: parameter_limit }
      end

      it "returns bucket lists equivalent to the set limit" do
        expect(assigns(:bucket_lists).count).to eq parameter_limit
      end

      it "returns a status code denoting success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with parameter q" do
      let(:parameter_q) { bucket_list_unit.name }
      before(:each) do
        get :index, params: { q: parameter_q }
      end

      it "sets @bucket_lists to a list of all created bucket lists" do
        expect(assigns(:bucket_lists)[0].name).to include(parameter_q)
      end
    end
  end

  describe "#show" do
    context "with valid params" do
      before(:each) do
        get :show, params: { id: bucket_list_unit.id }
      end

      it "sets @bucket_list to a record of an existing bucket list" do
        expect(assigns(:bucket_list)).to eq(bucket_list_unit)
      end

      it "returns a status code denoting success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      before(:each) do
        get :show, params: { id: bucket_list_unit.id * 0 }
      end

      it "sets @bucket_list to nil" do
        expect(assigns(:bucket_list)).to be nil
      end

      it "returns a status code denoting not_found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#create" do
    context "with valid params" do
      let(:create_bucket_list_request) do
        post :create,
             params: {
               bucket_list: attributes_for(
                 :bucket_list,
                 user_id: user.id
               )
             }
      end

      it "creates a new bucket_list" do
        expect { create_bucket_list_request }.to change(
          BucketList, :count
        ).by(1)
      end

      it "sets @bucketlist to an instance of BucketList" do
        create_bucket_list_request
        expect(assigns(:bucket_list)).to be_a(BucketList)
        expect(assigns(:bucket_list)).to be_persisted
      end

      it "returns http success" do
        create_bucket_list_request
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_create_bucket_list_request) do
        post :create,
             params: {
               bucket_list: attributes_for(
                 :bucket_list,
                 name: nil
               )
             }
      end

      it "does not create a new bucket_list" do
        expect { invalid_create_bucket_list_request }.to_not change(
          BucketList, :count
        )
      end

      it "sets @bucket_list to a newly created but unsaved bucket_list" do
        invalid_create_bucket_list_request
        expect(assigns(:bucket_list)).to be_a_new(BucketList)
      end

      it "returns unprocessable_entity status" do
        invalid_create_bucket_list_request
        expect(response.status).to eq(422)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:new_attributes) do
        { name: Faker::Name.title }
      end

      before(:each) do
        put :update,
            params: {
              id: bucket_list_unit.id,
              bucket_list: new_attributes
            }
        bucket_list_unit.reload
      end

      it "updates the name of the requested bucket_list" do
        expect(bucket_list_unit.name).to eq new_attributes[:name]
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_new_attributes) do
        { name: nil }
      end

      before(:each) do
        put :update,
            params: {
              id: bucket_list_unit.id,
              bucket_list: invalid_new_attributes
            }
        bucket_list_unit.reload
      end

      it "sets @bucket_list to bucket_list" do
        expect(assigns(:bucket_list)).to eq(bucket_list_unit)
      end

      it "does not update the name of the requested bucket_list" do
        expect(bucket_list_unit.name).to_not eq invalid_new_attributes[:name]
      end

      it "returns unprocessable_entity status" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "#destroy" do
    let(:delete_bucket_list_request) do
      delete :destroy, params: { id: bucket_list_unit.id }
    end

    before(:each) do
      delete_bucket_list_request
    end

    it "destroys a bucket_list" do
      expect(BucketList.where(id: bucket_list_unit.id)).not_to exist
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
