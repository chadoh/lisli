require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
#require 'pony'

set :sass, { :style => :compact }

get "/styles.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

helpers do
  def current_tab_if(route)
    "current" if request.path_info == route
  end
end

get "/" do
  haml :home
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
  #Pony.mail {
  #  :to => "chad.ostrowski@gmail.com",
  #  :from => '"' + params[:name] + '" <' + params[:email] + '>',
  #  :subject => "Email submitted on Lisli.net",
  #  :message => params[:message]
  #}
end
