require 'spec_helper'

describe 'Yt::Channel#ad_impressions', :partner do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given my own channel partnered with a network' do
    let(:attrs) { $channel_attrs }

    it 'returns the total ad impressions of the channel limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.ad_impressions).to be_a Hash
      expect(channel.ad_impressions[:total]).to be_an Integer
    end
  end
end
