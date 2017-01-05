require 'spec_helper'

describe 'Yt::Relation#inspect' do
  subject(:relation) { Yt::Relation.new item_class, &item_block }

  context 'given any iteration' do
    let(:item_class) { OpenStruct }
    let(:item_block) { Proc.new do
      OpenStruct.new body: {'items' => [{'id' => 1}, {'id' => 2}, {'id' => 3}]}
    end }

    specify 'prints out a compact version of the object' do
      output = '#<Yt::Relation [#<OpenStruct id=1>, #<OpenStruct id=2>, ...]>'
      expect(relation.inspect).to eq output
    end
  end
end
