require "spec_helper"

RSpec.describe Bunny::Tsort do
  it "has a version number" do
    expect(Bunny::Tsort::VERSION).not_to be nil
  end

  it "sorts empty" do
  	h = {} 
    expect(Bunny::Tsort::tsort(h).length).to be 0
  end

  it "sorts correctly" do
  	h = {:a=>[:b, :c], :b=>[:c, :d], :d=>[:e, :f]}
  	result = Bunny::Tsort::tsort(h)
    expect(result[0]).to contain_exactly(:c, :e, :f)
    expect(result[1]).to contain_exactly(:d)
    expect(result[2]).to contain_exactly(:b)
    expect(result[3]).to contain_exactly(:a)
  end

  it "fail on cycle" do
  	h = {a: [:b], b: [:a]} 
    expect{Bunny::Tsort::tsort(h)}.to raise_error(Bunny::Tsort::CyclicGraphException)
  end
end
