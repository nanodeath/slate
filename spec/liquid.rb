describe 'Liquid' do
  include TemplateEngineHelpers

  if Slate.const_defined? :Liquid
    it "should render basic liquid" do
      render_string_compare(:liquid, <<-LIQUID, "<p>Hello!</p>\n", {:context => binding})
<p>Hello!</p>
      LIQUID
    end
    
    it "should render basic liquid with variables" do
      @pets = "cats"
      render_string_compare(:liquid, <<-LIQUID, "<p>I'm not allergic to #{@pets}.</p>\n", {:context => binding})
<p>I'm not allergic to {{ pets }}.</p>
      LIQUID
    end
    
    it "should render faster when caching isn't disabled" do
      @tod = "night"
      @feeling = "tired"
      
      string = "I shouldn't feel this {{ feeling }} at this time of {{ tod }}"
      output = "I shouldn't feel this #{@feeling} at this time of #{@tod}"
      
      render_string_cache_benchmark(:liquid, string*20, output*20, {:context => binding})
    end

    it "should render Liquid filters" do
      render_string_compare(:liquid, <<LIQUID, "What's the reverse of candybar?  rabydnac.\nWhat's the reverse of racecar?  racecar.  Gotcha!\n", :context => binding, :filters => [UselessFilter])
What's the reverse of candybar?  {{ "candybar" | reverse }}.
What's the reverse of racecar?  {{ "racecar" | reverse }}.  Gotcha!
LIQUID
    end

    it "should render Liquid tags" do
      @min = 1
      @max = 6
      render_string_compare(:liquid, <<LIQUID, "1|2|3|4|5|6\n", {:context => binding})
{% number_range 1,6 %}
LIQUID
    end

    it "should render Liquid tag blocks" do
      render_string_compare(:liquid, <<LIQUID, "<p>\nI'm in a paragraph!\n</p>\n", {:context => binding})
{% tagify p %}
I'm in a paragraph!
{% endtagify %}
LIQUID
    end

    describe "Erubis|Liquid" do
      include TemplateEngineHelpers
    
      if Slate.const_defined? :Erubis
        it "should render basic erubis" do
          render_string_compare([:erubis, :liquid], <<ERUBIS, "<p>Hello!</p>\n", {:context => binding})
<p>Hello!</p>
ERUBIS
        end

        it "should render basic erubis with variables" do
          @numbers = (1..5).to_a

          # I know this is a dumb example, but that's not the point!
          render_string_compare([:erubis, :liquid], <<ERUBIS, "<p>Numbers from 1 to 5: 12345.  Sum: 15.</p>\n", {:context => binding})
<p>Numbers from 1 to 5: {% for i in numbers %}{{i}}{% endfor %}.  Sum: <%= @numbers.inject(&:+) %>.</p>
ERUBIS
        end

        it "should render faster when caching isn't disabled" do
          @numbers = (1..5).to_a

          # I know this is a dumb example, but that's not the point!
          render_string_cache_benchmark([:erubis, :liquid], <<ERUBIS, "<p>Numbers from 1 to 5: 12345.  Sum: 15.</p>\n", {:context => binding})
<p>Numbers from 1 to 5: {% for i in numbers %}{{i}}{% endfor %}.  Sum: <%= @numbers.inject(&:+) %>.</p>
ERUBIS
        end
      else
        it "should run tests of erubis piping to liquid" do
          pending "pending user installation of erubis"
        end
      
      
      end
    end
  else
    it "should run tests on Liquid" do
      pending "pending user installation of Liquid"
    end
  end
end

if Slate.const_defined? :Liquid
  module UselessFilter
    def reverse(input)
      input.reverse
    end
  end

  class NumberRanger < Liquid::Tag
    def initialize(tag_name, range, tokens)
      super
      # wtf this is ugly
      range = range.split(',').map{|v| v.to_i}
      @min, @max = range
    end

    def render(context)
      @min.upto(@max).to_a.join('|')
    end
  end

  Liquid::Template.register_tag('number_range', NumberRanger)

  class Tagifier < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @tag = markup.to_s.strip
    end

    def render(context)
      "<#{@tag}>" + super(context).to_s + "</#{@tag}>"
    end
  end

  Liquid::Template.register_tag('tagify', Tagifier)
end