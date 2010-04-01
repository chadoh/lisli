require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'

set :sass, { :style => :compact }

get "/styles.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

before do
  @first_name = "Chad"
  @full_name = "Chad Ostrowski"
end

helpers do
  def partial(page, options={})
    haml page, options.merge!(:layout => false)
  end
end

get "/" do
  haml :home
end

get "/:page/?" do
  begin
    haml params[:page].to_sym
  rescue Errno::ENOENT
    haml :home
  end
end
