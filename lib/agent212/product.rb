module Agent212

  class Product
    attr_accessor :name, :version

    def initialize(name, version = nil)
      @name = name
      @version = version
    end

    def to_s
      if @version
        "#{@name}/#{@version}"
      else
        @name.to_s
      end
    end
  end

end
