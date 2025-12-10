class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects.includes(:diagrams).order(updated_at: :desc)
    
    render inertia: 'Projects/Index', props: {
      projects: @projects.as_json(
        include: { diagrams: { only: [:id, :name, :diagram_type, :updated_at] } },
        methods: [:diagram_count]
      )
    }
  end

  def show
    authorize @project
    
    render inertia: 'Projects/Show', props: {
      project: @project.as_json(
        include: { diagrams: { only: [:id, :name, :diagram_type, :updated_at, :created_at] } }
      )
    }
  end

  def new
    @project = Project.new
    
    render inertia: 'Projects/New'
  end

  def create
    @project = current_user.projects.build(project_params)
    
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render inertia: 'Projects/New', props: {
        errors: @project.errors.full_messages
      }
    end
  end

  def edit
    authorize @project
    
    render inertia: 'Projects/Edit', props: {
      project: @project
    }
  end

  def update
    authorize @project
    
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render inertia: 'Projects/Edit', props: {
        project: @project,
        errors: @project.errors.full_messages
      }
    end
  end

  def destroy
    authorize @project
    
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully deleted.'
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :status)
  end
end
