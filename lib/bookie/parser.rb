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

    def extract_paragraphs(contents)
      contents.split(/\n\n+/).each do |e|
        paragraph = Paragraph.new([e])
        @emitter.build_paragraph(paragraph)
        document_tree.children << paragraph
      end
    end

    private

    def generate_document_tree(contents)
      @document_tree = ContentTree.new([])
      extract_paragraphs(contents)
    end
  end
end
