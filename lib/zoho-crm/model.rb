module ZohoCrm
  module Model
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      def property_names
        @property_names ||= Set.new
      end

      def property_aliases
        @property_aliases ||= Hash.new
      end

      def module_name
        @module_name ||= base.name.gsub(/^.*::/, '')
      end

      def custom_module_name(custom_name = nil)
        @module_name = custom_name
      end

      def property(property_name, options = {})
        property_names.add(property_name)

        attr_accessor property_name

        if options[:as]
          property_aliases[property_name] = options[:as]

          define_method("#{options[:as]}=") do |val|
            self.instance_variable_set("@#{property_name}", val.is_a?(String) ? val.encode(:xml => :text) : val)
          end

          define_method("#{options[:as]}") do
            self.instance_variable_get("@#{property_name}")
          end
        end
      end
    end

    def initialize(attributes = {})
      puts '____model#intialize____'
      puts attributes.inspect
      attributes.each do |attribute, value|
        method_name = "#{attribute}="
        public_send(method_name, value.is_a?(String) ? value.encode(:xml => :text) : value) if respond_to?(method_name)
      end
    end

    def to_h(options = {})
      properties = options[:aliases] ? self.class.property_aliases.values : self.class.property_names

      Hash[properties.map { |property| [property, public_send(property)] }]
    end

    def update(attributes = {})
      attributes.each do |attribute, value|
        public_send("#{attribute}=", value) if respond_to?(attribute)
      end

      self
    end
  end
end
