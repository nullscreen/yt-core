require 'spec_helper'

describe 'Yt::Channel’s branding settings methods', :server do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: $existing_channel_id} }

    specify 'return all branding settings data with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.banner_image_url).to be_a String
    end
  end

  context 'given an unknown channel ID' do
    let(:attrs) { {id: $unknown_channel_id} }

    specify 'raise Yt::Errors::NoItems' do
      expect{channel.title}.to raise_error Yt::Errors::NoItems
    end
  end
end
