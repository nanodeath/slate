
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

Slate.require_all_libs_relative_to(__FILE__)

module Slate
  ENGINE_MAPPING = {
    'haml' => Haml
  }
  
  def self.render_string(engine, string, options={})
    engine = engine.to_s.downcase
    engine = ENGINE_MAPPING[engine]
    if(engine)
      engine.render_string(string, options[:context])
    end
  end
  
  def self.render_file(engine, filename, options={})
    extension = engine.to_s.downcase
    engine = get_engine(engine)
    if(engine)
      file = resolve_path(filename + "." + extension, @configuration[:search_path])
      string = File.open(file) {|f| f.read}
      engine.render_string(string, options[:context])
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
