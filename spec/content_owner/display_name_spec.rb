require 'spec_helper'

describe 'Yt::ContentOwner#display_name', :partner do
  subject(:content_owner) { Yt::ContentOwner.new attrs }

  context 'given a content owner I manage' do
    let(:attrs) { $content_owner_attrs }

    it 'returns the display name limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(content_owner.display_name).to be_present
      expect(content_owner.display_name).to be_a(String)
    end
  end
end
