require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context 'url validation' do
    let(:link) { create(:link, :question) }
    let(:invalid_url) { 'google' }

    it 'url should be valid' do
      expect(link).to be_valid
    end

    it 'url should be invalid' do
      link.url = invalid_url
      expect(link).to_not be_valid
    end
  end
end
