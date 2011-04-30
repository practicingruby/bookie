module Bookie
  module Emitters
    class EPUB < HTML
      def self.extension
        ".epub"
      end

      def render(params)
        t = Tempfile.new(params[:file])
        t << %{<?xml version="1.0" encoding="UTF-8"?>
               <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" 
                "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
                   <head>
                   <style type="text/css">
                    pre { font-size: 1.1em }
                  </style>
                  </head>
                  <body><h1>#{params[:title]}</h1>#{@body}</body>
                </html>
        }
        t.close
        FileUtils.mv(t.path, "#{t.path}.html")

        epub = EeePub.make do
          title       params[:title]
          identifier  '', :scheme => 'URL'
          uid         ''

          files [File.expand_path("#{t.path}.html")]
        end

        epub.save(params[:file])
      end
    end
  end
end
