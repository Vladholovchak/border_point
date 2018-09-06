require 'nokogiri'
require 'parser'

describe '#call' do
  let(:html) { File.read(File.join(File.dirname(__FILE__), '../fixtures/hungary_i.html')) }
  let(:doc) { Nokogiri::HTML(html) }
  subject { BorderParser.new(doc) }
  it 'returns parsed border from page' do
    container = subject.call
    expect(container.count).to eq(5)
  end
  context 'point, car, truck' do
    let(:point) { 'Митний пост "Лужанка", пункт пропуску "Лужанка – Берегшурань"' }
    let(:car_time) { '00:31' }
    let(:truck_time) { 'Інформація відсутня' }
    it 'returns parsed border from page' do
      container = subject.call
      tested = container[1]
      origin = [point, car_time, truck_time]
      expect(tested.values).to match origin
    end
  end
end
