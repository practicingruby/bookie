require_relative "../lib/bookie"
Prawn.debug = true

file = "#{File.dirname(__FILE__)}/../test/fixtures/preformatted_blocks.md"

pdf_document = Bookie::Document.new(file, Bookie::Emitters::PDF.new)

File.open("output.pdf", "w") do |f| 
  f << pdf_document.render(header: "Practicing Ruby: Issue #1", 
                           title:  "Ruby's Method Lookup Path")
end
