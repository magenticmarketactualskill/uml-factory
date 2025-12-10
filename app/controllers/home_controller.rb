class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if user_signed_in?
      @projects = current_user.projects.active.recent.limit(5)
      @recent_diagrams = current_user.diagrams.recent.includes(:project).limit(10)
      
      render inertia: 'Home/Index', props: {
        projects: @projects.as_json(methods: [:diagram_count]),
        recent_diagrams: @recent_diagrams.as_json(include: :project)
      }
    else
      render inertia: 'Home/Welcome'
    end
  end
end
