# spec/moxml/comment_spec.rb
RSpec.describe Moxml::Comment do
  let(:context) { Moxml.new }
  let(:doc) { context.create_document }
  let(:comment) { doc.create_comment("test comment") }

  it "identifies as comment node" do
    expect(comment).to be_comment
  end

  describe "content manipulation" do
    it "gets content" do
      expect(comment.content).to eq("test comment")
    end

    it "sets content" do
      comment.content = "new comment"
      expect(comment.content).to eq("new comment")
    end

    it "handles nil content" do
      comment.content = nil
      expect(comment.content).to eq("")
    end
  end

  describe "serialization" do
    it "wraps content in comment markers" do
      expect(comment.to_xml(pretty: false)).to eq("<!--test comment-->")
    end

    it "escapes double hyphens" do
      comment.content = "test -- comment"
      serialized = comment.to_xml(pretty: false)
      expect(serialized).not_to include("--")
      expect(serialized).to include("test - - comment")
    end

    it "handles special characters" do
      comment.content = "< > & \" '"
      expect(comment.to_xml(pretty: false)).to eq("<!--< > & \" '-->")
    end
  end

  describe "node operations" do
    let(:element) { doc.create_element("test") }

    it "adds to element" do
      element.add_child(comment)
      expect(element.to_xml).to include("<!--test comment-->")
    end

    it "removes from element" do
      element.add_child(comment)
      comment.remove
      expect(element.children).to be_empty
    end

    it "replaces with another node" do
      element.add_child(comment)
      text = doc.create_text("replacement")
      comment.replace(text)
      expect(element.text).to eq("replacement")
    end
  end
end
