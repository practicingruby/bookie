module Bookie
  ContentTree      = Struct.new(:children)
  Paragraph        = Struct.new(:children)
  RawText          = Struct.new(:children)
  
  class Parser
    def self.parse(contents, emitter=Bookie::Emitters::Null.new)
      parser = new(contents, emitter)
      parser.document_tree
    end

    attr_reader :document_tree

    def initialize(contents, emitter)
      @emitter = emitter
      generate_document_tree(contents)
    end

    def extract_paragraph(contents)
      paragraph = Paragraph.new([contents.gsub(/\s+/," ")])
      @emitter.build_paragraph(paragraph)
      document_tree.children << paragraph
    end

    def extract_raw_text(contents)
      raw_text = RawText.new([contents])
      @emitter.build_raw_text(raw_text)
      document_tree.children << raw_text      
    end

    private

    def generate_document_tree(contents)
      @document_tree = ContentTree.new([])

      lines = contents.lines.to_a
      mode  = nil

      until lines.empty?
        line = lines.shift
        case
        when mode == nil
          if line[/^ {4,}/] 
            mode = :raw 
            chunk = line[4..-1]
          else 
            mode = :paragraph
            chunk = line
          end
        when mode == :raw
          chunk << (line.chomp.empty? ? "\n" : line[4..-1].to_s)

          if lines.first =~ /^ {0,3}\S/
            mode = nil
            extract_raw_text(chunk)
          end
        when mode == :paragraph
          if line.chomp.empty?
            mode = nil 
            extract_paragraph(chunk)
          else
            chunk << line
          end
        end
      end

      case mode
      when :paragraph
        extract_paragraph(chunk)
      when :raw
        extract_raw_text(chunk)
      end
    end
  end
end
