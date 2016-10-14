require 'spec_helper'

describe Yt::Models do
  it 'is included in Yt to have shorter class names' do
    expect(Yt::Models::Account).to eq Yt::Account
    expect(Yt::Models::Channel).to eq Yt::Channel
  end
end
