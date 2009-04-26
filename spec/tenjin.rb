describe 'Tenjin' do
  include TemplateEngineHelpers

  if Slate.const_defined? :Tenjin
    before(:each) do
      Slate.clear_cache
      # Only using ${} here because Ruby would parse #{}.  It's the same but escapes contents
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
      render_string_cache_benchmark(:tenjin, @input, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>", {:context => binding})
    end

    def a_helper_method(name, title)
      return "Hello, #{title.a} #{name}"
    end

    it "should have access to helper methods in local context" do
      @name = "John"
      @tod = "afternoon"
      @title = Struct.new(:a, :b).new("Sir", "Dawg")
      render_string_compare(:tenjin, @input + "<p>${a_helper_method('Galahad', @title)}</p>",
        "<p>Hello, #{@name}!  How are you this #{@tod}?</p><p>Hello, Sir Galahad</p>", :context => binding)
    end
  else
    it "should test tenjin behavior" do
      pending "tenjin not installed"
    end
  end
end