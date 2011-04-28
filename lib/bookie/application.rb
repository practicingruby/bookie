require "optparse"

module Bookie
  module Application
    extend self

    def run(*args)
      options = {}

      input = OptionParser.new do |opts|
        opts.on("-n", "--name NAME", "Document name") do |v|
          options[:header] = v
        end

        opts.on("-t", "--title TITLE", "Document title") do |v|
          options[:title] = v
        end
      end.parse!(args).first

      basename = File.basename(input, ".md")

      Bookie::Document.new(input, Bookie::Emitters::PDF.new(options))
                      .render(file: "#{basename}.pdf")
      Bookie::Document.new(input, Bookie::Emitters::MOBI.new)
                      .render({file: "#{basename}.mobi"}.merge(options))
      Bookie::Document.new(input, Bookie::Emitters::EPUB.new)
                      .render({file: "#{basename}.mobi"}.merge(options))
    end
  end
end
