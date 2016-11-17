require 'spec_helper'

describe 'Yt::Channel#ad_impressions', :account do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given my own channel' do
    let(:attrs) { $channel_attrs }

    it 'returns the total views of the channel limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.views).to be_a Hash
      expect(channel.views[:total]).to be_an Integer
    end
  end
end
