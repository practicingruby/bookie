module Bookie
  Paragraph        = Struct.new(:contents)
  RawText          = Struct.new(:contents)
  SectionHeading   = Struct.new(:contents)
  List             = Struct.new(:contents)
  
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

    def extract_section_heading(contents)
      header = SectionHeading.new(contents.chomp)
      @emitter.build_section_heading(header)
      parsed_content << header
    end

    def extract_list(contents)
      list = List.new(contents.map { |e| e.chomp })
      @emitter.build_list(list)
      parsed_content << list
    end

    private

    def parse_contents(raw_data)
      lines = raw_data.lines.to_a
      mode  = nil

      until lines.empty?
        line = lines.shift
        case
        when mode == nil
          case line
          when /^## /
            extract_section_heading(line[3..-1])
          when /^ {4,}/
            mode = :raw 
            chunk = line[4..-1]
          when /^\* /
            mode   = :list
            chunk  = [line[2..-1]]
          else 
            mode = :paragraph
            chunk = line
          end
        when mode == :raw
          chunk << (line.strip.empty? ? "\n" : line[4..-1].to_s)

          if lines.first =~ /^ {0,3}\S/
            mode = nil
            extract_raw_text(chunk)
          end
        when mode == :list
          chunk << line[2..-1].to_s unless line.strip.empty?

          if lines.first.to_s.strip.length > 0 && lines.first !~ /^\*/
            mode = nil
            extract_list(chunk)
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
      when :list
        extract_list(chunk)
      end
    end
  end
end
