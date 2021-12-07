class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_answer, only: :show

  expose :questions, ->{ Question.all }
  expose :question

  def create
    question.user = current_user

    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user&.author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question successfully removed.'
    else
      redirect_to question_path(question), notice: 'Question can be deleted only by the author.'
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
