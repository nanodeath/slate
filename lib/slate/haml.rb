require 'haml/util'
require 'haml/engine'
module Slate
  class Haml
    def self.render_string(string, binding)
      if(!binding)
         puts "oops, binding not set"
      end
      binding ||= Object.new
      ::Haml::Engine.new(string).render(binding)
    end
  end
end