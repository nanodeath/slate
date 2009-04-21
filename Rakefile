# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'slate'

task :default => 'spec:run'

PROJ.name = 'slate'
PROJ.authors = 'Max Aller'
PROJ.email = 'nanodeath@gmail.com'
PROJ.url = 'http://blog.maxaller.name/'
PROJ.version = Slate::VERSION
PROJ.rubyforge.name = 'slate'

PROJ.spec.opts << '--color'

# EOF
