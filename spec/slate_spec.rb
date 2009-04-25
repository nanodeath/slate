
require File.join(File.dirname(__FILE__), %w[spec_helper])

Slate.configuration[:search_path] = [File.join(File.dirname(__FILE__), %w[templates])]

def load_spec(path)
  load(File.join(File.dirname(__FILE__), path))
end

module TemplateEngineHelpers
  def render_string_compare(engine, input, output, options={})
    Slate.render_string(engine, input, options).should == output
  end
  
  def render_file_compare(engine, input_file, output, options={})
    Slate.render_file(engine, input_file, options).should == output
  end
  
  def render_block_compare(engine, input, output, options={}, &block)
    Slate.render_block(engine, options, &block).should == output
  end
  
  def render_cache_benchmark(method, engine, input, output, options={}, &block)
    cache_options = options.dup
    no_cache_options = options.dup.merge({:no_cache => true})

      n = 200

      no_cache_timer = nil
      cache_timer = nil
      
      (n/10).times do
        send method.to_sym, engine, input, output, no_cache_options, &block
      end


      no_cache = lambda do 
        Slate.clear_cache
        no_cache_timer = Time.now
        n.times do
          send method.to_sym, engine, input, output, no_cache_options, &block
        end
        no_cache_timer = Time.now - no_cache_timer
      end
      
      cache = lambda do
        Slate.clear_cache
        cache_timer = Time.now
        n.times do
          send method.to_sym, engine, input, output, cache_options, &block
        end
        cache_timer = Time.now - cache_timer
      end
      [cache, no_cache].sort_by {rand}.each {|t| t.call}
      engine = [engine] unless engine.is_a? Array
      Kernel.puts "\t#{engine.join('|')}: Cached is #{(no_cache_timer*100/cache_timer).round/100.0}x faster.  (cached: #{(n/cache_timer).round}/s, nocache: #{(n/no_cache_timer).round}/s, n: #{n})"
      # In some cases it's about the same speed -- giving some leeway here..
      leeway = 1.2
      cache_timer.should < no_cache_timer * leeway
  end
  
  def render_file_cache_benchmark(engine, input_file, output, options={})
    render_cache_benchmark(:render_file_compare, engine, input_file, output, options)
  end

  def render_string_cache_benchmark(engine, input, output, options={})
    render_cache_benchmark(:render_string_compare, engine, input, output, options)
  end
  
  def render_block_cache_benchmark(engine, output, options={}, &block)
    render_cache_benchmark(:render_block_compare, engine, nil, output, options, &block)
  end
end

describe Slate do
  ['cache'].each {|t| load_spec t + '.rb'}

  ['haml', 'liquid', 'redcloth', 'maruku', 'sass', 'erb', 'erubis', 'markaby', 'tenjin'].sort.each {|t| load_spec t + '.rb'}
end

# EOF
