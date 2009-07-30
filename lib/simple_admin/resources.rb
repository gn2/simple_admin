require 'singleton'

module SimpleAdmin

  class Resources
    include Singleton

    class << self
      def register(name, options={})
        instance.register(name, options)
      end

      def get(resource_name)
        instance.get(resource_name)
      end
    end

    def initialize
      @list = []
    end

    def register(name, options={})
       @list << Resource.new(name, options)
       SimpleAdmin::Tabs.instance.register(name, "admin_#{name.to_s.downcase}_path".to_sym) if options[:tab]
    end

    def get(resource_name)
      @list.select {|resource| resource.name.to_s==resource_name.to_s }.first
    end

    def list
      @list
    end

    private
    def add_route
      new_route = ActionController::Routing::Routes.builder.build(name, route_options)
      ActionController::Routing::Routes.routes.insert(0, new_route)
    end

  end

  class Resource

    attr_accessor :name, :options, :controller_methods

    def initialize(name, options={})
      self.name = name
      self.controller_methods = parse_controller_methods(options[:controller_methods])
      self.options = {
        :index => [],
        :edit => [],
        :sidebar => [],
        :route => false,
        :tab => false,
        :class_name => nil
      }.merge(options)
    end

    def class_name
      self.options[:class_name]
    end

    def has_controller_method?(method_name)
      methods = self.controller_methods.select{ |method| method.name.to_s==method_name.to_s }
      (methods && !methods.empty?) ? methods.first : false
    end

    def controller_method(method)
      raise NoMethodError unless controller_method = has_controller_method?(method)
      return controller_method
    end

    def parse_controller_methods(controller_methods)
      returning [] do |result|
        controller_methods.each do |controller_method|
          result << ControllerMethod.new(controller_method)
        end
      end
    end

    # Handle controller methods
    class ControllerMethod

      attr_accessor :name, :redirection, :render, :method, :do, :flash_notice, :flash_error

      def initialize(options={})
        [:name, :redirection, :render, :method, :do, :flash_notice, :flash_error].each do |attribute|
          self.send("#{attribute}=", options[attribute])
        end
      end

      def call(object)
        raise "No action defined" unless self.do
        self.do.call(object)
      end

      def has_redirection?
        !self.redirection.nil?
      end

      def has_render?
        !self.render.nil?
      end
      
      def has_flash_notice?
        !self.flash_notice.nil?
      end

      def has_flash_error?
        !self.flash_error.nil?
      end

    end

  end # Class Resource

end
