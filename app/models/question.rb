class Question < ApplicationRecord
  has_one :award, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, :award, reject_if: :all_blank

  validates :title, :body, presence: true, length: { minimum: 5 }
end
