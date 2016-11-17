require 'spec_helper'

describe 'Yt::Account#inspect' do
  subject(:account) { Yt::Account.new attrs }

  context 'given any account ID' do
    let(:attrs) { {refresh_token: '1234567890'} }

    specify 'prints out a compact version of the object' do
      expect(account.inspect).to eq '#<Yt::Account @refresh_token=123...>'
    end
  end
end
