require 'spec_helper'

describe 'Yt::Comment#inspect' do
  subject(:comment) { Yt::Comment.new attrs }

  context 'given any comment ID' do
    let(:attrs) { {id: 'z674srzx5oqiyrbce23nevcwrpqfenix004'} }

    specify 'prints out a compact version of the object' do
      expect(comment.inspect).to eq '#<Yt::Comment @id=z674srzx5oqiyrbce23nevcwrpqfenix004>'
    end
  end
end
