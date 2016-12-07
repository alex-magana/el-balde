require "rails_helper"

RSpec.describe Api::V1::ItemsController, type: :routing do
  it do
    expect(get: "/api/v1/bucketlists/1/items").to route_to(
      "api/v1/items#index",
      list_id: "1", format: :json
    )
  end
  it do
    expect(post: "/api/v1/bucketlists/1/items").to route_to(
      "api/v1/items#create",
      list_id: "1", format: :json
    )
  end
  it do
    expect(get: "/api/v1/bucketlists/1/items/1").to route_to(
      "api/v1/items#show",
      list_id: "1", id: "1", format: :json
    )
  end
  it do
    expect(patch: "/api/v1/bucketlists/1/items/1").to route_to(
      "api/v1/items#update",
      list_id: "1", id: "1", format: :json
    )
  end
  it do
    expect(put: "/api/v1/bucketlists/1/items/1").to route_to(
      "api/v1/items#update",
      list_id: "1", id: "1", format: :json
    )
  end
  it do
    expect(delete: "/api/v1/bucketlists/1/items/1").to route_to(
      "api/v1/items#destroy",
      list_id: "1", id: "1", format: :json
    )
  end
end
