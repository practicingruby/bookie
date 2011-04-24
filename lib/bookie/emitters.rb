module Bookie
  module Emitters
    class Null
      def build_paragraph(paragraph)
      end
    end

    class HTML

      def initialize
        @output = ""
      end

      def build_paragraph(paragraph)
        @output << "<p>#{paragraph.children.first}</p>"
      end

      def render
        "<html><body>#{@output}</body></html>"
      end
    end

    class PDF      
      include Prawn::Measurements

      def initialize
        @document    = new_prawn_document
        @paragraphs  = []
      end

      def build_paragraph(paragraph)
        @paragraphs << paragraph.children.first.gsub(/\s+/," ")
      end

      def render
        @document.text(@paragraphs.join("\n\n"), align: :justify, size: 10)
        @document.render
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
