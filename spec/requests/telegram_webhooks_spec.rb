RSpec.describe TelegramWebhooksController, telegram_bot: :rails do

  it 'shows usage of basic matchers' do
  # The most basic one is #make_telegram_request(bot, endpoint, params_matcher)
  expect { dispatch_command(:start) }.
      to make_telegram_request(bot, :sendMessage, hash_including(text: 'msg text'))

  # There are some shortcuts for dispatching basic updates and testing responses.
  expect { dispatch_message('Hi') }.to send_telegram_message(bot, /msg regexp/, some: :option)
end

describe '#start!' do
  subject { -> { dispatch_command :start } }
  # Using built in matcher for `respond_to`:
  it { should respond_with_message "Набридло чекати в чергах на кордоні? Тоді я тобі доможу \u{1F609}\n  Вибери напрямок  куди прямуєш" }
end

# There is context for callback queries with related matchers,
# use :callback_query tag to include it.
describe '#hey_callback_query', :callback_query do
  let(:data) { "hey:#{name}" }
  let(:name) { 'Vlad' }
  it { should answer_callback_query('Hey Vlad') }
  it { should edit_current_message :text, text: 'Done' }
end
end
