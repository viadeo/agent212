require 'agent212/product'
require 'agent212/parser'

module Agent212

  class UserAgent

    def initialize(user_agent_string)
      @parts = [] # either products or strings (comments)
      Parser.parse(user_agent_string).each do |x|
        @parts << x
      end
    end

    def self.parse(user_agent_string)
      new user_agent_string
    end

    def products
      @parts.select {|p| p.is_a? Product }
    end

    def comments
      @parts.select {|p| p.is_a? String }
    end
  end

end
