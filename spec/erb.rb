  describe 'ERB' do
    include TemplateEngineHelpers
  
    if Slate.const_defined? :ERB
    before(:each) do
      Slate.clear_cache
      @input = '<p>Hello, <%= @name %>!  How are you this <%= @tod %>?</p>'
    end
  
    it "should render basic erb" do
      render_string_compare(:erb, '<p>Hello!</p>', "<p>Hello!</p>", :context => binding)
    end
    
    it "should render basic erb with variables" do
      @name = "Max"
      @tod = "morning"
      render_string_compare(:erb, @input, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>", :context => binding)
    end
    
    it "should render faster when caching isn't disabled" do
      @name = "Brian"
      @tod = "evening"
      render_string_cache_benchmark(:erb, @input, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>", {:context => binding})
    end
    else
      it "should test erb behavior" do
        pending "erb not installed"
      end
    end
  end
