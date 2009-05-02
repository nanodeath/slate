
module Slate

  # :stopdoc:
  VERSION = '0.1.0'
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, args.flatten)
  end

  # Utility method used to require all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end

end  # module Slate

module Slate
  ENGINE_MAPPING = {}

  # if you pass in a block:
  #   process block with engine(s) given in options[:engines]
  # otherwise, if you pass in a file in options[:file] (File or full path)
  #   process that using a best-guess on file extension(s)
  # otherwise, if you pass in a string via options[:body]
  #   process string with engine(s) given in options[:engines]
  def self.render(options={}, &block)
    engines = options[:engines]
    if block_given?
      if !engines
        raise ArgumentError, "Block given but no engine (given in :engines option)"
      end
      result = block
      if engines.is_a? Array
        engines.each do |e|
          result = render(options, block)
        end
      end



    else
      if options[:file]
        if engines

        else
          engines = []
        end
      elsif options[:body]
      else
        raise ArgumentError, "No block given, nor :file or :body options."
      end
    end
  end
  
  def self.render_string(engine, string, options={})
    if !engine.is_a? Array
      engine = [engine]
    end
    result = string
    
    engines_used = 0
    engine.each do |e|
      e = ENGINE_MAPPING[e.to_s.downcase]
      if(e)
        result = e.render_string(result, options[:context], options)
        engines_used += 1
      else
        break
      end
    end
    raise "No engine found" if engines_used == 0
    return result
  end
  
  def self.render_file(engine_name, filename, options={})
    extension = engine_name.is_a?(Array) ? engine_name.first.to_s.downcase : engine_name.to_s.downcase
    engine = get_engine(engine_name)
    if(engine)
      filename += "." + extension unless filename.include? '.'
      search_path = options[:search_path] || @configuration[:search_path]
      file = resolve_path(filename, search_path)
      if(file)
        string = File.open(file) {|f| f.read}
        engine.render_string(string, options[:context], options)
      else
        raise "Template `#{filename}` not found (searched #{search_path.inspect})."
      end
    else
      raise "Engine `#{engine_name}` could not be resolved"
    end
  end

  def self.guess_engine(filename)
    extensions = File.basename(filename).split('.')[1..-1].reverse
    engines = []
    extensions.each do |ext|
      engines << TemplateEngine.extensions[ext].first
    end
    return engines
  end
  
  def self.render_block(engine, options={}, &block)
    if !engine.is_a? Array
      engine = [engine]
    end
    result = ""
    
    engines_used = 0
    engine.each do |e|
      e = ENGINE_MAPPING[e.to_s.downcase]
      if(e)
        if(engines_used == 0)
          result = e.render_block(options[:context], options, &block)
        else
          result = e.render_string(result, options[:context], options)
        end
        engines_used += 1
      else
        break
      end
    end
    raise "No engine found" if engines_used == 0
    return result
  end
  
  def self.clear_cache
    ENGINE_MAPPING.values.each do |engine|
      engine.clear_cache
    end
  end
  
  def self.configuration
    @configuration ||= {
      :search_path => []
    }
  end
  
  def self.get_engine(engine_string)
    engine = engine_string.to_s.downcase
    ENGINE_MAPPING[engine]
  end

  private
  def self.resolve_path(filename, search_path)
    search_path.each do |path|
      path = ::File.expand_path(
        ::File.join(path, filename))
      return path if File.exist? path
    end
    return nil
  end
end

#require 'slate/template_engine'
#Slate.require_all_libs_relative_to(__FILE__)
requirements = []
requirements << 'cache' << '_template_engine' << 'builder' << 'erb' << 'erector'
requirements << 'erubis' << 'haml' << 'liquid' << 'markaby' << 'maruku'
requirements << 'redcloth' << 'sass' << 'tenjin'
requirements.each do |r|
  require Slate.libpath("slate/#{r}")
end



# EOF
