require 'spec_helper'

describe 'Yt::Video#inspect' do
  subject(:channel) { Yt::Video.new attrs }

  context 'given any channel ID' do
    let(:attrs) { {id: 'abc123def456gh'} }

    specify 'prints out a compact version of the object' do
      expect(channel.inspect).to eq '#<Yt::Video @id=abc123def456gh>'
    end
  end
end
