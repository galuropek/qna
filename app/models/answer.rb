class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :title, :body, presence: true, length: { minimum: 5 }
end
