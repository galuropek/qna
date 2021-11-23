class Answer < ApplicationRecord
  validates :title, :body, presence: true
end
