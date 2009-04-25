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
      
      render_string_cache_benchmark(:liquid, string, output, {:context => binding})
    end  
    describe "Erubis|Liquid" do
      include TemplateEngineHelpers
    
      if Slate.const_defined? :Erubis
        it "should render basic erubis" do
          render_string_compare([:erubis, :liquid], <<-ERUBIS, "<p>Hello!</p>\n", {:context => binding})
<p>Hello!</p>
          ERUBIS
        end

        it "should render basic erubis with variables" do
          @numbers = (1..5).to_a

          # I know this is a dumb example, but that's not the point!
          render_string_compare([:erubis, :liquid], <<-ERUBIS, "<p>Numbers from 1 to 5: 12345.  Sum: 15.</p>\n", {:context => binding})
<p>Numbers from 1 to 5: {% for i in numbers %}{{i}}{% endfor %}.  Sum: <%= @numbers.inject(&:+) %>.</p>
          ERUBIS
        end

        it "should render faster when caching isn't disabled" do
          @numbers = (1..5).to_a

          # I know this is a dumb example, but that's not the point!
          render_string_cache_benchmark([:erubis, :liquid], <<-ERUBIS, "<p>Numbers from 1 to 5: 12345.  Sum: 15.</p>\n", {:context => binding})
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
