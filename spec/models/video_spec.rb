require 'spec_helper'

describe Yt::Video do
  subject(:video) { Yt::Video.new attrs }

  context 'given any video ID' do
    let(:attrs) { {id: 'abc123def456gh'} }

    specify 'prints out a compact version of the object' do
      expect(video.inspect).to eq '#<Yt::Models::Video @id=abc123def456gh>'
    end
  end
end
