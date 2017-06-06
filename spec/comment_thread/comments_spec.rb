require 'spec_helper'

describe 'Yt::CommentThread#comments', :server do
  subject(:thread) { Yt::CommentThread.new attrs }

  context 'given an existing thread ID' do
    let(:attrs) { {id: $existing_thread_id} }

    it 'returns the list of *public* comments of the thread' do
      expect(thread.comments).to all( be_a Yt::Comment )
    end

    it 'does not make any HTTP requests unless iterated', requests: 0 do
      thread.comments
    end

    it 'makes as many HTTP requests as the number of comments divided by 50', requests: 2 do
      thread.comments.map &:id
    end

    it 'reuses the previous HTTP response if the request is the same', requests: 2 do
      thread.comments.map &:id
      thread.comments.map &:id
    end

    it 'makes a new HTTP request if the request has changed', requests: 3 do
      thread.comments.map &:id
      thread.comments.select(:id, :snippet).map &:text_display
    end

    it 'allocates at most one Yt::Relation object, no matter the requests' do
      expect{thread.comments}.to change{ObjectSpace.each_object(Yt::Relation).count}
      expect{thread.comments}.not_to change{ObjectSpace.each_object(Yt::Relation).count}
    end

    it 'allocates at most 50 Yt::Comment object, no matter the requests' do
      expect{thread.comments.map &:id}.to change{GC.start; ObjectSpace.each_object(Yt::Comment).count}
      expect{thread.comments.map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Comment).count}
      expect{thread.comments.select(:snippet).map &:text_display}.not_to change{GC.start; ObjectSpace.each_object(Yt::Comment).count}
      expect{thread.comments.limit(4).map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Comment).count}
    end

    it 'accepts .select to fetch multiple parts with two HTTP calls', requests: 2 do
      comments = thread.comments.select :id, :snippet
      expect(comments.map &:id).to be
      expect(comments.map &:text_display).to be
    end

    it 'accepts .limit to only fetch some comments', requests: 2 do
      expect(thread.comments.select(:snippet).limit(2).count).to be 2
    end
  end
end
