require 'spec_helper'

describe 'Yt::ContentOwner#partnered_channels', :partner do
  subject(:content_owner) { Yt::ContentOwner.new attrs }

  context 'given a content owner I manage' do
    let(:attrs) { $content_owner_attrs }

    it 'returns the list of content_owner. partnered with the content owner' do
      expect(content_owner.partnered_channels).to all( be_a Yt::Channel )
    end

    it 'does not make any HTTP requests unless iterated' do
      expect(Net::HTTP).not_to receive(:start)
      content_owner.partnered_channels
    end

    it 'makes as many HTTP requests as the number of partnered channels divided by 50' do
      expect(Net::HTTP).to receive(:start).once.and_call_original
      content_owner.partnered_channels.map &:id
    end

    it 'reuses the previous HTTP response if the request is the same' do
      expect(Net::HTTP).to receive(:start).once.and_call_original
      content_owner.partnered_channels.map &:id
      content_owner.partnered_channels.map &:id
    end

    it 'accepts .select to fetch multiple parts with two HTTP calls' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      partnered_channels = content_owner.partnered_channels.select :snippet, :status, :statistics
      expect(partnered_channels.map &:title).to be_present
      expect(partnered_channels.map &:privacy_status).to be_present
      expect(partnered_channels.map &:view_count).to be_present
    end

    it 'accepts .limit to only fetch some partnered_channels' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(content_owner.partnered_channels.limit(3).count).to be 3
      expect(content_owner.partnered_channels.limit(3).count).to be 3
    end
  end
end
