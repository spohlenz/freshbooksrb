require 'andand'

module FreshBooks
  class Base
    def initialize(attributes={})
      @attributes = attributes.inject({}) { |result, pair|
        result[pair.first] = self.class.normalize(*pair)
        result
      }
    end
    
    def method_missing(method, *args, &block)
      if @attributes.has_key?(method.to_s)
        @attributes[method.to_s]
      else
        super
      end
    end
    
    def id
      @attributes[self.class.id_field]
    end
    
    def self.map(mappings={})
      @mappings ||= {}
      @mappings.merge!(mappings)
    end
    
    # API methods
    
    def self.create(params={})
      call_api('create', params)[id_field]
    end
    
    def self.update(id, params={})
      call_api_with_id('update', id, params)
    end
    
    def self.get(id)
      result = call_api_with_id('get', id).andand[prefix]
      new(result) if result
    end
    
    def self.delete(id)
      call_api_with_id('delete', id)
    end
    
    def self.list(params={})
      result = call_api('list', params).andand[prefix.pluralize].andand[prefix]
      
      if result && result.is_a?(Array)
        result.map { |p| new(p) }
      elsif result
        [new(result)]
      else
        []
      end
    end
    
    def self.has_many(model)
      class_eval <<-EOF
        def #{model}(params={})
          FreshBooks::#{model.to_s.classify}.list(params.merge(self.class.id_field => id))
        end
      EOF
    end
    
    def self.belongs_to(model)
      class_eval <<-EOF
        def #{model}
          FreshBooks::#{model.to_s.classify}.get(#{model}_id)
        end
      EOF
    end
    
  private
    def self.call_api_with_id(method, id, params={})
      call_api(method, params.merge(id_field => id))
    end
  
    def self.call_api(method, params={})
      API.call("#{prefix}.#{method}", params)
    end
  
    def self.normalize(key, value)
      return value.to_i if key.ends_with?('_id')
      
      case @mappings[key.to_sym]
      when :integer
        value.to_i
      when :float
        value.to_f
      when :date
        Date.parse(value)
      when :boolean
        value == '1'
      else
        value
      end
    end
    
    def self.prefix
      self.name.demodulize.underscore
    end
    
    def self.id_field
      "#{prefix}_id"
    end
  end
end
