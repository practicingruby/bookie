require_relative "../test_helper"

context "A Parser" do
  test "should know about paragraphs" do
    sample_text      = File.read(fixture("multi_paragraph_document.md"))

    # NOTE: Is this the behavior we'd expect?
    sample_paragraph = File.read(fixture("single_paragraph.md")).chomp

    tree = Bookie::Parser.parse(sample_text)
   
    assert_equal 8, tree.children.length

    assert_equal sample_paragraph, tree.children[4]
  end
end
