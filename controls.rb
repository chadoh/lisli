require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'pony'
require 'crack'
require 'open-uri'

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
end

get "/" do
  haml :language_assistance
end

#loads in blogger feed
get "/thoughts" do
  url = 'http://www.blogger.com/feeds/9096209599953091034/posts/default'
  xml = open(url).read
  @feed = Crack::XML.parse(xml)

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
