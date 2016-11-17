require 'spec_helper'

describe 'Yt::Account’s user info methods', :account do
  subject(:account) { Yt::Account.new attrs }

  context 'given an account I manage' do
    let(:attrs) { $account_attrs }

    it 'return all user info data with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(account.id).to start_with '1030'
      expect(account.email).to include 'yt'
      expect(account.verified_email).to be true
      expect(account.name).to eq 'Yt Test'
      expect(account.given_name).to eq 'Yt'
      expect(account.family_name).to eq 'Test'
      expect(account.avatar_url).to end_with 'photo.jpg'
      expect(account.locale).to eq 'en'
      expect(account.hd).to be_nil
    end
  end
end
