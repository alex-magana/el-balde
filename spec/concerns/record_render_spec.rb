require "rails_helper"

describe "Concerns::RecordRender" do
  it "defines a module Concerns::RecordRender" do
    expect(defined?(Concerns::RecordRender)).to be_truthy
    expect(Concerns::RecordRender).to be_a(Module)
  end

  class Serializer
    extend Concerns::RecordRender
  end

  it "invokes date_created" do
    expect(Serializer).to respond_to(:date_created)
  end

  it "invokes date_modified" do
    expect(Serializer).to respond_to(:date_modified)
  end
end
