require 'httparty'
require 'builder'

module FreshBooks
  class APIError < Exception; end
  
  class API
    include HTTParty
  
    format :xml
  
    def self.call(method, params={})
      result = post('/xml-in', :body => build_request(method, params))['response']
    
      if result['status'] == 'ok'
        result
      else
        raise APIError.new(result['error'])
      end
    end
  
    def self.configure(url, token)
      self.base_uri "#{url}:443/api/2.1"
      self.basic_auth token, 'X'
    end
  
  private
    def self.build_request(method, params)
      returning '' do |result|
        xml = Builder::XmlMarkup.new(:target => result)
        xml.instruct!
        xml.request(:method => method) { build_xml(xml, params) }
      end
    end
    
    def self.build_xml(xml, val={})
      val.each do |k, v|
        if v.is_a?(Hash)
          xml.tag!(k) { build_xml(xml, v) }
        elsif v.is_a?(Array)
          xml.tag!(k) {
            v.each { |i| xml.tag!(k.to_s.singularize, i) }
          }
        else
          xml.tag!(k, v)
        end
      end
    end
  end
end
