require "rails_helper"

RSpec.describe Api::V1::AuthenticationsController, type: :routing do
  it do
    expect(post: "/api/v1/auth/login").to route_to(
      "api/v1/authentications#login"
    )
  end
  it do
    expect(get: "/api/v1/auth/logout").to route_to(
      "api/v1/authentications#logout"
    )
  end
end
