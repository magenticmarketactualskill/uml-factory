class DiagramsController < ApplicationController
  before_action :set_project
  before_action :set_diagram, only: [:show, :edit, :update, :destroy, :export, :validate]

  def index
    @diagrams = @project.diagrams.includes(:user).order(updated_at: :desc)
    
    render inertia: 'Diagrams/Index', props: {
      diagrams: @diagrams.as_json(include: :user),
      project: @project
    }
  end

  def show
    authorize @diagram
    
    render inertia: 'Diagrams/Editor', props: {
      diagram: @diagram.as_json(
        include: {
          diagram_elements: {},
          diagram_relationships: { 
            include: [:source_element, :target_element] 
          }
        }
      ),
      project: @project,
      validation: @diagram.validate_uml_model
    }
  end

  def new
    @diagram = @project.diagrams.build
    
    render inertia: 'Diagrams/New', props: {
      project: @project
    }
  end

  def create
    @diagram = @project.diagrams.build(diagram_params)
    @diagram.user = current_user
    @diagram.metadata = { zoom: 1.0, pan: { x: 0, y: 0 } }
    
    if @diagram.save
      redirect_to project_diagram_path(@project, @diagram), 
                  notice: 'Diagram was successfully created.'
    else
      render inertia: 'Diagrams/New', props: {
        errors: @diagram.errors.full_messages,
        project: @project
      }
    end
  end

  def edit
    authorize @diagram
    
    render inertia: 'Diagrams/Edit', props: {
      diagram: @diagram,
      project: @project
    }
  end

  def update
    authorize @diagram
    
    if @diagram.update(diagram_params)
      redirect_to project_diagram_path(@project, @diagram),
                  notice: 'Diagram was successfully updated.'
    else
      render inertia: 'Diagrams/Edit', props: {
        errors: @diagram.errors.full_messages,
        diagram: @diagram,
        project: @project
      }
    end
  end

  def destroy
    authorize @diagram
    
    @diagram.destroy
    redirect_to project_diagrams_url(@project),
                notice: 'Diagram was successfully deleted.'
  end

  def export
    authorize @diagram
    
    format = params[:format] || 'json'
    
    case format
    when 'json'
      send_data @diagram.export_as_json.to_json,
                filename: "#{@diagram.name.parameterize}.json",
                type: 'application/json'
    when 'plantuml'
      send_data @diagram.export_as_plantuml,
                filename: "#{@diagram.name.parameterize}.puml",
                type: 'text/plain'
    when 'png', 'svg', 'pdf'
      # These would require additional rendering services
      flash[:alert] = "Export to #{format.upcase} is not yet implemented."
      redirect_to project_diagram_path(@project, @diagram)
    else
      flash[:alert] = "Unknown export format: #{format}"
      redirect_to project_diagram_path(@project, @diagram)
    end
  end

  def validate
    authorize @diagram
    
    result = @diagram.validate_uml_model
    
    render json: result
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_diagram
    @diagram = @project.diagrams.find(params[:id])
  end

  def diagram_params
    params.require(:diagram).permit(:name, :diagram_type, metadata: {})
  end
end
