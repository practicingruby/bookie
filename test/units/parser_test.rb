require_relative "../test_helper"

context "A Parser" do
  test "should know about paragraphs" do
    sample_text           = File.read(fixture("multi_paragraph_document.md"))

    # NOTE: Is this the behavior we'd expect?
    sample_paragraph_text = File.read(fixture("single_paragraph.md")).chomp

    tree = Bookie::Parser.parse(sample_text)
   
    assert_equal 8, tree.children.length

    actual_paragraph      = tree.children[4]
    actual_paragraph_text = actual_paragraph.children.first

    assert_equal sample_paragraph_text, actual_paragraph_text 
  end
end
