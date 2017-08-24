RSpec.configure do |config|
  keys = %w(CLIENT_ID CLIENT_SECRET REFRESH_TOKEN)

  if keys.all?{|key| ENV["YT_ACCOUNT_#{key}"]}
    config.before :all, account: true do
      Yt.configuration.client_id = ENV['YT_ACCOUNT_CLIENT_ID']
      Yt.configuration.client_secret = ENV['YT_ACCOUNT_CLIENT_SECRET']
      Yt.configuration.api_key = nil
      Yt.configuration.refresh_token = ENV['YT_ACCOUNT_REFRESH_TOKEN']
      Yt.configuration.access_token = nil
      $own_channel = Yt::Channel.mine
    end


  else
    puts "Skipping :account tests"
    config.filter_run_excluding account: true
  end
end
