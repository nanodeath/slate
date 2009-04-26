describe 'Builder' do
  include TemplateEngineHelpers

  if Slate.const_defined? :Builder
    it "should render Builder" do
      render_block_compare(:builder, nil, "<persons><person><first_name>John</first_name><last_name>Doe</last_name><phone>555-555-5555</phone></person><person><first_name>Jane</first_name><last_name>Doe</last_name><phone>555-555-5556</phone></person></persons>", :context => binding) do |x|
        x.persons do
          x.person do
            x.first_name("John")
            x.last_name("Doe")
            x.phone("555-555-5555")
          end
          x.person do
            x.first_name("Jane")
            x.last_name("Doe")
            x.phone("555-555-5556")
          end
        end
      end
    end
    
    it "should render Builder with variables" do
      @time = "hammer time"
      render_block_compare(:builder, nil, "<current_time>hammer time</current_time>", :context => binding) do |x|
        x.current_time(@time)
      end
    end

    it "should render Builder with options" do
      render_block_compare(:builder, nil, <<EXPECTED, :context => binding, :indent => 1, :margin => 1) do |x|
 <properties silly="true">
  <property>yes</property>
 </properties>
EXPECTED
        x.properties(:silly => true) do
          x.property("yes")
        end
      end
    end
  else
    it "should run tests on Builder" do
      pending "pending user installation of Builder"
    end
  end
end
