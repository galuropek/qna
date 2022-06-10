require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  let(:link) { create(:link, :question) }
  let(:gist_link) { create(:link, :gist) }

  context 'url validation' do
    let(:invalid_url) { 'google' }

    it 'url should be valid' do
      expect(link).to be_valid
    end

    it 'url should be invalid' do
      link.url = invalid_url
      expect(link).to_not be_valid
    end
  end

  context '#gist?' do
    it 'link is gist' do
      expect(gist_link.gist?).to be true
    end

    it 'link is not gist' do
      expect(link.gist?).to be false
    end
  end

  context '#gist_id' do
    it 'should return gist\'s id' do
      expect(gist_link.gist_id).to eql('c324f0d28418078cae9aa4363e2dcf16')
    end
  end
end
