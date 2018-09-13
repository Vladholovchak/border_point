require_relative 'border_parser'
require 'nokogiri'
require 'open-uri'
require 'redis'

class CountriesParser
  attr_reader :country_info
  COUNTRIES_CODES = %w[md ro hu sk pl by ru kr].freeze
  def initialize; end

  def call
    redis = Redis.new(host: 'localhost', port: 6379)
    COUNTRIES_CODES.each do |country_code|
      a = parse_country(country_code)
      redis.set(country_code, a)
    end
    # for test keys in DB
    @country_info = redis.get("pl")
  end

  private

  def make_url(country, direction)
    "http://kordon.sfs.gov.ua/uk/home/countries/#{country}/#{direction}"
  end

  def parse_country(country_code)
    input_info = parse_direction('i', country_code)
    output_info = parse_direction('o', country_code)
    { country_code: country_code, input: input_info, output: output_info }
  end

  def parse_direction(direction, country_code)
    html = make_url(country_code, direction)
    page = Nokogiri::HTML(open(html))
    BorderParser.new(page).call
  end
end
