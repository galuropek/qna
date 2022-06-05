class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true, length: { minimum: 5 }

  def mark_as_best
    question.update(best_answer_id: self.id)
  end

  def best?
    self == self.question.best_answer
  end
end
