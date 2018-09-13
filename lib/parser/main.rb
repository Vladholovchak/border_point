require 'pry'
require 'awesome_print'
require_relative 'country_parser'
require 'redis'

f = CountriesParser.new
f.call
puts f.country_info

