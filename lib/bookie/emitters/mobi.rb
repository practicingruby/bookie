module Bookie
  module Emitters
    class MOBI < HTML
      def render(params)
        t = Tempfile.new(params[:file])
        t << %{
          <html>
            <head>
              <style type="text/css">
                h1 { margin-bottom: 3em; font-size: xx-large }
                h2 { font-size: large }
                p { margin-bottom: 1.1em; text-indent: 0 }
                pre { font-size: xx-small }
                li { margin-bottom: 1.1em }
                ul { margin-top: 0em; margin-bottom: 0em;}
              </style>
            </head>
            <body><h1>#{params[:title]}</h1>#{@body}</body>
          </html>
        }
        t.close
        FileUtils.mv(t.path, "#{t.path}.html")

        `kindlegen #{t.path+'.html'} -o #{params[:file]}`
        FileUtils.mv("#{Dir.tmpdir}/#{params[:file]}", ".")
      end
    end
  end
end
