require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
#require 'pony'

set :sass, { :style => :compact }
set :haml, { :ugly => true }

get "/styles.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

helpers do
  def current_tab_if(route)
    flag = ""
    #if route.length > 1
     # for x in route
      #  flag = route.length
        #flag = "current" if request.path_info == route[x]
    #  end
    #else
      flag = "current" if request.path_info == route
    #end
    flag
  end
end

get "/" do
  haml :language_assistance
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
  if false
  Pony.mail :to => "chad.ostrowski@gmail.com",
    :from => '"' + params[:name] + '" <' + params[:email] + '>',
    :subject => "Email submitted on Lisli.net",
    :message => params[:message]
  end
end
