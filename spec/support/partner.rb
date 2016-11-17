RSpec.configure do |config|
  config.before :all, partner: true do
    Yt.configuration.api_key = ''
    Yt.configuration.client_id = ENV['YT_PARTNER_CLIENT_ID']
    Yt.configuration.client_secret = ENV['YT_PARTNER_CLIENT_SECRET']

    content_owner = Yt::ContentOwner.new id: ENV['YT_PARTNER_ID'], refresh_token: ENV['YT_PARTNER_REFRESH_TOKEN']
    $content_owner_attrs = {id: content_owner.id, access_token: content_owner.access_token}
    $channel_attrs = {id: ENV['YT_PARTNER_CHANNEL_ID'], auth: content_owner}
  end
end
