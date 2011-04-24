require_relative "../test_helper"

context "A Parser" do
  test "should know about paragraphs" do
    sample_text           = File.read(fixture("multi_paragraph_document.md"))

    # NOTE: Is this the behavior we'd expect?
    sample_paragraph_text = File.read(fixture("single_paragraph.md"))
                                .gsub(/\s+/," ")

    tree = Bookie::Parser.parse(sample_text)
   
    assert_equal 8, tree.children.length

    actual_paragraph      = tree.children[4]
    actual_paragraph_text = actual_paragraph.children.first

    assert_equal sample_paragraph_text, actual_paragraph_text 
  end

  test "should know about preformatted text" do
    sample_text = File.read(fixture("preformatted_blocks.md"))

    tree = Bookie::Parser.parse(sample_text)
   
    assert_equal 7, tree.children.length
  end

end
