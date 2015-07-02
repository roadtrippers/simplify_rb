require "spec_helper"

describe SimplifyRb do
  context "simplifies points correctly with the given tolerance" do
    before(:each) {@test_data = SimplifyTestData::points}

    it "uses the fast strategy by default" do
      expect(SimplifyRb.simplify(@test_data, 5)).to eq(SimplifyTestData::result_fast)
    end

    it "uses the high quality strategy when the flag is passed" do
      expect(SimplifyRb.simplify(@test_data, 5, true)).to eq(SimplifyTestData::result_high_quality)
    end
  end

  context "simplifies points correctly with given tolerance and maximum limit" do
    # (0,0), (5,1), (7,2), (6,4), (4,7),(3,8), (8,9), (10,10)
    # (0,0), (7,2), (3,8), (10,10)
    let(:test_data) do
      [
        {x: 0.0, y: 0.0},
        {x: 5.0, y: 1.0},
        {x: 7.0, y: 2.0},
        {x: 6.0, y: 4.0},
        {x: 4.0, y: 7.0},
        {x: 3.0, y: 8.0},
        {x: 8.0, y: 9.0},
        {x: 10.0, y: 10.0}
      ]
    end

    let(:four_point_result) { [{x: 0, y: 0}, {x: 7, y: 2}, {x: 3, y: 8}, {x: 10, y: 10}] }

    it "stops iterating after 'keeping' the maximum number of points" do
      expect(SimplifyRb.simplify(test_data, 0.01, true, 4)).to eq(four_point_result)
    end
  end

  it "returns the points if it has only one point" do
    data = [{x: 1, y: 2}]

    expect(SimplifyRb.simplify(data)).to eq(data)
  end

  it "returns the array if it has no points" do
    expect(SimplifyRb.simplify([])).to eq([])
  end

  it "raises an argument error if the points are not passsed as an array" do
    data = {x: 1, y: 2}

    expect { SimplifyRb.simplify(data) }.to raise_error(ArgumentError, "Points must be an array")
  end

  describe "#keys_are_symbols?" do
    it "returns false if any key is not a Symbol" do
      expect(SimplifyRb.keys_are_symbols? [:a, 'b', :c]).to equal(false)
    end

    it "returns return true if all the keys are Symbols" do
      expect(SimplifyRb.keys_are_symbols? [:a, :b, :c]).to equal(true)
    end
  end

  describe "#symbolize_keys" do
    it "converts all of the collection's keys to symbols" do
      collection = [{'a' => 1, 'b' => 2}, {'c' => 3}]

      expect(SimplifyRb.symbolize_keys(collection)).to eq([{a: 1, b: 2}, {c: 3}])
    end
  end
end
