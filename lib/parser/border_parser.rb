class BorderParser
  def initialize(doc)
    @doc = doc
  end

  def call
    container = []
    @doc.css('section.countries_table > .container > .countries_table_info > .row > .col-md-12.col-sm-12 >
    .responsive > tbody > tr').each do |tr|
      time_car = tr.css('td:nth-child(2)').text
      time_truck = tr.css('td:nth-child(3)').text
      name = tr.css('td:nth-child(1)').text
      container.push(name: name, time_car: time_car, time_truck: time_truck)
    end
    container
  end
end
