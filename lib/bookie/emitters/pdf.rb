# coding: UTF-8

module Bookie
  module Emitters
    class PDF      
      include Prawn::Measurements

      def self.extension
        ".pdf"
      end

      def initialize
        @document    = new_prawn_document
        @document.extend(Prawn::Measurements)

        register_fonts
      end

      attr_reader :document

      def start_new_chapter(params)
        @document.save_graphics_state # HACK for what might be a Prawn bug
        @document.start_new_page
        @document.outline.section(params[:title], :destination => @document.page_number)
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
        dejavu_path = File.dirname(__FILE__) + "/../../../data/fonts/dejavu"

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
        Prawn::Document.new( top_margin:         in2pt(0.75),
                             bottom_margin:      in2pt(1),
                             left_margin:        in2pt(1),
                             right_margin:       in2pt(1),
                             page_size:          [in2pt(7.0), in2pt(9.19)],
                             skip_page_creation: true)
      end
    end
  end
end
