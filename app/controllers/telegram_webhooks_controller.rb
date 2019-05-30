class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  use_session!

  def start!(*)
    save_context :country
    greetings = "Набридло чекати в чергах на кордоні? Тоді я тобі доможу \u{1F609}\n <b> Вибери країну </b> куди прямуєш"
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
      direction_select = data
      #direction = locations.select { |e| e[:direction_select] }.first
     # session[:direction_id] = direction['id']
      respond_with :message, text: 'Виберіть напрямок', reply_markup: {
      inline_keyboard: [
          [
              {text: ('Угорщина'), callback_data: 'hu'},
              {text: ('Польща'), callback_data: 'pl'},
          ]
      ]
      }
  end

  def beautiful_output
    direction = session.delete(:direction)
    country = session.delete(:country)
    p direction
    p country
    a = Redis.new.get(country)
    ob = JSON.parse(a)
    arr = ob[direction]
    flags = { 'hu' => "\u{1F1ED}\u{1F1FA}",
              'pl' =>  "\u{1F1F5}\u{1F1F1}",
              'md' => "\u{1F1F2}\u{1F1E9}",
              'ro'=> "\u{1F1F7}\u{1F1F4}",
              'sk' => "\u{1F1F8}\u{1F1F0}",
              'by'=> "\u{1F1E7}\u{1F1FE}",
              'ru' =>"\u{1F1F7}\u{1F1FA}",
              'kr'=>  "\u{1F1FA}\u{1F1E6}",}
    output = []
    flag = flags[country]
    arr.each do |hash|
      data_name =  hash["name"].scan(/\b[пП][у].*/)
      data_time = hash["time_car"]
      item = "#{flag} \u{1F3E4} #{data_name[0]}\n\u{1F551} #{data_time}\n\n"
      output.push(item)
    end
    str_out = output.join()
    return str_out
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
