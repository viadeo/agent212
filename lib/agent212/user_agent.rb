require 'agent212/product'
require 'agent212/parser'

module Agent212

  class UserAgent
    attr_reader :parts

    def initialize
      @parts = [] # either products or strings (comments)
    end

    def self.parse(user_agent_string)
      new.tap do |ua|
        unless user_agent_string.nil?
          Parser.parse(user_agent_string).each { |part| ua.parts << part }
        end
      end
    end

    def self.empty
      new
    end

    def products
      @parts.select { |part| part.is_a? Product }
    end

    def comments
      @parts.select { |part| part.is_a? String }
    end

    def empty?
      @parts.empty?
    end

    def to_s
      "UserAgent: " + @parts.join(" ")
    end
  end

end
