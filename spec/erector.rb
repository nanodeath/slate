describe 'Erector' do
  include TemplateEngineHelpers
    
  if Slate.const_defined? :Erector

    class TestWidget < Erector::Widget
      def render
        html do
          head do
            title "Welcome page"
          end
          body do
            p "Hello, world"
          end
        end
      end

      def cat
        html do
          body do
            text "cat"
          end
        end
      end
    end

    it "should render Erector" do
      render_block_compare(:erector, nil, "<html><head><title>Welcome page</title></head><body><p>Hello, world</p></body></html>",  :class => TestWidget)
    end

    it "should render Erector using specified methods" do
      render_block_compare(:erector, nil, "<html><body>cat</body></html>", :class => TestWidget, :method => :cat)
    end

    it "should render Erector's inline widgets" do
      render_block_compare(:erector, nil, "<head><title>Welcome!</title></head>") do
        head do
          title "Welcome!"
        end
      end
    end
    
  else
    it "should run Erector tests" do
      pending "pending user installation of Erector"
    end
  end
end
