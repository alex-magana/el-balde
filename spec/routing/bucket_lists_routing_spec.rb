require "rails_helper"

RSpec.describe Api::V1::BucketListsController, type: :routing do
  it do
    expect(get: "/api/v1/bucketlists").to route_to("api/v1/bucket_lists#index")
  end
  it do
    expect(post: "/api/v1/bucketlists").to route_to(
      "api/v1/bucket_lists#create"
    )
  end
  it do
    expect(get: "/api/v1/bucketlists/1").to route_to(
      "api/v1/bucket_lists#show", id: "1"
    )
  end
  it do
    expect(patch: "/api/v1/bucketlists/1").to route_to(
      "api/v1/bucket_lists#update", id: "1"
    )
  end
  it do
    expect(put: "/api/v1/bucketlists/1").to route_to(
      "api/v1/bucket_lists#update", id: "1"
    )
  end
  it do
    expect(delete: "/api/v1/bucketlists/1").to route_to(
      "api/v1/bucket_lists#destroy", id: "1"
    )
  end
end
