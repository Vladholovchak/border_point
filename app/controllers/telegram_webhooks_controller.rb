class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  use_session!

  def start!(*)
    save_context :country
    greetings = "Набридло чекати в чергах на кордоні? Тоді я тобі доможу \u{1F609}\n  Вибери напрямок  куди прямуєш"
    respond_with :message, text: greetings,  reply_markup: {
        inline_keyboard: [
            [
                {text: ('в Україну'), callback_data: 'input'},
                {text: ('з України'), callback_data: 'output'},
            ]
        ]
    }
  end

  def country(data)
      respond_with :message, text: 'Вибери країну з якою перетинаєш кордон', reply_markup: {
      inline_keyboard: [
          [
              {text: ("Угорщина \u{1F1ED}\u{1F1FA}"), callback_data: 'hu'},
              {text: ("Польща \u{1F1F5}\u{1F1F1}"), callback_data: 'pl'}],
              [{text: ("Молдова \u{1F1F2}\u{1F1E9}"), callback_data: 'md'},
              {text: ("Румунія \u{1F1F7}\u{1F1F4}"), callback_data: 'ro'}],
              [{text: ("Словаччина \u{1F1F8}\u{1F1F0}"), callback_data: 'sk'},
              {text: ("Білорусь \u{1F1E7}\u{1F1FE}"), callback_data: 'by'}],
              [{text: ("Росія \u{1F1F7}\u{1F1FA}"), callback_data: 'ru'},
              {text: ("АР Крим \u{1F1FA}\u{1F1E6}"), callback_data: 'kr'}]
      ]
      }
  end

  def beautiful_output
    direction = session.delete(:direction)
    country = session.delete(:country)
    redis = Redis.new(ENV['REDIS_URL'])
    redis.get(country)
    ob = JSON.parse(redis)
    arr = ob[direction]
    arr.sort_by!{ |t| t["time_car"] }
    flags = { 'hu' => "\u{1F1ED}\u{1F1FA}",
              'pl' =>  "\u{1F1F5}\u{1F1F1}",
              'md' => "\u{1F1F2}\u{1F1E9}",
              'ro'=> "\u{1F1F7}\u{1F1F4}",
              'sk' => "\u{1F1F8}\u{1F1F0}",
              'by'=> "\u{1F1E7}\u{1F1FE}",
              'ru' =>"\u{1F1F7}\u{1F1FA}",
              'kr'=>  "\u{1F1FA}\u{1F1E6}",
              'ua'=>  "\u{1F1FA}\u{1F1E6}"}
    output = []
    flag = flags[country]
    arr.each do |hash|
      data_name =  hash["name"].scan(/\b[пП][у].*/)
      data_time = hash["time_car"]
      item = "#{flag} \u{1F3E4} #{data_name[0]}\n\u{1F551} #{data_time}\n\n"
      output.push(item)
    end
    str_out = output.join
    if direction == 'input'
      direction_flag = "#{flags['ua']} -> #{flag}"
    else
      direction_flag = "#{flag} -> #{flags['ua']}"
    end
    return direction_flag + "\n\n" + str_out
  end


  def final(data)
    respond_with :message, text: beautiful_output
  end


  def callback_query(data)
    if data.match(/^\D{2}$/)
      answer_callback_query('.country')
      session[:country] = data
      final(data)
    else
      answer_callback_query('.direction')
      session[:direction] = data
      country(data)
    end
  end
end
