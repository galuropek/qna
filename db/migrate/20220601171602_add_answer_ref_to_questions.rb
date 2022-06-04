class AddAnswerRefToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :best_answer, index: true, foreign_key: false
  end
end
