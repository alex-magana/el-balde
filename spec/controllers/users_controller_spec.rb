require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  set_up

  before do
    set_authentication_header(authentication_token)
  end

  it_behaves_like "api_controller"

  describe "#show" do
    context "with valid id" do
      before(:each) do
        get :show, params: { id: user.id }
      end

      it "sets @user to a record of an existing user" do
        expect(assigns(:user)).to eq(user)
      end

      it "returns a status code denoting success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid id" do
      before(:each) do
        get :show, params: { id: "id" }
      end

      it "returns a status code denoting not_found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#create", skip_before: true do
    context "with valid params" do
      let(:create_user_request) do
        post :create,
             params: attributes_for(
               :user,
               password_confirmation: "anewpassword"
             )
      end

      it "creates a new user" do
        expect { create_user_request }.to change(User, :count).by(1)
      end

      it "sets @user to the newly created user" do
        create_user_request
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "returns http success" do
        create_user_request
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_create_user_request) do
        post :create,
             params: {
               user: attributes_for(
                 :user,
                 first_name: nil,
                 last_name: nil,
                 email: "abc.com",
                 password_confirmation: "anewpassword"
               )
             }
      end

      it "does not create a new user" do
        expect { invalid_create_user_request }.to_not change(User, :count)
      end

      it "sets @customer to a newly created but unsaved user" do
        invalid_create_user_request
        expect(assigns(:user)).to be_a_new(User)
      end

      it "returns unprocessable_entity status" do
        invalid_create_user_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:new_attributes) do
        {
          id: user.id,
          first_name: Faker::Name.first_name,
          email: Faker::Internet.email,
          password: user.password
        }
      end

      before(:each) do
        put :update,
            params: new_attributes
        user.reload
      end

      it "updates the first_name of the requested user" do
        expect(user.first_name).to eq new_attributes[:first_name]
      end

      it "updates the email of the requested user" do
        expect(user.email).to eq new_attributes[:email]
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_new_attributes) do
        { first_name: "", email: "troy.davids.com" }
      end

      before(:each) do
        put :update,
            params: { id: user.id, user: invalid_new_attributes }
        user.reload
      end

      it "sets @user to user" do
        expect(assigns(:user)).to eq(user)
      end

      it "does not update the first_name of the requested user" do
        expect(user.first_name).to_not eq invalid_new_attributes[:first_name]
      end

      it "does not updates the email of the requested user" do
        expect(user.email).to_not eq invalid_new_attributes[:email]
      end

      it "returns unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "#destroy" do
    let(:delete_user_request) do
      delete :destroy, params: { id: user.id }
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
