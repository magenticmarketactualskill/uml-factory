module Admin
  class AdminController < ApplicationController
    before_action :require_admin!

    private

    def require_admin!
      unless current_user&.admin?
        flash[:alert] = "You must be an administrator to access this page."
        redirect_to root_path
      end
    end
  end
end
