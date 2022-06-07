class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true, length: { minimum: 5 }

  def mark_as_best
    question.update(best_answer_id: self.id)
  end

  def best?
    self == self.question.best_answer
  end
end
