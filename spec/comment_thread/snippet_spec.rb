require 'spec_helper'

describe 'Yt::CommentThread’s snippet methods', :server do
  subject(:thread) { Yt::CommentThread.new attrs }

  context 'given an existing *video* thread ID' do
    let(:attrs) { {id: $existing_thread_id} }

    specify 'return all snippet data with one HTTP call', requests: 1 do
      expect(thread.video_id).to eq 'gknzFj_0vvY'
      expect(thread.top_level_comment.text_display).to eq 'A public comment'
    end
  end

  context 'given an unknown thread ID' do
    let(:attrs) { {id: $unknown_thread_id} }

    specify 'raise Yt::NoItemsError' do
      expect{thread.channel_id}.to raise_error Yt::NoItemsError
    end
  end
end

