class Answer < ApplicationRecord
  belongs_to :question

  validates :title, :body, presence: true, length: { minimum: 5 }
end
