require 'agent212/product'
require 'agent212/parser'

module Agent212

  class UserAgent

    def initialize()
      @parts = [] # either products or strings (comments)
    end

    def self.parse(user_agent_string)
      Parser.parse(user_agent_string)
    end

    def products
      @parts.select {|p| p.is_a? Product }
    end

    def comments
      @parts.select {|p| p.is_a? String }
    end
  end

end
