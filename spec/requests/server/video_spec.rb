require 'spec_helper'

describe Yt::Video do
  before(:all) do
    Yt.configuration.api_key = ENV['YT_SERVER_API_KEY']
    Yt.configuration.client_id = ''
    Yt.configuration.client_secret = ''
  end

  subject(:video) { Yt::Video.new attrs }

  context 'given an existing video ID' do
    let(:attrs) { {id: 'gknzFj_0vvY'} }

    specify 'snippet data can be fetched with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original
      expect(video.published_at).to eq Time.parse('2016-10-20 02:19:05 UTC')
      expect(video.channel_id).to eq 'UCwCnUcLcb9-eSrHa_RQGkQQ'
      expect(video.title).to eq 'A public video'
      expect(video.description).to eq 'A YouTube video to test the yt gem.'
      expect(video.thumbnail_url).to be_a String
      expect(video.channel_title).to eq 'Yt Test'
      expect(video.tags).to eq ['yt', 'test', 'tag']
      expect(video.category_id).to eq 22
      expect(video.live_broadcast_content).to eq 'none'
    end

    specify 'status data can be fetched with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(video.upload_status).to eq 'processed'
      expect(video.privacy_status).to eq 'public'
      expect(video.license).to eq 'youtube'
      expect(video.embeddable).to be true
      expect(video.public_stats_viewable).to be true
    end

    specify 'statistics data can be fetched with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(video.view_count).to be > 0
      expect(video.like_count).to be > 0
      expect(video.dislike_count).to be > 0
      expect(video.comment_count).to be > 0
    end

    specify 'content details data can be fetched with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(video.duration).to eq 'PT2S'
      expect(video.seconds).to be 2
      expect(video.hh_mm_ss).to eq '00:00:02'
      expect(video.dimension).to eq '2d'
      expect(video.definition).to eq 'sd'
      expect(video.caption).to be false
      expect(video.licensed_content).to be false
      expect(video.projection).to eq 'rectangular'
    end

    specify 'multiple data can be fetched with one HTTP call using select' do
      expect(Net::HTTP).to receive(:start).once.and_call_original


      expect(video.select(:snippet, :status, :statistics, :content_details).id).to be
      expect(video.select(:snippet, :status, :statistics, :content_details).title).to be
      expect(video.select(:snippet, :status, :statistics, :content_details).privacy_status).to be
      expect(video.select(:snippet, :status, :statistics, :content_details).view_count).to be
      expect(video.select(:snippet, :status, :statistics, :content_details).duration).to be
    end
  end

  context 'given an unknown video ID' do
    let(:attrs) { {id: 'invalid-id-'} }

    specify 'raises Yt::Errors::NoItems upon accessing its data' do
      expect{video.title}.to raise_error Yt::Errors::NoItems
    end
  end
end
