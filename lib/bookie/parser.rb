module Bookie
  ContentTree = Struct.new(:children)
  Paragraph   = Struct.new(:children)
  
  class Parser
    def self.parse(contents)
      parser = new(contents)
      parser.document_tree
    end

    attr_reader :document_tree

    def initialize(contents)
      generate_document_tree(contents)
    end

    def extract_paragraphs(contents)
      contents.split(/\n\n+/).each do |e|
        document_tree.children << Paragraph.new([e])
      end
    end

    private

    def generate_document_tree(contents)
      @document_tree = ContentTree.new([])
      extract_paragraphs(contents)
    end
  end
end
