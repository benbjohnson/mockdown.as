module Mockdown
  module Model
    #########################################################################
    #
    # Static Methods
    #
    #########################################################################

    @system_components = {}
    
    # Public: Registers a system component to class.
    #
    # name  - The name to register the class under.
    # clazz - The class of the system component to register.
    #
    # Returns nothing.
    def self.register(name, clazz)
      @system_components[name] = clazz
      nil
    end

    # Public: Unregisters a system component.
    #
    # name - The registered name of the class to unregister.
    #
    # Returns the class that was registered to the name.
    def self.unregister(name)
      @system_components.delete(name)
    end


    # Public: Looks up a class by a registered name.
    #
    # name  - The registered name to lookup.
    # 
    # Returns a class if it is registered. Otherwise nil.
    def self.get_class(name)
      @system_components[name]
    end

    # Public: Looks up and creates a component that is registered to a given
    # name.
    #
    # name  - The registered name of the component to create.
    # 
    # Returns a new component if the name is registered. Otherwise returns nil.
    def self.create(name)
      if clazz = get_class(name)
        return clazz.new()
      else
        nil
      end
    end
  end
end

require 'mockdown/model/node'
require 'mockdown/model/visual_node'
require 'mockdown/model/document'
require 'mockdown/model/column'
require 'mockdown/model/row'
require 'mockdown/model/text'
