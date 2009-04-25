describe 'RedCloth' do
  include TemplateEngineHelpers
    
  if Slate.const_defined? :RedCloth
    
    it "should render basic RedCloth" do
      render_string_compare(:redcloth, <<-REDCLOTH, "RedCloth is <em>really</em> just <strong>Textile</strong>, but for Ruby!", {:context => binding})
      RedCloth is _really_ just *Textile*, but for Ruby!
      REDCLOTH
    end
    
    it "should render faster when caching isn't disabled" do
      n = 10
      input = "Time to turn on those _bright_ lights once again.\n\n"*n
      output = []
      n.times { output << "<p>Time to turn on those <em>bright</em> lights once again.</p>"}
      output = output.join("\n")
      render_string_cache_benchmark(:redcloth, input, output)
    end
    
    describe Slate::Erubis do
      it "should pipe erubis to redcloth" do
        @feature = "variable interpolation"
        render_string_compare([:erubis, :redcloth], <<-ERUBIS, "Now I have <strong>#{@feature}</strong> support!", :context => binding)
          Now I have <%= "*" + @feature + "*" %> support!
        ERUBIS
      end
      
      it "should be faster to cache pipes" do
        @feature = "variable interpolation"
        render_string_cache_benchmark([:erubis, :redcloth], <<-ERUBIS, "Now I have <strong>#{@feature}</strong> support!", :context => binding)
          Now I have <%= "*" + @feature + "*" %> support!
        ERUBIS
      end
    end
    
  else
    it "should run RedCloth tests" do
      pending "pending user installation of RedCloth"
    end
  end
end
