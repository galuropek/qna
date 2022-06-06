class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    record = attachment.record

    if attachment && current_user&.author?(record)
      attachment.purge

      if record.is_a?(Question)
        redirect_to_question(record)
      elsif record.is_a?(Answer)
        redirect_to_question(record.question)
      end
    end
  end

  private

  def redirect_to_question(question)
    redirect_to question_path(question), notice: 'Attachment successfully removed.'
  end
end
