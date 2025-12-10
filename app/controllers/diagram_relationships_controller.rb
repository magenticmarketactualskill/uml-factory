class DiagramRelationshipsController < ApplicationController
  before_action :set_diagram
  before_action :set_relationship, only: [:update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

  def create
    @relationship = @diagram.diagram_relationships.build(relationship_params)
    
    if @relationship.save
      @relationship.sync_to_uml_store
      render json: { 
        relationship: @relationship.as_json(include: [:source_element, :target_element]),
        message: 'Relationship created successfully'
      }, status: :created
    else
      render json: { 
        errors: @relationship.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  def update
    if @relationship.update(relationship_params)
      @relationship.sync_to_uml_store
      render json: { 
        relationship: @relationship.as_json(include: [:source_element, :target_element]),
        message: 'Relationship updated successfully'
      }
    else
      render json: { 
        errors: @relationship.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @relationship.destroy
    head :no_content
  end

  private

  def set_diagram
    @diagram = current_user.diagrams.find(params[:diagram_id])
  end

  def set_relationship
    @relationship = @diagram.diagram_relationships.find(params[:id])
  end

  def relationship_params
    params.require(:diagram_relationship).permit(
      :relationship_type,
      :source_element_id,
      :target_element_id,
      properties: {}
    )
  end
end
