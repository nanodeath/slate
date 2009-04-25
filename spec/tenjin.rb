describe 'Tenjin' do
  include TemplateEngineHelpers

  if Slate.const_defined? :Tenjin
    before(:each) do
      Slate.clear_cache
      @input = '<p>Hello, ${@name}!  How are you this ${@tod}?</p>'
    end

    it "should render basic tenjin" do
      render_string_compare(:tenjin, '<p>Hello!</p>', "<p>Hello!</p>")
    end

    it "should render basic tenjin with variables" do
      @name = "Max"
      @tod = "morning"
      render_string_compare(:tenjin, @input, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>", :context => binding)
    end

    it "should render faster when caching isn't disabled" do
      @name = "Brian"
      @tod = "evening"
      render_string_cache_benchmark(:tenjin, @input * 100, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>" * 100, {:context => binding})
    end
  else
    it "should test tenjin behavior" do
      pending "tenjin not installed"
    end
  end
end