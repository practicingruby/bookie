module Bookie
  class Document
    def initialize(filename, emitter=Bookie::Emitters::Null.new, parser=Bookie::Parser)
      @emitter  = emitter
      @contents = parser.parse(File.read(filename), emitter)
    end

    attr_reader :emitter, :contents

    def render(*args)
      @emitter.render(*args)
    end
  end
end
