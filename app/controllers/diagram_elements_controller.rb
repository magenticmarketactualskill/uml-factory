class DiagramElementsController < ApplicationController
  before_action :set_diagram
  before_action :set_element, only: [:update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

  def create
    @element = @diagram.diagram_elements.build(element_params)
    
    if @element.save
      @element.sync_to_uml_store
      render json: { 
        element: @element,
        message: 'Element created successfully'
      }, status: :created
    else
      render json: { 
        errors: @element.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  def update
    if @element.update(element_params)
      @element.sync_to_uml_store
      render json: { 
        element: @element,
        message: 'Element updated successfully'
      }
    else
      render json: { 
        errors: @element.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @element.destroy
    head :no_content
  end

  private

  def set_diagram
    @diagram = current_user.diagrams.find(params[:diagram_id])
  end

  def set_element
    @element = @diagram.diagram_elements.find(params[:id])
  end

  def element_params
    params.require(:diagram_element).permit(
      :element_type,
      position: [:x, :y],
      properties: {}
    )
  end
end
