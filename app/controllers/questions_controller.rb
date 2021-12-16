class QuestionsController < ApplicationController
  def show
    @question = Question.friendly.find(params[:id])
    if request.path != question_path(@question)
      redirect_to @question, status: :moved_permanently
    end
  end
end
