module Bookie
  class Book
    def initialize(name)
      @name     = name
      @chapters = [] 
    end

    attr_reader :name, :chapters
      
    def chapter(name, file)
      chapters << [name, file]
    end

    def render(basename, emitter)
      chapters.each_with_index do |(name, file), i|
        emitter.start_new_chapter(header: "Chapter #{i+1}",
                                  title:  name)
        Bookie::Parser.parse(File.read(file), emitter)
        output_file = "#{basename}#{emitter.class.extension}"
        emitter.render(file: output_file)
      end
    end
  end
end
