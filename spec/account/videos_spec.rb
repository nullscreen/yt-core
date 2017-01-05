require 'spec_helper'

describe 'Yt::Account#videos', :account do
  subject(:account) { Yt::Account.new attrs }

  context 'given an account I manage' do
    let(:attrs) { $account_attrs }

    it 'returns the list of *public/unlisted/private* videos of the account' do
      expect(account.videos).to all( be_a Yt::Video )
    end

    it 'does not make any HTTP requests unless iterated' do
      expect(Net::HTTP).not_to receive(:start)
      account.videos
    end

    # NOTE: `at_least` is due to the fact that sometimes YouTube returns a
    # nextPageToken even if the next page is empty (e.g. if the account only
    # has 3 videos). In this case, we don’t have a choice and we have to fetch
    # another page because we have no way of knowing beforehand that it’s empty.
    it 'makes at least as many HTTP requests as the number of videos divided by 50' do
      expect(Net::HTTP).to receive(:start).at_least(1).times.and_call_original
      account.videos.map &:id
    end

    it 'reuses the previous HTTP response if the request is the same' do
      expect(Net::HTTP).to receive(:start).at_least(1).times.and_call_original
      account.videos.map &:id
      account.videos.map &:id
    end

    it 'makes a new HTTP request if the request has changed' do
      expect(Net::HTTP).to receive(:start).at_least(3).times.and_call_original

      account.videos.map &:id
      account.videos.select(:id, :snippet).map &:title
    end

    it 'accepts .select to fetch multiple parts with two HTTP calls' do
      expect(Net::HTTP).to receive(:start).twice.and_call_original

      videos = account.videos.select :snippet, :status, :statistics, :content_details
      expect(videos.map &:title).to be_present
      expect(videos.map &:privacy_status).to be_present
      expect(videos.map &:view_count).to be_present
      expect(videos.map &:duration).to be_present
    end

    it 'accepts .limit to only fetch some videos' do
      expect(Net::HTTP).to receive(:start).once.and_call_original
      expect(account.videos.limit(3).count).to be 3
    end
  end
end
