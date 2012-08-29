require 'strscan'

module Agent212

  class Error < StandardError; end
  class ParseError < Error; end

  class Parser
    # http://tools.ietf.org/html/rfc2616#section-3.8

    # /[[:cntrl:]]/
    SEPARATOR = /\(|\)|\<|\>|@|,|;|:|\\|\"|\/|\[|\]|\?|\=|\{|\}|\ |\t/

    # SEPARATORS = '\(\)' << '<>@,;:' << '\\\\' << "\/" << '\[\]\?\=\{\}' << " \\t"
    SEPARATORS = Regexp.escape("()<>@,;:\\\"/[]?={} \t")
    # token = 1*<any CHAR except CTLs or separators>
    TOKEN = /[^#{SEPARATORS}[[:cntrl:]]]+/

    # LWS = [CRLF] 1*( SP | HT )
    LWS = /(\r\n)?\ |\t/

    PRODUCT = /TOKEN(\/TOKEN)?/
    # ctext = <any TEXT excluding "(" and ")">
    CTEXT = /[^\(\)]+/

    # quoted-pair = "\" CHAR
    # CHAR = <any US-ASCII character (octets 0 - 127)>
    CHAR = /[[:ascii:]]/ # FIXME, is this right?
    QUOTED_PAIR = /\\#{CHAR}/


    def initialize(input)
      @input = StringScanner.new(input.strip)
    end

    def self.parse(input)
      new(input).parse
    end

    # returns an array with the parts from the user_agent string in @input
    def parse
      parse_user_agent
    end

    # user agent = 1 * ( product | comment )
    # meaning AT LEAST ONE product or comment
    def parse_user_agent
      parts = []
      parts << parse_product_or_comment || raise(ParseError, 'expected at least one ( product | comment )')
      parse_lws or return parts
      while x = parse_product_or_comment
        parts << x
        parse_lws
      end
      parts
    end

    # product | comment
    def parse_product_or_comment
      parse_product || parse_comment
    end

    # returns the scanned whitespace or nil
    def parse_lws
      @input.scan(LWS)
    end

    # product = token ["/" product-version]
    def parse_product
      token = parse_token
      return nil if token.nil?
      Product.new(token).tap do |product|
        product.version = parse_optional_product_version
      end
    end

    # ["/" product-version]
    # returns nil or the version of the product
    # raises an error if '/'' is followed by a non-token
    def parse_optional_product_version
      return nil unless @input.scan(/\//)
      version = parse_product_version or raise ParseError, "expected a product-version at character #{@input.pos}"
      version
    end

    # returns the token or nil
    def parse_token
      @input.scan(TOKEN)
    end
    alias_method :parse_product_version, :parse_token

    # comment = "(" *( ctext | quoted-pair | comment ) ")"
    # returns a string with the comment including the brackets
    def parse_comment
      comment = @input.scan(/\(/) or return nil
      comment << parse_star_comment_contents
      comment << @input.scan(/\)/) or raise ParseError, "expected ) to end the comment #{comment.inspect}"
    end

    # *( ctext | quoted-pair | comment )
    def parse_star_comment_contents
      contents = ""
      while x = parse_ctext_or_quotedpair_or_comment
        contents << x
      end
      contents
    end

    def parse_ctext_or_quotedpair_or_comment
      parse_ctext || parse_quotedpair || parse_comment
    end

    # ctext = <any TEXT excluding "(" and ")">
    def parse_ctext
      @input.scan(CTEXT)
    end

    # quoted-pair = "\" CHAR
    def parse_quotedpair
      @input.scan(QUOTED_PAIR)
    end

  end
end
