require 'spec_helper'

describe Yt::Channel do
  subject(:channel) { Yt::Channel.new attrs }
  let(:auth) { Yt::Account.new refresh_token: ENV['YT_ACCOUNT_REFRESH_TOKEN']}

  context 'given my own channel' do
    let(:attrs) { {id: ENV['YT_ACCOUNT_CHANNEL_ID'], auth: auth} }

    it 'returns the total views of the channel limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.with('accounts.google.com', 443, use_ssl: true).and_call_original
      expect(Net::HTTP).to receive(:start).once.with('www.googleapis.com', 443, use_ssl: true).and_call_original

      expect(channel.views).to be_a Hash
      expect(channel.views[:total]).to be_an Integer
    end
  end
end
