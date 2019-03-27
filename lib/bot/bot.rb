require 'telegram/bot'
require 'redis'

token = '629114955:AAEqmDlYGp1PF1W2kRzlTnxrga76PZ93oEo'

def beautifull_output(data)
  a = Redis.new.get(data)
  ob = JSON.parse(a)
  arr = ob["input"]
  flags = { 'hu' => "\u{1F1ED}\u{1F1FA}",
            'pl' =>  "\u{1F1F5}\u{1F1F1}",
           'md' => "\u{1F1F2}\u{1F1E9}",
           'ro'=> "\u{1F1F7}\u{1F1F4}",
           'sk' => "\u{1F1F8}\u{1F1F0}",
           'by'=> "\u{1F1E7}\u{1F1FE}",
           'ru' =>"\u{1F1F7}\u{1F1FA}",
           'kr'=>  "\u{1F1FA}\u{1F1E6}",}
  output = []
  flag = flags[data]
  arr.each do |hash|
    data_name =  hash["name"].scan(/\b[пП][у].*/)
    data_time = hash["time_car"]
    item = "#{flag} \u{1F3E4} #{data_name[0]}\n\u{1F551} #{data_time}\n\n"
    output.push(item)
  end
  str_out = output.join()
  return str_out
end

def send_message(bot,rqst,message, markup)
  bot.api.send_message(chat_id: rqst.from.id, text: message,  reply_markup: markup)
end

answers = [
    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Угорщина', callback_data: 'hu'),
    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Польща', callback_data: 'pl'),
    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Молдова', callback_data: 'md'),
    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Румунія', callback_data: 'ro'),
    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Словаччина', callback_data: 'sk'),
    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Білорусь', callback_data: 'by'),
    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Росія', callback_data: 'ru'),
    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'АР Крим', callback_data: 'kr')
]

greeting = "Набридло чекати в чергах на кордоні? Тоді я тобі доможу\u{1F609}\n<b> Вибери країну </b>куди прямуєш"

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |rqst|
    Thread.start(rqst) do |rqst|

     case rqst

     when Telegram::Bot::Types::Message
       case rqst.text
        when '/start'
         markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: answers)
         bot.api.send_message(chat_id: rqst.from.id, text: greeting, parse_mode: 'HTML' , reply_markup: markup)
        when 'Польща'
         data = 'pl'
         message= beautifull_output(data)
         send_message(bot,rqst, message,markup)
       when 'Угорщина'
         data = 'hu'
         message= beautifull_output(data)
         send_message(bot,rqst, message,markup)
       when 'Молдова'
         data = 'md'
         message= beautifull_output(data)
         send_message(bot,rqst, message,markup)
       when 'Словаччина'
         data = 'sk'
         message= beautifull_output(data)
         send_message(bot,rqst, message,markup)
       when 'Білорусь'
         data = 'by'
         message= beautifull_output(data)
         send_message(bot,rqst, message,markup)
       when 'Росія'
         data = 'ru'
         message= beautifull_output(data)
         send_message(bot,rqst, message,markup)
       when 'АР Крим'
         data = 'kr'
         message= beautifull_output(data)
         send_message(bot,rqst, message,markup)
        else
         bot.api.send_message(chat_id: rqst.from.id, text: "Напишіть /start щоб не стояти в черзі /u{1F697}")
       end
     when Telegram::Bot::Types::CallbackQuery
       message = beautifull_output(rqst.data)
       send_message(bot,rqst, message,markup)
       bot.api.answer_callback_query(callback_query_id: rqst.id)
     end
    end
   end
end
