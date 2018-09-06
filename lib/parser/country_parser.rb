require_relative 'border_parser'
require 'nokogiri'
require 'open-uri'

class CountriesParser
  COUNTRIES_CODES = %w[md ro hu sk pl by ru kr].freeze

  def initialize; end

  def making_url(country, direction)
    "http://kordon.sfs.gov.ua/uk/home/countries/#{country}/#{direction}"
  end

  def call
    COUNTRIES_CODES.each do |country_code|
      parse_country(country_code)
    end
  end

private

  def parse_country(country_code)
    input_info = parse_direction('i', country_code)
    output_info = parse_direction('o', country_code)
    { country_code: country_code, input: input_info, output: output_info }
  end

  def parse_direction(direction, country_code)
    html = making_url(country_code, direction)
    page = Nokogiri::HTML(open(html))
    BorderParser.new(page).call
  end

end
