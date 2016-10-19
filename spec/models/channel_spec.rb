require 'spec_helper'

describe Yt::Channel do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given any channel ID' do
    let(:attrs) { {id: '123'} }

    specify 'prints out a compact version of the object' do
      expect(channel.inspect).to eq '#<Yt::Models::Channel @id=123>'
    end
  end
end
