require_relative "../test_helper"

context "A Parser" do
  test "should know about paragraphs" do
    sample_text           = File.read(fixture("multi_paragraph_document.md"))

    # NOTE: Is this the behavior we'd expect?
    sample_paragraph_text = File.read(fixture("single_paragraph.md"))
                                .gsub(/\s+/," ")
    parsed_content        = Bookie::Parser.parse(sample_text)
   
    assert_equal 8, parsed_content.length

    actual_paragraph      = parsed_content[4]
    actual_paragraph_text = actual_paragraph.first

    assert_equal sample_paragraph_text, actual_paragraph_text 
  end

  test "should know about preformatted text" do
    sample_text    = File.read(fixture("preformatted_blocks.md"))
    parsed_content = Bookie::Parser.parse(sample_text)
   
    assert_equal 6, parsed_content.length
  end

  test "should know about section headers" do
    sample_text    = File.read(fixture("document_with_headings.md"))
    parsed_content = Bookie::Parser.parse(sample_text)

    assert_equal 17, parsed_content.length

    actual_heading      = parsed_content[2]
    actual_heading_text = actual_heading.contents

    assert_equal "Continuations are Evil?", actual_heading_text
  end
end
