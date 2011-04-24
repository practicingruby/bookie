module Bookie
  class Document
    def initialize(filename, parser=Bookie::Parser)
      @parser   = parser
      @contents = parser.parse(File.read(filename))
    end

    attr_reader :contents, :parser
  end
end
