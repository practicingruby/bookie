# coding: UTF-8

module Bookie
  module Emitters
    class Null
      def build_paragraph(paragraph)
      end

      def build_raw_text(raw_text)
      end
      
      def build_section_heading(header)
      end

      def build_list(content)
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

      def build_section_heading(header)
        @body << "<h2>#{header.contents}</h2>"
      end

      def build_list(list)
        list_elements = list.contents.map { |li| "<li>#{li}</li>" }.join
        @body << "<ul>"+list_elements+"</ul>"
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

    class PDF      
      include Prawn::Measurements

      def initialize(params)
        @document    = new_prawn_document
        @document.extend(Prawn::Measurements)

        register_fonts
        render_header(params)
      end

      def build_list(list)
        items = list.contents

        draw do
          font("serif", :size => 9) do
            items.each do |li|
              li_text = li.gsub(/\s+/," ")

              group do
                float { text "•" }
                indent(in2pt(0.15)) do
                  text li_text,
                    inline_format: true,
                    leading: 2
                end
              end

              move_down in2pt(0.05)
            end
          end

          move_down in2pt(0.05)
        end
      end

      def build_section_heading(section_text)
        draw do
          start_new_page unless cursor > in2pt(0.4)

          move_down in2pt(0.1)

          float do
            font("sans", :style => :bold, :size => 14) do
              text(section_text.contents.strip)
            end
          end
        
          move_down in2pt(0.3)
        end
      end

      def build_paragraph(paragraph)
        draw do
          font("serif", size: 9) do
            text(paragraph.contents.strip, align: :justify, leading: 2)
          end
          move_down in2pt(0.1)
        end
      end

      def build_raw_text(raw_text)
        sanitized_text = raw_text.contents.gsub(" ", Prawn::Text::NBSP).strip

        draw do
          font("mono", size: 8) do
            text sanitized_text            
            move_down in2pt(0.1)
          end
        end
      end

      def render(params)
        @document.render_file(params[:file])
      end

      def render_header(params)
        draw do
          font("sans") do
            text "<b>#{params[:header]}</b>", 
              size: 12, align: :right, inline_format: true
            stroke_horizontal_rule

            move_down in2pt(0.1)

            text "<b>#{params[:title]}</b>",
              size: 18, align: :right, inline_format: true
              
            move_down in2pt(1.25)
          end
        end
      end

      def register_fonts
        dejavu_path = File.dirname(__FILE__) + "/../../data/fonts/dejavu"

        draw do
          font_families["sans"] = {
            :normal => "#{dejavu_path}/DejaVuSansCondensed.ttf",
            :italic => "#{dejavu_path}/DejaVuSansCondensed-Oblique.ttf",
            :bold => "#{dejavu_path}/DejaVuSansCondensed-Bold.ttf",
            :bold_italic => "#{dejavu_path}/DejaVuSansCondensed-BoldOblique.ttf"
          }

          font_families["mono"] = {
            :normal => "#{dejavu_path}/DejaVuSansMono.ttf",
            :italic => "#{dejavu_path}/DejaVuSansMono-Oblique.ttf",
            :bold => "#{dejavu_path}/DejaVuSansMono-Bold.ttf",
            :bold_italic => "#{dejavu_path}/DejaVuSansMono-BoldOblique.ttf"
          }

          font_families["serif"] = {
            :normal => "#{dejavu_path}/DejaVuSerif.ttf",
            :italic => "#{dejavu_path}/DejaVuSerif-Italic.ttf",
            :bold => "#{dejavu_path}/DejaVuSerif-Bold.ttf",
            :bold_italic => "#{dejavu_path}/DejaVuSerif-BoldItalic.ttf"
          }
        end
      end

      def draw(&block)
        @document.instance_eval(&block)
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
