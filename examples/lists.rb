require_relative "../lib/bookie"
Prawn.debug = true

file = "#{File.dirname(__FILE__)}/../test/fixtures/lists.md"

pdf_document = Bookie::Document.new(file, Bookie::Emitters::PDF.new(
  header: "Ruby Mendicant University", title:  "Project Guidelines"))

pdf_document.render(file: "output.pdf")

html_document = Bookie::Document.new(file, Bookie::Emitters::HTML.new)

html_document.render(title:  "Project Guidelines",
                     file:   "output.html")

mobi_document = Bookie::Document.new(file, Bookie::Emitters::MOBI.new)

mobi_document.render(title:  "Project Guidelines",
                     file:   "output.mobi")

epub_document = Bookie::Document.new(file, Bookie::Emitters::EPUB.new)

epub_document.render(title:  "Project Guidelines",
                     file:   "output.epub")
