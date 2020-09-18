require 'spec_helper'

describe 'Yt::Channel’s snippet methods', :server do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: $existing_channel_id} }

    specify 'return all snippet data with one HTTP call', requests: 1 do
      expect(channel.title).to eq 'Yt Test'
      expect(channel.description).to eq 'A YouTube channel to test the yt gem.'
      expect(channel.published_at).to eq Time.parse('2014-05-02 20:12:57 UTC')
      expect(channel.thumbnail_url).to be_a String
    end
  end

  context 'given a channel ID without a custom URL' do
    let(:attrs) { {id: $existing_channel_id} }
    let(:url) { "https://www.youtube.com/channel/#{$existing_channel_id}" }

    specify 'uses the canonical URL as the vanity URL' do
      expect(channel.custom_url).to be_nil
      expect(channel.vanity_url).to eq url
    end
  end

  context 'given a channel ID with a custom URL' do
    let(:attrs) { {id: $custom_url_channel_id} }

    specify 'uses the custom URL as the vanity URL' do
      expect(channel.custom_url).to eq 'nbc'
      expect(channel.vanity_url).to eq 'https://www.youtube.com/nbc'
    end
  end

  context 'given an unknown channel ID' do
    let(:attrs) { {id: $unknown_channel_id} }

    specify 'raise Yt::NoItemsError' do
      expect{channel.title}.to raise_error Yt::NoItemsError
    end
  end
end
