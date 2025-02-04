RSpec.describe "XPath Examples" do
  let(:context) { Moxml.new }

  describe "XPath querying" do
    let(:doc) do
      context.parse(<<~XML)
        <root xmlns:dc="http://purl.org/dc/elements/1.1/">
          <book id="1">
            <dc:title>First</dc:title>
          </book>
          <book id="2">
            <dc:title>Second</dc:title>
          </book>
        </root>
      XML
    end

    it "finds nodes by XPath" do
      books = doc.xpath("//book")
      expect(books.size).to eq(2)
      expect(books.map { |b| b["id"] }).to eq(["1", "2"])
    end

    it "finds nodes with namespaces" do
      titles = doc.xpath("//dc:title",
                         "dc" => "http://purl.org/dc/elements/1.1/")
      expect(titles.map(&:text)).to eq(["First", "Second"])
    end

    it "finds nodes by attributes" do
      book = doc.at_xpath('//book[@id="2"]')
      expect(book).not_to be_nil
      expect(book.at_xpath(".//dc:title",
                           "dc" => "http://purl.org/dc/elements/1.1/").text).to eq("Second")
    end
  end
end
