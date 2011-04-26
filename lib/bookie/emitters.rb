module Bookie
  module Emitters
    class Null
      def build_paragraph(paragraph)
      end

      def build_raw_text(raw_text)
      end
    end

    class HTML
      def initialize
        @body = ""
      end

      attr_reader :body

      def build_paragraph(paragraph)
        @body << "<p>#{paragraph.contents}</p>"
      end

      def build_raw_text(raw_text)
        @body << "<pre>#{raw_text.contents}</pre>"
      end

      def render(params)
        File.open(params[:file], "w") do |file|
          file << %{
            <html>
               <body><h1>#{params[:title]}</h1>#{@body}</body>
            </html>
          }
        end
      end
    end

    class EPUB < HTML
      def render(params)
        t = Tempfile.new(params[:file])
        t << %{<?xml version="1.0" encoding="UTF-8"?>
               <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" 
                "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
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

    class MOBI < HTML
      def render(params)
        t = Tempfile.new(params[:file])
        t << %{
          <html>
            <head>
              <style type="text/css">
                h1 { margin-bottom: 3em }
                p { margin-bottom: 1.1em; text-indent: 0 }
                pre { font-size: xx-small }
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

    class PDF      
      include Prawn::Measurements

      def initialize
        @document    = new_prawn_document
        @document.extend(Prawn::Measurements)
        @paragraphs  = []
      end

      def build_paragraph(paragraph)
        @paragraphs << { text: paragraph.contents.strip }
      end

      def build_raw_text(raw_text)
        sanitized_text = raw_text.contents.gsub(" ", Prawn::Text::NBSP).strip
                                 
        @paragraphs << { text: sanitized_text, 
                         font: "Courier",
                         size: 8               }
      end

      def render(params)
        render_header(params)
        
        # there needs to be a better way
        @paragraphs = @paragraphs.reduce([]) { |s,r| s + [r, { text: "\n\n" }] }
        @paragraphs.pop

        @document.formatted_text(@paragraphs, align: :justify, size: 10)
        @document.render_file(params[:file])
      end

      def render_header(params)
        @document.instance_eval do
          text "<b>#{params[:header]}</b>", 
            size: 12, align: :right, inline_format: true
          stroke_horizontal_rule

          move_down in2pt(0.1)

          text "<b>#{params[:title]}</b>",
            size: 18, align: :right, inline_format: true
            
          move_down in2pt(1.25)
        end
      end

      private 

      def new_prawn_document
        Prawn::Document.new( top_margin:    in2pt(0.75),
                             bottom_margin: in2pt(1),
                             left_margin:   in2pt(1),
                             right_margin:  in2pt(1),
                             page_size:     [in2pt(7.0), in2pt(9.19)] )
      end
    end
  end
end
