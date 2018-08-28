require 'nokogiri'
require 'open-uri'
require 'pry'
require 'awesome_print'
require_relative 'BorderPointParser'


html = File.read("hungary_i.html")
doc = Nokogiri::HTML(html)
bord_point_pars = BorderPointParser.new(doc).call
puts bord_point_pars