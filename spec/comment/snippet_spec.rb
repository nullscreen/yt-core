require 'spec_helper'

describe 'Yt::Comment’s snippet methods', :server do
  subject(:comment) { Yt::Comment.new attrs }

  context 'given an existing comment ID' do
    let(:attrs) { {id: $existing_thread_id} }

    specify 'return all snippet data with one HTTP call', requests: 1 do
      expect(comment.author_display_name).to eq 'Yt Test'
      expect(comment.author_profile_image_url).to be_a String
      expect(comment.author_channel_url).to eq 'http://www.youtube.com/channel/UCwCnUcLcb9-eSrHa_RQGkQQ'
      expect(comment.author_channel_id).to eq 'UCwCnUcLcb9-eSrHa_RQGkQQ'
      expect(comment.text_display).to eq 'A public comment'
    end
  end

  context 'given an unknown comment ID' do
    let(:attrs) { {id: $unknown_thread_id} }

    specify 'raise Yt::NoItemsError' do
      expect{comment.text_display}.to raise_error Yt::NoItemsError
    end
  end
end
