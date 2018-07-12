class LineSecuritiesController < ApplicationController
  before_action :authenticate_user!

  def create
    @line_security = current_user.line_securities.new(setting_params)
    show_completion_message(@line_security.save_with_validation?)
  end

  private

    def setting_params
      params.require(:create_line_securities).permit(:security_id, :quantity)
    end

    #show flash message according to completion of work.
    def show_completion_message(work)
      if work
        flash[:notice] = "Process completed!"
      else
        flash[:alert] = "Invalid request!"
      end
        redirect_to show_security_path
    end
end
