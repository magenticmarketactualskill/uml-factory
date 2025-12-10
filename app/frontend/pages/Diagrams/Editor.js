// Diagram Editor page with Model-Aware features
import { useForm, useRouter, createReactiveState } from '@inertiajs/juris'
import Canvas from '../../components/Diagram/Canvas'
import Palette from '../../components/Diagram/Palette'
import PropertiesPanel from '../../components/Diagram/PropertiesPanel'
import Toolbar from '../../components/Diagram/Toolbar'

export default function Editor(props) {
  const diagram = props.diagram?.value || {}
  const project = props.project?.value || {}
  const validation = props.validation?.value || { valid: true, errors: [] }
  const router = useRouter()
  
  // Local state for editor
  const selectedElement = createReactiveState(null)
  const zoomLevel = createReactiveState(1.0)
  const canvasOffset = createReactiveState({ x: 0, y: 0 })
  const createMode = createReactiveState(null) // null or element type to create
  
  // Handle element selection
  const handleElementSelect = (element) => {
    selectedElement.update(element)
    createMode.update(null)
  }
  
  // Handle element creation from palette
  const handlePaletteItemClick = (elementType) => {
    createMode.update(elementType)
    selectedElement.update(null)
  }
  
  // Handle canvas click to create element
  const handleCanvasClick = (position) => {
    if (createMode.value) {
      createElementAtPosition(createMode.value, position)
      createMode.update(null)
    }
  }
  
  // Create element at position
  const createElementAtPosition = (elementType, position) => {
    fetch(`/projects/${project.id}/diagrams/${diagram.id}/diagram_elements`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        diagram_element: {
          element_type: elementType,
          position: position,
          properties: getDefaultProperties(elementType)
        }
      })
    })
    .then(response => response.json())
    .then(data => {
      // Reload page to get updated elements
      router.reload({ preserveScroll: true })
    })
    .catch(error => console.error('Error creating element:', error))
  }
  
  // Handle element property update
  const handlePropertyUpdate = (elementId, properties) => {
    fetch(`/projects/${project.id}/diagrams/${diagram.id}/diagram_elements/${elementId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        diagram_element: { properties }
      })
    })
    .then(response => response.json())
    .then(data => {
      router.reload({ preserveScroll: true })
    })
    .catch(error => console.error('Error updating element:', error))
  }
  
  // Handle element move
  const handleElementMove = (elementId, newPosition) => {
    fetch(`/projects/${project.id}/diagrams/${diagram.id}/diagram_elements/${elementId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        diagram_element: { position: newPosition }
      })
    })
    .catch(error => console.error('Error moving element:', error))
  }
  
  return {
    tag: 'div',
    props: { className: 'diagram-editor' },
    children: [
      // Toolbar
      Toolbar({
        diagram: diagram,
        project: project,
        zoomLevel: zoomLevel.value,
        validation: validation,
        onZoomIn: () => zoomLevel.update(z => Math.min(z + 0.1, 3.0)),
        onZoomOut: () => zoomLevel.update(z => Math.max(z - 0.1, 0.1)),
        onSave: () => router.visit(`/projects/${project.id}/diagrams/${diagram.id}`),
        onExport: () => window.location.href = `/projects/${project.id}/diagrams/${diagram.id}/export?format=plantuml`,
        onValidate: () => {
          fetch(`/projects/${project.id}/diagrams/${diagram.id}/validate`, {
            method: 'POST',
            headers: {
              'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
            }
          })
          .then(response => response.json())
          .then(data => {
            alert(data.valid ? 'Diagram is valid!' : `Validation errors: ${data.errors.join(', ')}`)
          })
        }
      }),
      
      // Main editor area
      {
        tag: 'div',
        props: { className: 'editor-main' },
        children: [
          // Element palette
          Palette({
            diagramType: diagram.diagram_type,
            onItemClick: handlePaletteItemClick,
            activeItem: createMode.value
          }),
          
          // Canvas
          Canvas({
            diagram: diagram,
            elements: diagram.diagram_elements || [],
            relationships: diagram.diagram_relationships || [],
            selectedElement: selectedElement.value,
            zoomLevel: zoomLevel.value,
            offset: canvasOffset.value,
            createMode: createMode.value,
            onElementSelect: handleElementSelect,
            onCanvasClick: handleCanvasClick,
            onElementMove: handleElementMove
          }),
          
          // Properties panel
          PropertiesPanel({
            element: selectedElement.value,
            onUpdate: handlePropertyUpdate
          })
        ]
      }
    ]
  }
}

function getDefaultProperties(elementType) {
  const defaults = {
    actor: { name: 'New Actor', description: '' },
    use_case: { name: 'New Use Case', description: '', preconditions: '', postconditions: '' },
    class: { 
      name: 'NewClass', 
      visibility: 'public',
      isAbstract: false,
      attributes: [], 
      operations: []
    },
    interface: {
      name: 'INewInterface',
      operations: []
    },
    lifeline: {
      name: 'Object',
      type: 'Object'
    }
  }
  return defaults[elementType] || { name: 'New Element' }
}
