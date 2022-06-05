class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author?(answer)
      if answer_params[:files]
        a_params = answer_params
        answer.files.attach(a_params.delete(:files))
        answer.update(a_params)
      else
        answer.update(answer_params)
      end
    end

    @question = answer.question
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def destroy_attachment
    attachment = ActiveStorage::Attachment.find(params[:id])
    answer = attachment.record

    if attachment && current_user&.author?(answer)
      attachment.purge
      redirect_to question_path(answer.question), notice: 'Attachment successfully removed.'
    end
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
    params.require(:answer).permit(:title, :body, files: [])
  end
end
