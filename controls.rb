require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'pony'
require 'crack'
require 'open-uri'

#Extend Hash class so that keys can be accessed as attributes, with dot notation.
#Courtesy of http://www.goodercode.com/wp/convert-your-hash-keys-to-object-properties-in-ruby/
class ::Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end

set :sass, { :style => :compact }
set :haml, { :ugly => true }

get "/styles.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

helpers do
  #Helper function to add class="current" to the active tab
  #Allows passing in either a simple string with the route name
  #to flag on,
  #or an array of strings if multiple states receive a flag
  def current_tab_if(route)
    flag = ""
    if route.respond_to? :each
      for x in route
        flag = "current" if request.path_info == x
      end
    else
      flag = "current" if request.path_info == route
    end
    flag
  end
  
  #Helper to turn date returned from blogger into a ruby date. Assumes Eastern Standard Time (New York)
  #Assumes format like this: 2009-11-16T23:28:00.000-05:00
  #
  #It would be nice to generalize this to deal with any iso formatted string,
  #make it extend the Time class,
  #and turn it into a gem.
  def time_from_iso_format_str(iso_8601_string)
    iso_8601_string [/(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)/];
    y=$1;mon=$2;d=$3;h=$4;min=$5;s=$6
    Time.local(y,mon,d,h,min,s)
  end
end

get "/" do
  haml :language_assistance
end

#loads in blogger feed
get "/thoughts" do
  #for testing in irb:
  #require 'open-uri'; require 'crack'; url = 'http://www.blogger.com/feeds/9096209599953091034/posts/default';xml = open(url).read;feed = Crack::XML.parse(xml).feed;posts = feed.entry;
  url = 'http://www.blogger.com/feeds/9096209599953091034/posts/default'
  xml = open(url).read
  feed = Crack::XML.parse(xml).feed
  @posts = feed.entry

  haml :thoughts
end

get "/:page/?" do
  begin
    haml params[:page].to_sym
  rescue Errno::ENOENT
    haml :not_found
  end
end

not_found do
  haml :not_found
end

post "/contact" do
  Pony.mail :to => "chad.ostrowski@gmail.com",
    :from => params[:email],
    :subject => "Email submitted on Lisli.net",
    :message => params[:message]
end
