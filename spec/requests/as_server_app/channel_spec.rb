require 'spec_helper'

describe Yt::Models::Channel do
  subject(:channel) { Yt::Models::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: 'UCwCnUcLcb9-eSrHa_RQGkQQ'} }

    it 'returns valid data limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.title).to eq 'Yt Test'
      expect(channel.description).to eq 'A YouTube channel to test the yt gem.'
      expect(channel.thumbnail_url).to include 'photo.jpg'
      expect(channel.published_at).to eq Time.parse('2014-05-02 20:12:57 UTC')
    end
  end

  context 'given an unknown channel ID' do
    let(:attrs) { {id: 'UC-not-a-valid-id-_RQGkQQ'} }

    specify 'accessing its data raises Yt::Errors::NoItems' do
      expect{channel.title}.to raise_error Yt::Errors::NoItems
    end
  end
end
