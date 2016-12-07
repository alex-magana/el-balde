require "jwt"

class JsonWebToken
  def self.encode(payload)
    payload.reverse_merge!(meta)
    token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
    Authentication.new(
      token: token, status: true, user_id: payload[:user_id]
    ).save
    token
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)
  end

  def self.valid_payload(payload)
    if expired(payload) ||
        payload["iss"] != meta[:iss] || payload["aud"] != meta[:aud]
      false
    else
      true
    end
  end

  def self.meta
    {
      exp: 7.days.from_now.to_i,
      iss: "el-balde",
      aud: "client",
    }
  end

  def self.expired(payload)
    token_expired = Time.at(payload["exp"]) < Time.now
    Authentication.invalidate_token(current_user, true) if token_expired
    token_expired
  end
end
