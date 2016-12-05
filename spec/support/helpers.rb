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

  def set_invalid_token(expiry)
    Authentication.destroy_all
    payload = { user_id: user.id }
    meta = {
      exp: expiry.days.from_now.to_i,
      iss: "iss",
      aud: "aud",
    }
    payload.reverse_merge!(meta)
    token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
    set_authentication_header(token)
  end

  def json_response(response)
    JSON.parse(response, symbolize_names: true)
  end

  def serialize(object, adapter_options = {})
    serializer_class = adapter_options.delete(:serializer_class) ||
      "#{object.class.name}Serializer".constantize
    serializer = serializer_class.send(:new, object)
    adapter = ActiveModelSerializers::Adapter.create(
      serializer, adapter_options
    )
    json_response(adapter.to_json)
  end
end
