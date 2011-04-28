require_relative "../lib/bookie"
Prawn.debug = true

file = "#{File.dirname(__FILE__)}/../test/fixtures/document_with_headings.md"

pdf_document = Bookie::Document.new(file, Bookie::Emitters::PDF.new(
  header: "Ruby Best Practices", title:  "Learning From Bad Ideas"))

pdf_document.render(file: "output.pdf")

html_document = Bookie::Document.new(file, Bookie::Emitters::HTML.new)

html_document.render(title:  "Learning From Bad Ideas",
                     file:   "output.html")

mobi_document = Bookie::Document.new(file, Bookie::Emitters::MOBI.new)

mobi_document.render(title:  "Learning From Bad Ideas",
                     file:   "output.mobi")

epub_document = Bookie::Document.new(file, Bookie::Emitters::EPUB.new)

epub_document.render(title:  "Learning From Bad Ideas",
                     file:   "output.epub")

