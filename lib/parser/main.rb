require 'nokogiri'
require 'open-uri'
require 'pry'
require 'awesome_print'
require_relative 'border_parser'

html = File.read(File.join(File.dirname(__FILE__), 'hungary_i.html'))
doc = Nokogiri::HTML(html)
bord_point_pars = BorderParser.new(doc).call
p = bord_point_pars
puts p[1]


