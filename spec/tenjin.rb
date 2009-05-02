describe 'Tenjin' do
  include TemplateEngineHelpers

  if Slate.const_defined? :Tenjin
    before(:each) do
      Slate.clear_cache
      # Only using ${} here because Ruby would parse #{}.  It's the same but escapes contents
      @input = '<p>Hello, ${@name}!  How are you this ${@tod}?</p>'
    end

    describe "ContextHelper included" do
      include ::Tenjin::ContextHelper

      it "should render basic tenjin with variables" do
        @name = "Max"
        @tod = "morning"
        render_string_compare(:tenjin, @input, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>", :context => binding)
      end

      it "should render faster when caching isn't disabled" do
        @name = "Brian"
        @tod = "evening"
        render_string_cache_benchmark(:tenjin, @input*200, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>"*200, {:context => binding})
      end

      def a_helper_method(greeting, title, person)
        return "#{greeting}, #{title} #{person.name}"
      end

      it "should have access to helper methods in local context" do
        @name = "John"
        @tod = "afternoon"
        @knight = Struct.new(:title, :name, :age).new("Sir", "Galahad", 37)
        render_string_compare(:tenjin, @input + "<p>${a_helper_method('Hello', @knight.title, @knight)}</p>",
          "<p>Hello, #{@name}!  How are you this #{@tod}?</p><p>Hello, Sir Galahad</p>", :context => binding)
      end

      describe "HtmlHelper also included" do
        include ::Tenjin::HtmlHelper
      end
    end

    describe "ContextHelper not included" do
      it "should render basic tenjin" do
        render_string_compare(:tenjin, '<p>Hello!</p>', "<p>Hello!</p>")
      end

      it "should raise an Exception if you include the binding" do
        lambda { render_string_compare(:tenjin, '<p>Hello!</p>', "<p>Hello!</p>", :context => binding) }.should raise_error(RuntimeError)
      end
    end
  else
    it "should test tenjin behavior" do
      pending "tenjin not installed"
    end
  end
end