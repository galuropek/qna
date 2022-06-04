class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  has_one_attached :file

  validates :title, :body, presence: true, length: { minimum: 5 }
end
