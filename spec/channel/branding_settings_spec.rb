require 'spec_helper'

describe 'Yt::Channel’s branding settings methods', :server do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: $existing_channel_id} }

    specify 'return all branding settings data with one HTTP call', requests: 1 do
      expect(channel.banner_image_url).to be_a String
      expect(channel.keywords).to match_array ['YouTube', 'channel', 'test']
      expect(channel.unsubscribed_trailer).to eq 'gknzFj_0vvY'
      expect(channel.featured_channels_title).to eq 'Public featured channels'
      expect(channel.featured_channels_urls).to eq %w(UCxO1tY8h1AhOz0T4ENwmpow)
    end
  end

  context 'given an unknown channel ID' do
    let(:attrs) { {id: $unknown_channel_id} }

    specify 'raise Yt::NoItemsError' do
      expect{channel.title}.to raise_error Yt::NoItemsError
    end
  end
end
