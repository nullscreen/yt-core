require 'spec_helper'

describe 'Yt::Channel.mine', :account do
  subject(:channel) { Yt::Channel.mine }

  specify 'returns the channel of the authenticated account', requests: 1 do
    expect(channel).to be_a Yt::Channel
  end
end
