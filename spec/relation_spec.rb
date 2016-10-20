require 'spec_helper'

describe Yt::Relation do
  subject(:relation) { Yt::Relation.new{|items| (1..5).each{|i| items << i}} }

  context 'given any relation' do
    specify 'prints out a compact version of the object' do
      expect(relation.inspect).to eq '#<Yt::Relation [1, 2, ...]>'
    end
  end
end
