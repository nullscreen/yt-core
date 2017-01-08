require 'spec_helper'

describe 'Yt::Video#canonical_url' do
  subject(:channel) { Yt::Video.new attrs }

  context 'given any channel ID' do
    let(:attrs) { {id: 'abc123def456gh'} }

    specify 'prints out the canonical form of the channel’s URL' do
      expect(channel.canonical_url).to eq 'https://www.youtube.com/watch?v=abc123def456gh'
    end
  end
end
