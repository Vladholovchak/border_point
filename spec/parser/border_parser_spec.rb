RSpec.describe 'BorderParser' do
  before do
    html = File.read(File.join(File.dirname(__FILE__), '../fixtures/hungary_i.html'))
    doc = Nokogiri::HTML(html)
    @parser = BorderParser.new(doc)
  end

  describe '#call' do
    it 'returns parsed border from page' do
      subject = @parser.call
      expect(subject.count).to eq(5)
    end
  end
end
