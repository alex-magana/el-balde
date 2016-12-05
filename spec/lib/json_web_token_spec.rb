require "rails_helper"

describe "JsonWebToken" do
  let(:role) { create :role }
  let(:user) { create :user, role: role }

  describe ".encode" do
    it "generates a token for a user" do
      token = JsonWebToken.encode(user_id: user.id)

      expect(token).to_not be nil
    end
  end

  describe ".decode" do
    it "decodes a token for a user" do
      token = JsonWebToken.encode(user_id: user.id)
      decoded_token = JsonWebToken.decode(token)

      expect(decoded_token).to_not be nil
      expect(decoded_token[0]["user_id"]).to eq user.id
      expect(decoded_token[0]["iss"]).to eq "el-balde"
      expect(decoded_token[1]["typ"]).to eq "JWT"
    end
  end

  describe ".valid_payload" do
    it "checks the token for validity" do
      token = JsonWebToken.encode(user_id: user.id)
      decoded_token = JsonWebToken.decode(token)
      validity = JsonWebToken.valid_payload(decoded_token[0])

      expect(validity).to eq true
    end
  end

  describe ".meta" do
    it "defines meta tags for the payload" do
      meta = JsonWebToken.meta

      expect(meta.key?(:exp)).to eq true
      expect(meta.key?(:iss)).to eq true
      expect(meta.key?(:aud)).to eq true
    end
  end

  describe ".expired" do
    it "defines meta tags for the payload" do
      token = JsonWebToken.encode(user_id: user.id)
      decoded_token = JsonWebToken.decode(token)
      expired = JsonWebToken.expired(decoded_token[0])

      expect(expired).to eq false
    end
  end
end
