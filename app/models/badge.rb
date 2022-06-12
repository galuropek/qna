class Badge < ApplicationRecord
  belongs_to :question

  has_one_attached :image

  validates :name, presence: true, length: { minimum: 5 }
end
