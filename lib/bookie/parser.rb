module Bookie
  Paragraph        = Struct.new(:contents)
  RawText          = Struct.new(:contents)
  
  class Parser
    def self.parse(raw_data, emitter=Bookie::Emitters::Null.new)
      parser = new(raw_data, emitter)
      parser.parsed_content
    end

    attr_reader :parsed_content

    def initialize(raw_data, emitter)
      @emitter        = emitter
      @parsed_content = []

      parse_contents(raw_data)
    end

    def extract_paragraph(paragraph_text)
      paragraph = Paragraph.new(paragraph_text.gsub(/\s+/," "))
      @emitter.build_paragraph(paragraph)
      parsed_content << paragraph
    end

    def extract_raw_text(contents)
      raw_text = RawText.new(contents)
      @emitter.build_raw_text(raw_text)
      parsed_content << raw_text      
    end

    private

    def parse_contents(raw_data)
      lines = raw_data.lines.to_a
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
