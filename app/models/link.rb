class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  GITHUB_GIST_HOST = 'gist.github.com'

  def gist?
    URI(url).host == GITHUB_GIST_HOST
  end

  def gist_id
    url.split('/').last
  end
end
