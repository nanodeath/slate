describe 'Erubis' do
  include TemplateEngineHelpers

  if Slate.const_defined? :Erubis
    before(:each) do
      Slate.clear_cache
      @input = '<p>Hello, <%= @name %>!  How are you this <%= @tod %>?</p>'
      @unescaped = "<script>while(true) alert('hah');</script>"
      @escaped = "&lt;script&gt;while(true) alert('hah');&lt;/script&gt;"
    end

    it "should render basic erubis" do
      render_string_compare(:erubis, '<p>Hello!</p>', "<p>Hello!</p>", :context => binding)
    end

    it "should render basic erubis with variables" do
      @name = "Max"
      @tod = "morning"
      render_string_compare(:erubis, @input, "<p>Hello, #{@name}!  How are you this #{@tod}?</p>", :context => binding)
    end

    it "should render <%= =%> and <%= -%> whitespace stripped from surrounding" do
      @input = "This line has a line break after it.\nYes, indeed.\n\n"
      render_string_compare(:erubis, "<%= @input =%>\nHello!", "This line has a line break after it.\nYes, indeed.\n\nHello!", :context => binding)
      render_string_compare(:erubis, "<%= @input -%>\nHello!", "This line has a line break after it.\nYes, indeed.\n\nHello!", :context => binding)
    end

    it "should render <%== %> as escaped" do
      render_string_compare(:erubis, "<%= @unescaped %>", @unescaped, :context => binding)
      render_string_compare(:erubis, "<%== @unescaped %>", @escaped, :context => binding)
    end

    it "should work with different sub-engines passed manually" do
      render_string_compare(:erubis, "<%= @unescaped %>", @escaped, :context => binding, :engine => ::Erubis::EscapedEruby)
      render_string_compare(:erubis, "<%== @unescaped %>", @unescaped, :context => binding, :engine => ::Erubis::EscapedEruby)
    end

    it "should work with different sub-engines configured by default" do
      Slate::Erubis::DEFAULT_OPTIONS[:engine] = ::Erubis::EscapedEruby
      render_string_compare(:erubis, "<%= @unescaped %>", @escaped, :context => binding)
      render_string_compare(:erubis, "<%== @unescaped %>", @unescaped, :context => binding)
      render_string_compare(:erubis, "<%= @unescaped %>", @unescaped, :context => binding, :engine => ::Erubis::Eruby)
      Slate::Erubis::DEFAULT_OPTIONS[:engine] = ::Erubis::Eruby
    end

    class MyErubisEngine < ::Erubis::Eruby
      include Erubis::EscapeEnhancer
      include Erubis::PrintEnabledEnhancer
    end

    it "should work with custom sub-engines" do
      render_string_compare(:erubis, "<% print @unescaped %>", @unescaped, :context => binding, :engine => MyErubisEngine)
      render_string_compare(:erubis, "<%= @unescaped %>", @escaped, :context => binding, :engine => MyErubisEngine)
      render_string_compare(:erubis, "<%== @unescaped %>", @unescaped, :context => binding, :engine => MyErubisEngine)
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