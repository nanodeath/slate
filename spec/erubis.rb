  describe 'Erubis' do
    include TemplateEngineHelpers
  
    if Slate.const_defined? :Erubis
    before(:each) do
      Slate.clear_cache
      @input = '<p>Hello, <%= @name %>!  How are you this <%= @tod %>?</p>'
    end
  
    it "should render basic erubis" do
      render_string_compare(:erubis, '<p>Hello!</p>', "<p>Hello!</p>", :context => binding)
    end
    
    it "should render basic erubis with variables" do
      @name = "Max"
      @tod = "morning"
      render_string_compare(:erubis, @input, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>", :context => binding)
    end
    
    it "should render faster when caching isn't disabled" do
      @name = "Brian"
      @tod = "evening"
      render_string_cache_benchmark(:erubis, @input * 100, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>" * 100, {:context => binding})
    end
    else
      it "should test erubis behavior" do
        pending "erubis not installed"
      end
    end
  end
