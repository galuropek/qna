class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
    @question = answer.question
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def best
    if current_user.author?(answer.question)
      answer.mark_as_best
      redirect_to question_path(answer.question)
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question 

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end
