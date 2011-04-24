module Bookie
  module Emitters
    class Null
      def build_paragraph(paragraph)
      end

      def build_raw_text(paragraphs)
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
        @paragraphs << { text: paragraph.children.first.strip }
      end

      def build_raw_text(raw_text)
        sanitized_text = raw_text.children.first.
                                  gsub(" ", Prawn::Text::NBSP).strip
                                  
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
        @document.render
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
