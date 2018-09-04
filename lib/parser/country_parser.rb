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
    input_html = making_url(country_code, 'i')
    output_html = making_url(country_code, 'o')
    input_page = Nokogiri::HTML(open(input_html))
    output_page = Nokogiri::HTML(open(output_html))
    input  = BorderParser.new(input_page).call
    output = BorderParser.new(output_page).call
    ap input
    ap output

  end

end
