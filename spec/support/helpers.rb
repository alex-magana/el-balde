module Helpers
  def set_up
    let!(:role) { create :role }
    let!(:user) { create :user, role: role }
    let(:authentication_token) { JsonWebToken.encode(user_id: user.id) }
    let!(:authentication) do
      create :authentication,
             token: authentication_token,
             status: true,
             user: user
    end
  end

  def set_authentication_header(authentication_token)
    request.headers["Authorization"] = "Bearer #{authentication_token}"
  end

  def set_request_authentication_header
    { Authorization: "Bearer #{authentication_token}" }
  end

  def json_response(response)
    JSON.parse(response, symbolize_names: true)
  end
end
