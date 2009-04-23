
require File.join(File.dirname(__FILE__), %w[spec_helper])

Slate.configuration[:search_path] = [File.join(File.dirname(__FILE__), %w[templates])]


describe Slate do
  describe Slate::Haml do
    before(:each) do
      Slate.clear_cache
    end
  
    it "should render extremely basic haml" do
      Slate.render_string(:haml, <<-HAML).should == "<p>\n  Hello!\n</p>\n"
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
      Slate.render_string(:haml, string, {:context => binding}).should == "<p>\n  Hello, #{@name}!  How are you this #{@tod}?\n</p>\n"
    end
    
    it "should render external haml files" do
      @location = "Seattle"
      @weather = "rainy"
      
      Slate.render_file(:haml, 'hows_the_weather', {:context => binding}).should == "<p>
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
"
    end
    
    it "should render external haml files with a custom search path" do
      search_path = Slate.configuration[:search_path].dup
      search_path.unshift File.join(File.dirname(__FILE__), %w[templates path1])
      search_path.unshift File.join(File.dirname(__FILE__), %w[templates path2])
      
      @performance = "not bad"
      Slate.render_file(:haml, 'how_are_the_mariners', {:context => binding, :search_path => search_path}).should == "<p>How are the Mariners doing?</p>
<p>
  Oh, #{@performance}.
</p>
"
    end
    
    it "should render faster when caching isn't disabled" do
      @location = "Washington"
      @weather = "wet"
      no_cache_timer = Time.now
      n = 100
      n.times do
        Slate.render_file(:haml, 'hows_the_weather', {:context => binding, :no_cache => true}).should_not be_nil
      end
      no_cache_timer = Time.now - no_cache_timer
      cache_timer = Time.now
      n.times do
        Slate.render_file(:haml, 'hows_the_weather', {:context => binding}).should_not be_nil
      end
      cache_timer = Time.now - cache_timer
      cache_timer.should < no_cache_timer
    end
  end
end

# EOF
