
require File.join(File.dirname(__FILE__), %w[spec_helper])

Slate.configuration[:search_path] = [File.join(File.dirname(__FILE__), %w[templates])]


describe Slate do
  describe Slate::Haml do
    before(:each) do
      Slate.clear_cache
    end
  
    it "should render basic haml" do
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
      n = 500

      no_cache_timer = nil
      cache_timer = nil
      
      (n/10).times do
        Slate.render_file(:haml, 'hows_the_weather', {:context => binding, :no_cache => true}).should_not be_nil
      end


      no_cache = lambda do 
        Slate.clear_cache
        no_cache_timer = Time.now
        n.times do
          Slate.render_file(:haml, 'hows_the_weather', {:context => binding, :no_cache => true}).should_not be_nil
        end
        no_cache_timer = Time.now - no_cache_timer
      end
      cache = lambda do
        Slate.clear_cache
        cache_timer = Time.now
        n.times do
          Slate.render_file(:haml, 'hows_the_weather', {:context => binding}).should_not be_nil
        end
        cache_timer = Time.now - cache_timer
      end
      [cache, no_cache].sort_by {rand}.each {|t| t.call}
      Kernel.puts "Haml: Cached is #{no_cache_timer/cache_timer}x faster.  (cached: #{cache_timer}, nocache: #{no_cache_timer}, n: #{n})"
      cache_timer.should < no_cache_timer
    end
  end
  
  describe Slate::Liquid do
    it "should render basic liquid" do
      Slate.render_string(:liquid, <<-LIQUID, {:context => binding}).should == "<p>Hello!</p>\n"
<p>Hello!</p>
      LIQUID
    end
    
    it "should render basic liquid with variables" do
      @pets = "cats"
      Slate.render_string(:liquid, <<-LIQUID, {:context => binding}).should == "<p>I'm not allergic to #{@pets}</p>\n"
<p>I'm not allergic to {{ pets }}</p>
      LIQUID
    end
    
    it "should render faster when caching isn't disabled" do
      @tod = "night"
      @feeling = "tired"
      n = 500
      string = "I shouldn't feel this {{ feeling }} at this time of {{ tod }}"

      no_cache_timer = nil
      cache_timer = nil
      
      (n/10).times do
        Slate.render_string(:liquid, string, {:context => binding, :no_cache => true}).should_not be_nil
      end

      no_cache = lambda do 
        Slate.clear_cache
        no_cache_timer = Time.now
        n.times do
          Slate.render_string(:liquid, string, {:context => binding, :no_cache => true}).should_not be_nil
        end
        no_cache_timer = Time.now - no_cache_timer
      end
      cache = lambda do
        Slate.clear_cache
        cache_timer = Time.now
        n.times do
          Slate.render_string(:liquid, string, {:context => binding}).should_not be_nil
        end
        cache_timer = Time.now - cache_timer
      end
      [cache, no_cache].sort_by {rand}.each {|t| t.call}
      Kernel.puts "Liquid: Cached is #{no_cache_timer/cache_timer}x faster.  (cached: #{cache_timer}, nocache: #{no_cache_timer}, n: #{n})"
      cache_timer.should < no_cache_timer
    end
  end
end

# EOF
