class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_answer, only: :show

  expose :questions, -> { Question.all }
  expose :question, find: ->(id, scope) { scope.with_attached_files.find(id) }

  def new
    question.build_badge
    question.links.build
  end

  def show
    @answer.links.build
    @best_answer = question.best_answer
    @other_answers = question.answers.where.not(id: question.best_answer_id)
  end

  def create
    question.user = current_user

    if question.save
      redirect_to question, success: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user&.author?(question)
      question.files.attach(question_params[:files]) unless question_params[:files].blank?
      question.update(question_params.except(:files))
    end
  end

  def destroy
    if current_user&.author?(question)
      question.destroy
      redirect_to questions_path, success: 'Question successfully removed.'
    else
      redirect_to question_path(question), danger: 'Question can be deleted only by the author.'
    end
  end

  private

  def set_answer
    @answer = Answer.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url],
                                     badge_attributes: [:name, :image])
  end
end
