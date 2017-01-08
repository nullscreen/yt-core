require 'spec_helper'

describe 'Yt::Channel#canonical_url' do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given any channel ID' do
    let(:attrs) { {id: 'UC1234567890abcdefghij'} }

    specify 'prints out the canonical form of the channel’s URL' do
      expect(channel.canonical_url).to eq 'https://www.youtube.com/channel/UC1234567890abcdefghij'
    end
  end
end
