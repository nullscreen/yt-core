require 'spec_helper'

describe 'Yt::Channel#select', :server do
  subject(:subject) { Yt::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: $existing_channel_id} }

    specify 'lets multiple data parts be fetched with one HTTP call', requests: 1 do
      channel = subject.select :snippet, :status, :statistics

      expect(channel.id).to be
      expect(channel.title).to be
      expect(channel.privacy_status).to be
      expect(channel.view_count).to be
    end
  end
end
