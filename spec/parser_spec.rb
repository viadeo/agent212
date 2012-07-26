require 'agent212'

describe Agent212::Parser do

  context 'parsing tokens' do
    it 'should parse a valid token' do
      Agent212::Parser.new('foo').parse_token.should == 'foo'
      Agent212::Parser.new('BaR').parse_token.should == 'BaR'
      Agent212::Parser.new('23489.quux').parse_token.should == '23489.quux'
      Agent212::Parser.new('URL%20encoded').parse_token.should == 'URL%20encoded'
    end

    it 'should not parse an invalid token' do
      Agent212::Parser.new('(foo)').parse_token.should be_nil
      Agent212::Parser.new('\tBaR').parse_token.should be_nil
    end

  end

  context "parsing LWS" do
    it 'should parse a space as whitespace' do
      x = Agent212::Parser.new("foo foo")
      x.parse_token
      x.parse_lws.should == ' '
    end

    it 'should parse a tab as whitespace' do
      x = Agent212::Parser.new("foo\tfoo")
      x.parse_token
      x.parse_lws.should == "\t"
    end


    it 'should not parse non-LWS' do
      Agent212::Parser.new('foo').parse_lws.should be_nil
      Agent212::Parser.new('bar ').parse_lws.should be_nil
    end
  end


  context "parsing a whole user_agent string" do
    it "" do
      x = Agent212::UserAgent.new("Viadeo%20Sync%20for%20the%20Mac/0.1.2 CFNetwork/520.4.3 Darwin/11.4.0 (x86_64) (MacBook6%2C1)")
      # x = parser.parse
      x.should_not be_nil
      x.comments.size.should == 2
      x.comments.should include("(x86_64)")
    end

    it "should help in figuring out this is webkit" do
      ua = Agent212::UserAgent.parse "Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405"
      ua.products.detect {|p| p.name == "AppleWebKit" }.should_not be_nil
      puts ua.to_yaml
    end
  end

end

