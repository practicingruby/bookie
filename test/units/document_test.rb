require_relative "../test_helper"

context "A Document" do
  test "should be parsed into an array of contents" do
    sample_text = fixture("multi_paragraph_document.md")
    document    = Bookie::Document.new(sample_text)

    refute document.contents.empty?, "contents should not be empty"
  end
end
