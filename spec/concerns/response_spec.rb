require "rails_helper"

describe "Concerns::Response" do
  include Concerns::Response

  it "defines a module Concerns::Paginate" do
    expect(defined?(Concerns::Response)).to be_truthy
    expect(Concerns::Response).to be_a(Module)
  end

  class Controller
    extend Concerns::Response
  end

  it "invokes render_response" do
    expect(Controller).to respond_to(:render_response)
  end
end
