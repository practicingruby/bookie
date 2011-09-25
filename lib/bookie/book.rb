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

    def render(basename, emitters)
      emitters.each do |emitter|
        markdown = Redcarpet::Markdown.new(Bookie::Parser.new(emitter))
        chapters.each_with_index do |(name, file), i|
          emitter.start_new_chapter(header: "Chapter #{i+1}",
                                    title:  name)
          markdown.render(File.read(file))
        end

        output_file = "#{basename}#{emitter.class.extension}"
        emitter.render(file: output_file)
      end
    end
  end
end
