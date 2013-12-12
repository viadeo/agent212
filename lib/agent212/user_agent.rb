require 'agent212/product'
require 'agent212/parser'

module Agent212

  class UserAgent
    attr_reader :parts

    def initialize
      @parts = [] # either products or strings (comments)
      # unless user_agent_string.nil? || user_agent_string.empty?
      #   Parser.parse(user_agent_string).each do |x|
      #     @parts << x
      #   end
      # end
    end

    def self.parse(user_agent_string)
      new.tap do |ua|
        unless user_agent_string.nil?
          Parser.parse(user_agent_string).each { |x| ua.parts << x }
        end
      end
    end

    def self.empty
      new
    end

    def products
      @parts.select { |p| p.is_a? Product }
    end

    def comments
      @parts.select { |p| p.is_a? String }
    end

    def empty?
      @parts.empty?
    end

    def to_s
      "UserAgent: " + @parts.join(" ")
    end
  end

end
