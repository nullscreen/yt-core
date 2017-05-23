require 'spec_helper'

describe 'Yt::Video#threads', :server do
  subject(:video) { Yt::Video.new attrs }

  context 'given an existing video ID' do
    let(:attrs) { {id: $existing_video_id} }

    it 'returns the list of *public* threads of the video' do
      expect(video.threads).to all( be_a Yt::CommentThread )
    end

    it 'does not make any HTTP requests unless iterated', requests: 0 do
      video.threads
    end

    it 'makes as many HTTP requests as the number of threads divided by 50', requests: 1 do
      video.threads.map &:id
    end

    it 'reuses the previous HTTP response if the request is the same', requests: 1 do
      video.threads.map &:id
      video.threads.map &:id
    end

    it 'makes a new HTTP request if the request has changed', requests: 2 do
      video.threads.map &:id
      video.threads.select(:id, :snippet).map &:video_id
    end

    it 'allocates at most one Yt::Relation object, no matter the requests' do
      expect{video.threads}.to change{ObjectSpace.each_object(Yt::Relation).count}
      expect{video.threads}.not_to change{ObjectSpace.each_object(Yt::Relation).count}
    end

    it 'allocates at most 50 Yt::CommentThread object, no matter the requests' do
      expect{video.threads.map &:id}.to change{GC.start; ObjectSpace.each_object(Yt::CommentThread).count}
      expect{video.threads.map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::CommentThread).count}
      expect{video.threads.select(:snippet).map &:video_id}.not_to change{GC.start; ObjectSpace.each_object(Yt::CommentThread).count}
      expect{video.threads.limit(4).map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::CommentThread).count}
    end

    it 'accepts .select to fetch multiple parts with two HTTP calls', requests: 1 do
      threads = video.threads.select :id, :snippet
      expect(threads.map &:id).to be
      expect(threads.map &:video_id).to be
    end

    it 'accepts .limit to only fetch some threads', requests: 1 do
      expect(video.threads.select(:snippet).limit(2).count).to be 2
    end

    it 'returns the number of threads with one HTTP request', requests: 1 do
      expect(video.threads.select(:snippet).size).to eq 3
    end
  end
end
