require_relative "../lib/bookie"

fixture_dir = "#{File.dirname(__FILE__)}/../test/fixtures/"

book = Bookie::Book.new("Basic Features of Bookie")
book.chapter "A single paragraph", "#{fixture_dir}/single_paragraph.md"
book.chapter "Multiple paragraphs", "#{fixture_dir}/multi_paragraph_document.md"
book.chapter "Preformatted text blocks", "#{fixture_dir}/preformatted_blocks.md"
book.chapter "Section headings", "#{fixture_dir}/document_with_headings.md"
book.chapter "Unordered lists", "#{fixture_dir}/lists.md"
book.chapter "Inline Formatting", "#{fixture_dir}/inline_formatting.md"

book.render("bookie-basic-feature", [Bookie::Emitters::PDF.new,
                                     Bookie::Emitters::EPUB.new,
                                     Bookie::Emitters::MOBI.new,
                                     Bookie::Emitters::HTML.new])
