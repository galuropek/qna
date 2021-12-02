class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_answer, only: :show

  expose :questions, ->{ Question.all }
  expose :question

  def create
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  private

  def set_answer
    @answer = Answer.new
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
