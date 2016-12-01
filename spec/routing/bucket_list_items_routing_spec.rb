require "rails_helper"

RSpec.describe Api::V1::BucketListItemsController, type: :routing do
  it do
    expect(get: "/api/v1/bucketlists/1/items").to route_to(
      "api/v1/bucket_list_items#index",
      bucket_list_id: "1", format: :json
    )
  end
  it do
    expect(post: "/api/v1/bucketlists/1/items").to route_to(
      "api/v1/bucket_list_items#create",
      bucket_list_id: "1", format: :json
    )
  end
  it do
    expect(get: "/api/v1/bucketlists/1/items/1").to route_to(
      "api/v1/bucket_list_items#show",
      bucket_list_id: "1", id: "1", format: :json
    )
  end
  it do
    expect(patch: "/api/v1/bucketlists/1/items/1").to route_to(
      "api/v1/bucket_list_items#update",
      bucket_list_id: "1", id: "1", format: :json
    )
  end
  it do
    expect(put: "/api/v1/bucketlists/1/items/1").to route_to(
      "api/v1/bucket_list_items#update",
      bucket_list_id: "1", id: "1", format: :json
    )
  end
  it do
    expect(delete: "/api/v1/bucketlists/1/items/1").to route_to(
      "api/v1/bucket_list_items#destroy",
      bucket_list_id: "1", id: "1", format: :json
    )
  end
end
