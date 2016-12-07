RSpec.shared_context "without an "\
  "authorization token" do |method, url, params = nil|
  include Concerns::Messages

  let(:context_request) do
    send(method, url, params: params)
  end

  before do
    context_request
  end

  it "returns message denoting an unauthorized request" do
    endpoint_response = json_response(response.body)

    expect(endpoint_response[:error]).to eq unauthorized_request
  end

  it "returns status code 401" do
    expect(response.status).to eq(401)
  end
end
