class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user&.author?(answer)
      answer.files.attach(answer_params[:files]) unless answer_params[:files].blank?
      answer.update(answer_params.except(:files))
    end
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def best
    if current_user.author?(answer.question)
      answer.mark_as_best
      author.badges.push(answer.question.badge) if answer.question.badge.present?
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

  def author
    @author ||= answer.user
  end

  def answer_params
    params.require(:answer).permit(:title, :body,
                                   files: [], links_attributes: [:name, :url])
  end
end
