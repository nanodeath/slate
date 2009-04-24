
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
  
  def render_file_cache_benchmark(engine, input_file, output, options={})
    cache_options = options.dup
    no_cache_options = options.dup.merge({:no_cache => true})

      n = 200

      no_cache_timer = nil
      cache_timer = nil
      
      (n/10).times do
        render_file_compare(engine, input_file, output, no_cache_options)
      end


      no_cache = lambda do 
        Slate.clear_cache
        no_cache_timer = Time.now
        n.times do
          render_file_compare(engine, input_file, output, no_cache_options)
        end
        no_cache_timer = Time.now - no_cache_timer
      end
      
      cache = lambda do
        Slate.clear_cache
        cache_timer = Time.now
        n.times do
          render_file_compare(engine, input_file, output, cache_options)
        end
        cache_timer = Time.now - cache_timer
      end
      [cache, no_cache].sort_by {rand}.each {|t| t.call}
      engine = [engine] unless engine.is_a? Array
      Kernel.puts "\t#{engine.join('|')}: Cached is #{(no_cache_timer*100/cache_timer).round/100.0}x faster.  (cached: #{(n/cache_timer).round}/s, nocache: #{(n/no_cache_timer).round}/s, n: #{n})"
      cache_timer.should < no_cache_timer

  end

  def render_string_cache_benchmark(engine, input, output, options={})
    cache_options = options.dup
    no_cache_options = options.dup.merge({:no_cache => true})

      n = 200

      no_cache_timer = nil
      cache_timer = nil
      
      (n/10).times do
        render_string_compare(engine, input, output, no_cache_options)
      end


      no_cache = lambda do 
        Slate.clear_cache
        no_cache_timer = Time.now
        n.times do
          render_string_compare(engine, input, output, no_cache_options)
        end
        no_cache_timer = Time.now - no_cache_timer
      end
      
      cache = lambda do
        Slate.clear_cache
        cache_timer = Time.now
        n.times do
          render_string_compare(engine, input, output, cache_options)
        end
        cache_timer = Time.now - cache_timer
      end
      [cache, no_cache].sort_by {rand}.each {|t| t.call}
      engine = [engine] unless engine.is_a? Array
      Kernel.puts "\t#{engine.join('|')}: Cached is #{(no_cache_timer*100/cache_timer).round/100.0}x faster.  (cached: #{(n/cache_timer).round}/s, nocache: #{(n/no_cache_timer).round}/s, n: #{n})"
#      Kernel.puts "\t#{engine.join('|')}: Cached is #{(no_cache_timer*100/cache_timer).round/100.0}x faster.  (cached: #{cache_timer}, nocache: #{no_cache_timer}, n: #{n})"
      cache_timer.should < no_cache_timer

  end
end

describe Slate do
  load_spec 'sass.rb'
  load_spec 'haml.rb'
  load_spec 'liquid.rb'
  load_spec 'redcloth.rb'
  load_spec 'maruku.rb'
end

# EOF
