require 'spec_helper'

describe 'Yt::CommentThread#inspect' do
  subject(:thread) { Yt::CommentThread.new attrs }

  context 'given any thread ID' do
    let(:attrs) { {id: 'z674srzx5oqiyrbce23nevcwrpqfenix004'} }

    specify 'prints out a compact version of the object' do
      expect(thread.inspect).to eq '#<Yt::CommentThread @id=z674srzx5oqiyrbce23nevcwrpqfenix004>'
    end
  end
end
