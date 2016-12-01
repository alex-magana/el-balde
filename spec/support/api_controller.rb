RSpec.shared_examples "api_controller" do
  describe "rescues from ActiveRecord::RecordNotFound" do
    context "on #show" do
      before { get :show, params: { id: "not-existing" } }

      it { expect(response.status).to eq(404) }
      it do
        expect(
          json_response(response.body)[:error]
        ).to include "Record not found."
      end
    end

    context "on #update" do
      before { put :update, params: { id: "not-existing" } }

      it { expect(response.status).to eq(404) }
      it do
        expect(
          json_response(response.body)[:error]
        ).to include "Record not found."
      end
    end

    context "on #destroy" do
      before { delete :destroy, params: { id: "not-existing" } }

      it { expect(response.status).to eq(404) }
      it do
        expect(
          json_response(response.body)[:error]
        ).to include "Record not found."
      end
    end
  end

  describe "rescues from ActiveRecord::parameterMissing" do
    context "on #create" do
      before do
        post :create, params: { wrong_params: { foo: :bar } }
      end

      it { expect(response.status).to eq(422) }
      it { expect(response.body).to match(/error/) }
    end
  end
end
