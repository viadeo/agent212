require 'rexml/document'

# useragentswitcher.xml was downloaded from
# http://techpatterns.com/downloads/firefox/useragentswitcher.xml
# at January 21, 2014.

# WARNING
# method copied from https://www.ruby-forum.com/topic/4411006
# it is by no means as well tested as the Inflector in Rails
class String
  def underscore
    self.replace(self.scan(/[A-Z][a-z]*/).join("_").downcase)
  end
end

def parse_root(root)
  root.elements.each do |element|
    if element.name == 'folder'
      parse_folder(element)
    else
      raise "unexpected element #{element.name}"
    end
  end
end

def parse_folder(folder)
  description = folder.attributes['description']
  return if description.include?(":: About") # skip the last folder with meta-info
  folder_name = description.underscore
  puts folder_name
  FileUtils.mkdir_p(folder_name)
  FileUtils.cd(folder_name) do
    folder.elements.each do |element|
      case element.name
      when "folder"
        parse_folder(element)
      when "useragent"
        parse_ua(element)
      when "separator"
        # ignore
      else
        raise "unexpected element #{element.name}"
      end
    end
  end
end

def parse_ua(ua)
  ua_string = ua.attributes["useragent"]
  description = ua.attributes["description"]
  File.open("ua_strings.txt", 'a') do |file|
    puts ua_string
    file.puts "# #{description}"
    file.puts ua_string
  end
end


doc = REXML::Document.new(File.new('useragentswitcher.xml'))
parse_root(doc.root)
