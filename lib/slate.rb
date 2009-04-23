
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

require 'slate/template_engine'
Slate.require_all_libs_relative_to(__FILE__)

module Slate
  ENGINE_MAPPING = {
    'haml' => Haml,
    'liquid' => Liquid
  }
  
  def self.render_string(engine, string, options={})
    engine = engine.to_s.downcase
    engine = ENGINE_MAPPING[engine]
    if(engine)
      engine.render_string(string, options[:context], options)
    end
  end
  
  def self.render_file(engine_name, filename, options={})
    extension = engine_name.to_s.downcase
    engine = get_engine(engine_name)
    if(engine)
      filename += "." + extension
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
  
  private
  def self.get_engine(engine_string)
    engine = engine_string.to_s.downcase
    ENGINE_MAPPING[engine]
  end
  
  def self.resolve_path(filename, search_path)
    search_path.each do |path|
      path = ::File.expand_path(
        ::File.join(path, filename))
      return path if File.exist? path
    end
    return nil
  end
end

# EOF
