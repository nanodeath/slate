describe Slate::Cache do
  before do  
    @c = Slate::Cache.new
  end
  
  it "should store values" do
    lambda { @c["cat"] = "dog" }.should_not raise_error
    @c["cat"].should == "dog"
  end
  
  it "should track total size" do
    data = [['cat', 'dog'], ['bird', 'mouse'], ['car', 'house']]
    data.each do |(key, value)|
      @c[key] = value
    end
    @c.total_size.should == data.flatten.inject(0) {|memo, d| memo + d.to_s.length}
  end
end