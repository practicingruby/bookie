module Bookie
  ContentTree = Struct.new(:children)
  Paragraph   = Struct.new(:children)
  
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
      paragraph = Paragraph.new([contents])
      @emitter.build_paragraph(paragraph)
      document_tree.children << paragraph
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
          mode = :paragraph
          chunk = line
        when mode == :paragraph
          if line.chomp.empty?
            mode = nil 
            extract_paragraph(chunk)
          else
            chunk << line
          end
        end
      end

      if mode == :paragraph
        extract_paragraph(chunk)
      end
    end
  end
end
