
require File.join(File.dirname(__FILE__), %w[spec_helper])

Slate.configuration[:search_path] = [File.join(File.dirname(__FILE__), %w[templates])]


describe Slate do
  describe Slate::Haml do
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
      pending
    end
  end
end

# EOF
