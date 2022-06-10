class LinksController < ApplicationController
  def destroy
    linkable = link.linkable
    link.destroy if linkable && current_user&.author?(linkable)
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end

  helper_method :link
end
