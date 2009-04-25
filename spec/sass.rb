  describe 'Sass' do
    include TemplateEngineHelpers
    if Slate.const_defined? :Sass
      before do
        @input = <<-SASS
h1.big_important
  :color red

h3.not_important
  :color gray
  
h1, h3
  :font-weight bolder
  
.turkey
  :feathers brown
SASS
        @input_with_variables = <<-SASS
!main_color = <%= @main_color %>
!sec_color = <%= @secondary_color %>

h1.big_important
  :color = !main_color

h3.not_important
  :color = !sec_color

h1, h3
  :font-weight bolder

.turkey
  :feathers brown
SASS
      @output = <<-OUTPUT
h1.big_important {
  color: red; }

h3.not_important {
  color: gray; }

h1, h3 {
  font-weight: bolder; }

.turkey {
  feathers: brown; }
OUTPUT
      @output_with_variables = <<-OUTPUT
h1.big_important {
  color: <%= @main_color %>; }

h3.not_important {
  color: <%= @secondary_color %>; }

h1, h3 {
  font-weight: bolder; }

.turkey {
  feathers: brown; }
OUTPUT
    end
    
    it "should render basic Sass" do
      render_string_compare(:sass, @input, @output)
    end
    
    it "should render faster when caching isn't disabled" do
      render_string_cache_benchmark(:sass, @input, @output)
    end
    
    describe "Erubis|Sass" do
      if Slate.const_defined? :Erubis
        it "should pipeline erubis to sass" do
          @main_color  = "pink"
          @secondary_color = "orange"
          output = Slate.render_string(:erubis, @output_with_variables, :context => binding)
          render_string_compare([:erubis, :sass], @input_with_variables, output, :context => binding)
        end
        
        it "should have significant benefits from caching when pipelining" do
          @main_color  = "pink"
          @secondary_color = "orange"
          output = Slate.render_string(:erubis, @output_with_variables, :context => binding)
          render_string_cache_benchmark([:erubis, :sass], @input_with_variables, output, :context => binding)
        end
      else
        it "should test piping erubis to sass" do
          pending "pending user installation of erubis"
        end
      end
    end
    else
      it "should run sass tests" do
        pending "pending user installation of Sass/Haml"
      end    
  end
end
