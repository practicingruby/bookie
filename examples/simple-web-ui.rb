require "sinatra"
require_relative "../lib/bookie"

get "/" do
  haml :index
end

post "/" do
  content_type 'application/pdf'
  attachment "#{params['title']}.pdf"

  emitter = Bookie::Emitters::PDF.new 
  emitter.start_new_chapter(title: params["title"],
                            header: params["header"])
  Bookie::Parser.parse(params["body"], emitter)

  emitter.document.render
end

__END__

@@ index

%form{:method => "post"}
  %input{:type => "text", :name => "title"}
  %br
  %input{:type => "text", :name => "header"}
  %br
  %textarea{:name => "body"}
  %br
  %input{:type => "submit"}
