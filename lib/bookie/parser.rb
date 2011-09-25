module Bookie
  Paragraph        = Struct.new(:contents)
  RawText          = Struct.new(:contents)
  SectionHeading   = Struct.new(:contents)
  List             = Struct.new(:contents)
  NormalText       = Struct.new(:contents)
  CodeText         = Struct.new(:contents)
  
  class Parser < Redcarpet::Render::Base

    attr_reader :parsed_content

    def initialize(emitter=Bookie::Emitters::Null.new)
      @emitter        = emitter
      @parsed_content = []

      super()
    end

    def header(text, header_level)
      flush_paragraph
      extract_section_heading(text)
      text
    end

    def paragraph(text)
      flush_paragraph
      @paragraph = text
      text
    end

    def block_code(code, language)
      flush_paragraph
      extract_raw_text(code)
      code
    end

    def list(contents, list_type)
      flush_paragraph
      extract_list(contents.split("\n"))
      contents
    end

    def list_item(text, list_type)
      @paragraph = nil
      text + "\n"
    end

    def doc_footer
      flush_paragraph
    end

  private
    def flush_paragraph
      if @paragraph
        extract_paragraph(@paragraph) 
        @paragraph = nil 
      end
    end

    def extract_inlines(paragraph_text)
      scanner = StringScanner.new(paragraph_text)
      modes   = [NormalText, CodeText].cycle
      output  = []

      current_mode = modes.next
      current_mode = modes.next if scanner.scan(/`/)

      until scanner.eos?
        output << current_mode.new(scanner.scan(/[^`]+/m))
        current_mode = modes.next if scanner.scan(/`/)
      end

      output
    end

    def extract_paragraph(paragraph_text)
      text_segments = extract_inlines(paragraph_text.gsub(/\s+/," "))
      paragraph = Paragraph.new(text_segments)
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
      list = List.new(contents)
      @emitter.build_list(list)
      parsed_content << list
    end
  end
end
