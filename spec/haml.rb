  describe 'Haml' do
    include TemplateEngineHelpers
  
    if Slate.const_defined? :Haml
    before(:each) do
      Slate.clear_cache
    end
  
    it "should render basic haml" do
      render_string_compare(:haml, <<-HAML, "<p>\n  Hello!\n</p>\n")
%p
  Hello!      
      HAML
    end
    
    it "should render basic haml with variables" do
      @name = "Max"
      @tod = "morning"
      string = '
%p
  ==Hello, #{@name}!  How are you this #{@tod}?
      '
      render_string_compare(:haml, string, "<p>\n  Hello, #{@name}!  How are you this #{@tod}?\n</p>\n", :context => binding)
    end
    
    it "should render external haml files" do
      @location = "Seattle"
      @weather = "rainy"
      
      render_file_compare(:haml, 'hows_the_weather', <<-OUTPUT, {:context => binding})
<p>
  How's the weather in #{@location}?
</p>
<p>
  Oh, you know, #{@weather} as usual.
</p>
<p>
  Ah..that sucks.  It's !#{@weather} here.
</p>
<p>
  What?
</p>
OUTPUT
    end
    
    it "should render external haml files with a custom search path" do
      search_path = Slate.configuration[:search_path].dup
      search_path.unshift File.join(File.dirname(__FILE__), %w[templates path1])
      search_path.unshift File.join(File.dirname(__FILE__), %w[templates path2])
      
      @performance = "not bad"
      render_file_compare(:haml, 'how_are_the_mariners', <<-OUTPUT, {:context => binding, :search_path => search_path})
<p>How are the Mariners doing?</p>
<p>
  Oh, #{@performance}.
</p>
OUTPUT
    end
    
    it "should render faster when caching isn't disabled" do
      @location = "Washington"
      @weather = "wet"
      
      render_file_cache_benchmark(:haml, 'hows_the_weather', <<-OUTPUT, {:context => binding})
<p>
  How's the weather in #{@location}?
</p>
<p>
  Oh, you know, #{@weather} as usual.
</p>
<p>
  Ah..that sucks.  It's !#{@weather} here.
</p>
<p>
  What?
</p>
      OUTPUT
    end
    else
      it "should test haml behavior" do
        pending "pending user installation of haml"
      end
    end
  end
