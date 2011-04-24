require_relative "../lib/bookie"
Prawn.debug = true

file = "#{File.dirname(__FILE__)}/../test/fixtures/multi_paragraph_document.md"

pdf_document = Bookie::Document.new(file, Bookie::Emitters::PDF.new)

File.open("output.pdf", "w") do |f| 
  f << pdf_document.render(header: "Majestic Sea Creature Blog", 
                           title: "Why does RbMU exist?")
end
