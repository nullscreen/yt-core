require 'spec_helper'

describe 'Yt::Group’s snippet and content details methods', :account do
  subject(:group) { Yt::Group.new attrs }

  context 'given an existing group ID' do
    # ADD TO README: requires your own account to have at least one group
    before(:all) { $own_group = $own_channel.groups.first }
    let(:attrs) { {id: $own_group.id} }

    specify 'return all data with one HTTP call', requests: 1 do
      expect(group.title).to be_a String
      expect(group.published_at).to be_a Time
      expect(group.item_count).to be_an Integer
      expect(group.item_type).to be_a String
    end
  end
end
