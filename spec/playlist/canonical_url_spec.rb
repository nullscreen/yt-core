require 'spec_helper'

describe 'Yt::Playlist#canonical_url' do
  subject(:channel) { Yt::Playlist.new attrs }

  context 'given any channel ID' do
    let(:attrs) { {id: 'PL-234567890abcdefgh'} }

    specify 'prints out the canonical form of the channel’s URL' do
      expect(channel.canonical_url).to eq 'https://www.youtube.com/playlist?list=PL-234567890abcdefgh'
    end
  end
end
