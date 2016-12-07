require "rails_helper"

RSpec.describe Api::V1::ListsController, type: :routing do
  it do
    expect(get: "/api/v1/bucketlists").to route_to(
      "api/v1/lists#index", format: :json
    )
  end
  it do
    expect(post: "/api/v1/bucketlists").to route_to(
      "api/v1/lists#create", format: :json
    )
  end
  it do
    expect(get: "/api/v1/bucketlists/1").to route_to(
      "api/v1/lists#show", id: "1", format: :json
    )
  end
  it do
    expect(patch: "/api/v1/bucketlists/1").to route_to(
      "api/v1/lists#update", id: "1", format: :json
    )
  end
  it do
    expect(put: "/api/v1/bucketlists/1").to route_to(
      "api/v1/lists#update", id: "1", format: :json
    )
  end
  it do
    expect(delete: "/api/v1/bucketlists/1").to route_to(
      "api/v1/lists#destroy", id: "1", format: :json
    )
  end
end
