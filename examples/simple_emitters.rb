require_relative "../lib/bookie"
Prawn.debug = true

test_file = "#{File.dirname(__FILE__)}/../test/fixtures/multi_paragraph_document.md"

html_document = Bookie::Document.new(test_file, Bookie::Emitters::HTML.new)
File.open("output.html", "w") { |f| f << html_document.render }

pdf_document = Bookie::Document.new(test_file, Bookie::Emitters::PDF.new)
File.open("output.pdf", "w") { |f| f << pdf_document.render }
