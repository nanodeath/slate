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
      render_block_compare(:markaby, nil, "<p>Today is a #{@day}.</p>"*2, :context => binding) do
        p "Today is a " + @day + "."
        p "Today is a #{@day}."
      end
    end

    it "should render markaby with assigns" do
      day = "Saturday"
      render_block_compare(:markaby, nil, "<p>Today is a #{day}</p>", :context => binding, :assigns => {:day => day}) do
        p "Today is a " + @day
      end
    end
    it "should render markaby with assigns and only_assigns option" do
      day = "Saturday"
      @hour = "12"
      lambda { render_block_compare(:markaby, nil, "<p>Today is a #{day}s</p>", :context => binding, :assigns => {:day => day}, :only_assigns => true) do
          p "Today is a " + @day
          p "The hour is " + @hour
        end
      }.should raise_error(TypeError) # since @hour is nil, can't do concatenation
    end

    it "should render markaby with a helpers class" do
      module Tester
        def comment(text)
          "// #{text}\n"
        end

        module_function :comment
      end
      @big_animal = "dog"
      @small_animal = "cat"
      render_block_compare(:markaby, nil, "<p>Comment the following:</p>// The dog\n//  chased after the cat\n", :context => binding, :helpers => Tester) do
        p "Comment the following:"
        comment "The " + @big_animal
        comment " chased after the #{@small_animal}"
      end
      # I was going to have a helper that took a block, but apparently
      # that's not really encouraged :(
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
