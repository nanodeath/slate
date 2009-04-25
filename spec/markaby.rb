describe 'Markaby' do
  include TemplateEngineHelpers

  if Slate.const_defined? :Markaby
    it "should render basic markaby" do
      render_block_compare(:markaby, nil, "<p>Hello!</p>", :context => binding) do
        p "Hello!"
      end
    end
    
    it "should render basic markaby with variables" do
      @day = "Friday"
      render_block_compare(:markaby, nil, "<p>Today is a #{@day}</p>", :context => binding) do
        p "Today is a " + @day
      end
    end

    # No markaby benchmarking because sadly it doesn't separate variable interpolation
    # from initial compile

    describe "Erubis|Markaby" do
      include TemplateEngineHelpers
    
      if Slate.const_defined? :Erubis
        it "should render basic erubis with variables" do
          @day = "Friday"
          render_block_compare([:markaby, :erubis], nil, "<p>Today is a #{@day}</p>", :context => binding) do
            p do
              text "Today is a <%= @day %>"
            end
          end
        end

        it "should render faster when caching isn't disabled" do
          @day = "Friday"
          render_block_cache_benchmark([:markaby, :erubis], "<p>Today is a #{@day}</p>", :context => binding) do
            p do
              text "Today is a <%= @day %>"
            end
          end
        end
      else
        it "should run tests of erubis piping to markaby" do
          pending "pending user installation of erubis"
        end
      
      
      end
    end
  else
    it "should run tests on Markaby" do
      pending "pending user installation of Markaby"
    end
  end
end
