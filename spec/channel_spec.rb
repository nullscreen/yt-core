require 'spec_helper'

describe Yt::Channel do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given any channel ID' do
    let(:attrs) { {id: 'UC1234567890abcdefghij'} }

    specify 'prints out a compact version of the object' do
      expect(channel.inspect).to eq '#<Yt::Channel @id=UC1234567890abcdefghij>'
    end
  end
end
