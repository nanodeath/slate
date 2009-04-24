  describe "Maruku" do
        include TemplateEngineHelpers

    if Slate.const_defined? :Maruku
      before do
        @input = <<-MARUKU
Maruku
======
It's Markdown for Ruby.
	
Markdown
--------
More crazy syntax

# Other H1 syntax

## And H2.  See a pattern yet?

# Yet Another H1 #

MARUKU
        @input_with_erubis = <<-MARUKU
<%= @header %>
==============

<%= @text %>
MARUKU
        @output = <<-OUTPUT
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC
    "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN"
    "http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg.dtd">
<html xmlns:svg='http://www.w3.org/2000/svg' xml:lang='en' xmlns='http://www.w3.org/1999/xhtml'>
<head><meta content='application/xhtml+xml;charset=utf-8' http-equiv='Content-type' /><title></title></head>
<body>
<h1 id='maruku'>Maruku</h1>

<p>It&#8217;s Markdown for Ruby.</p>

<h2 id='markdown'>Markdown</h2>

<p>More crazy syntax</p>

<h1 id='other_h1_syntax'>Other H1 syntax</h1>

<h2 id='and_h2_see_a_pattern_yet'>And H2. See a pattern yet?</h2>

<h1 id='yet_another_h1'>Yet Another H1</h1>
</body></html>
OUTPUT
        @output.chomp!
        @output_with_erubis = <<-OUTPUT
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC
    "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN"
    "http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg.dtd">
<html xmlns:svg='http://www.w3.org/2000/svg' xml:lang='en' xmlns='http://www.w3.org/1999/xhtml'>
<head><meta content='application/xhtml+xml;charset=utf-8' http-equiv='Content-type' /><title>Cat</title></head>
<body>
<h1 id='<%= @header.downcase %>'><%= @header %></h1>

<p><%= @text %></p>
</body></html>
OUTPUT
        @output_with_erubis.chomp!
      end
    
      it "should render basic Maruku" do
        render_string_compare(:maruku, @input, @output)
      end
      
      it "should render faster with caching" do
        render_string_cache_benchmark(:maruku, @input, @output)
        #Kernel.puts Slate.constants.select {|c| klass = Slate.const_get(c.to_sym); klass.is_a?(Class) && klass.superclass == Slate::TemplateEngine}.inspect
      end
      
      begin
        require 'erubis'
        
        describe "erubis|Maruku" do
          it "should work with variables now" do
            @header = "Cat"
            @text = "Dog"
            output = Slate.render_string(:erubis, @output_with_erubis, :context => binding)
            render_string_compare([:erubis, :maruku], @input_with_erubis, output, :context => binding)
          end
          
          it "should be much faster with caching" do
            @header = "Cat"
            @text = "Dog"
            output = Slate.render_string(:erubis, @output_with_erubis, :context => binding)
            render_string_cache_benchmark([:erubis, :maruku], @input_with_erubis, output, :context => binding)
          end
        end
      rescue
        it "should run erubis|Maruku tests" do
          pending "pending user installation of erubis"
        end
      end
    else
      it "should run Maruku tests" do
        pending "pending user installation of Maruku"
      end
    end
  end
