module Bookie
  module Emitters
    class Null
      def build_paragraph(paragraph)
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
        @paragraphs << paragraph.children.first.gsub(/\s+/," ")
      end

      def render(params)
        render_header(params)
        @document.text(@paragraphs.join("\n\n"), align: :justify, size: 10)
        @document.render
      end

      def render_header(params)
        @document.instance_eval do
          text "<b>Chapter #{params[:chapter_number]}</b>", 
            size: 12, align: :right, inline_format: true
          stroke_horizontal_rule

          move_down in2pt(0.1)

          text "<b>#{params[:chapter_title]}</b>",
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
