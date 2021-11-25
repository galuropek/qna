class QuestionsController < ApplicationController
  expose :questions, ->{ Question.all }
  expose :question

  def create
    if question.save
      redirect_to question
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
