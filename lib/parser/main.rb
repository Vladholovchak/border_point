require 'pry'
require 'awesome_print'
require_relative 'country_parser'
require 'redis'

a = Redis.new.get("pl")
ob = JSON.parse(a)
arr = ob["input"]
hash = arr[1]



def beautifull_output(hash)

  name = "Назва пункту\t\t\t\t\t\t Час очікування машини"
  text = hash["name"]
  a = text.scan(/\b[п][у].*/)
 p a.class
  b = a.join()
  p b.class
  puts b

end

flags = { :hu => "2",
          'pl' => "\u{1F1EC}\u{1F1E7}",
          'md' => "\u{1F1E7}\u{1F3E4}",
          'ro' => "\u{1F1E7}\u{1F3E4}",
          'sk' => "\u{1F1E7}\u{1F3E4}",
          'by' => "\u{1F1E7}\u{1F3E4}",
          'ru' => "\u{1F1E7}\u{1F3E4}",
          'kr' => "\u{1F1FA}\u{1F1E6}",}

data = 'hu'
p flags[data]

