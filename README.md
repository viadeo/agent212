Agent 212
=========

Agent 212 is a small Ruby library to handle HTTP user agent fields.

It splits a user agent field in parts according to the grammar from [RFC2616](http://tools.ietf.org/html/rfc2616#section-14.43).

It does not try to detect browsers (in the sense of [browser sniffing](http://en.wikipedia.org/wiki/Browser_sniffing)) but if you write some code around it you can use it for this purpose. If this is what you want to do you might want to take a look at https://github.com/kevinelliott/agent_orange .


Examples
--------
```ruby
user_agent = Agent212.parse(user_agent_string)
if cfnetwork = user_agent.products.detect { |p| p.name == "CFNetwork" }
  if cfnetwork.version != 520.4.3
    raise Foo, 'someone set us up the bomb!'
  else
    puts 'bar'
  end
end
```


About the name
--------------

http://en.wikipedia.org/wiki/Agent_212
