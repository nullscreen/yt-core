require 'spec_helper'

describe 'Yt::Channel’s snippet methods', :server do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: $existing_channel_id} }

    specify 'return all snippet data with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.title).to eq 'Yt Test'
      expect(channel.description).to eq 'A YouTube channel to test the yt gem.'
      expect(channel.published_at).to eq Time.parse('2014-05-02 20:12:57 UTC')
      expect(channel.thumbnail_url).to be_a String
    end
  end

  context 'given an unknown channel ID' do
    let(:attrs) { {id: $unknown_channel_id} }

    specify 'raise Yt::Errors::NoItems' do
      expect{channel.title}.to raise_error Yt::Errors::NoItems
    end
  end
end
