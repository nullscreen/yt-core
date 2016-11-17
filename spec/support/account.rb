RSpec.configure do |config|
  config.before :all, account: true do
    Yt.configuration.api_key = ''
    Yt.configuration.client_id = ENV['YT_ACCOUNT_CLIENT_ID']
    Yt.configuration.client_secret = ENV['YT_ACCOUNT_CLIENT_SECRET']

    account = Yt::Account.new refresh_token: ENV['YT_ACCOUNT_REFRESH_TOKEN']
    $account_attrs = {access_token: account.access_token}
    $channel_attrs = {id: ENV['YT_ACCOUNT_CHANNEL_ID'], auth: account}
  end
end
