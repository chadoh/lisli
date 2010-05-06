# stolen from http://gist.github.com/119874 and made a tiny bit more robust by me
# this implementation uses haml by default. if you want to use any other template mechanism
#   then replace `erb` on line 23 and line 31 with `erb` or whatever 

#This implementation varies from lenary's because it allows a :spacer_string to be specified
# a spacer_string works the same way as a :spacer_template in rails,
# except instead of rendering a page it plops in a string, 
# but only in between elements of the collection, not at the end.
# This is useful if you have, say, a collection of blog tags, 
# rendered as a collection of links with commas between them.

#DISCLAIMER: I have never used a :spacer_template in rails,
#so I designed this from my perhaps-misguided understanding of it.
module Sinatra::Partials
  def partial(template, *args)
    template_array = template.to_s.split('/')
    template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then
      spacer_string = options.delete(:spacer_string)
      collection.inject([]) do |buffer, member|
        rendered = haml(:"#{template}", options.merge(:layout =>
        false, :locals => {template_array[-1].to_sym => member}))
        if spacer_string
          rendered << spacer_string if member != collection.last
        end
        buffer << rendered
      end.join("\n")
    else
      haml(:"#{template}", options)
    end
  end
end
