require 'spec_helper'

describe Yt::Channel do
  before(:all) do
    Yt.configuration.api_key = ''
    Yt.configuration.client_id = ENV['YT_PARTNER_CLIENT_ID']
    Yt.configuration.client_secret = ENV['YT_PARTNER_CLIENT_SECRET']
  end

  subject(:channel) { Yt::Channel.new attrs }
  let(:auth) { Yt::ContentOwner.new id: ENV['YT_PARTNER_ID'], refresh_token: ENV['YT_PARTNER_REFRESH_TOKEN']}

  context 'given my own channel' do
    let(:attrs) { {id: ENV['YT_PARTNER_CHANNEL_ID'], auth: auth} }

    it 'returns the total ad impressions of the channel limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.with('accounts.google.com', 443, use_ssl: true).and_call_original
      expect(Net::HTTP).to receive(:start).once.with('www.googleapis.com', 443, use_ssl: true).and_call_original

      expect(channel.ad_impressions).to be_a Hash
      expect(channel.ad_impressions[:total]).to be_an Integer
    end
  end
end
