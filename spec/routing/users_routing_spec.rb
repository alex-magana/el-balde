require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :routing do
  it do
    expect(post: "api/v1/users").to route_to(
      "api/v1/users#create", format: :json
    )
  end
  it do
    expect(get: "/api/v1/users/1").to route_to(
      "api/v1/users#show", id: "1", format: :json
    )
  end
  it do
    expect(patch: "/api/v1/users/1").to route_to(
      "api/v1/users#update", id: "1", format: :json
    )
  end
  it do
    expect(put: "/api/v1/users/1").to route_to(
      "api/v1/users#update", id: "1", format: :json
    )
  end
  it do
    expect(delete: "/api/v1/users/1").to route_to(
      "api/v1/users#destroy", id: "1", format: :json
    )
  end
end
