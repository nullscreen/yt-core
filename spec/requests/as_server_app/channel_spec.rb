require 'spec_helper'

describe Yt::Models::Channel do
  subject(:channel) { Yt::Models::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: 'UCwCnUcLcb9-eSrHa_RQGkQQ'} }

    it 'returns valid data' do
      expect(channel.title).to eq 'Yt Test'
      expect(channel.description).to eq 'A YouTube channel to test the yt gem.'
    end
  end
end
