require_relative "../lib/bookie"
Prawn.debug = true

file = "#{File.dirname(__FILE__)}/../test/fixtures/preformatted_blocks.md"

pdf_document = Bookie::Document.new(file, Bookie::Emitters::PDF.new)

pdf_document.render(header: "Practicing Ruby: Issue #1", 
                    title:  "Ruby's Method Lookup Path",
                    file:   "output.pdf")

html_document = Bookie::Document.new(file, Bookie::Emitters::HTML.new)

html_document.render(title:  "Ruby's Method Lookup Path",
                     file:   "output.html")

mobi_document = Bookie::Document.new(file, Bookie::Emitters::MOBI.new)

mobi_document.render(title:  "Ruby's Method Lookup Path",
                     file:   "output.mobi")

epub_document = Bookie::Document.new(file, Bookie::Emitters::EPUB.new)

epub_document.render(title:  "Ruby's Method Lookup Path",
                     file:   "output.epub")
