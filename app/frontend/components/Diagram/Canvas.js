// Canvas component with Model-Aware features
import { createReactiveState } from '@inertiajs/juris'
import ElementTooltip from './ElementTooltip'

export default function Canvas(props) {
  const hoveredElement = createReactiveState(null)
  const tooltipPosition = createReactiveState({ x: 0, y: 0 })
  const isDragging = createReactiveState(false)
  const draggedElement = createReactiveState(null)
  const dragStart = createReactiveState({ x: 0, y: 0 })
  
  // Handle mouse hover for Model-Aware tooltips
  const handleElementMouseEnter = (element, event) => {
    hoveredElement.update(element)
    tooltipPosition.update({
      x: event.clientX + 10,
      y: event.clientY + 10
    })
  }
  
  const handleElementMouseLeave = () => {
    hoveredElement.update(null)
  }
  
  // Handle drag and drop
  const handleElementMouseDown = (element, event) => {
    event.stopPropagation()
    isDragging.update(true)
    draggedElement.update(element)
    dragStart.update({
      x: event.clientX - element.position.x,
      y: event.clientY - element.position.y
    })
    props.onElementSelect(element)
  }
  
  const handleCanvasMouseMove = (event) => {
    if (isDragging.value && draggedElement.value) {
      const newPosition = {
        x: event.clientX - dragStart.value.x,
        y: event.clientY - dragStart.value.y
      }
      props.onElementMove(draggedElement.value.id, newPosition)
    }
  }
  
  const handleCanvasMouseUp = () => {
    isDragging.update(false)
    draggedElement.update(null)
  }
  
  const handleCanvasClick = (event) => {
    if (props.createMode && event.target.tagName === 'svg') {
      const rect = event.target.getBoundingClientRect()
      const position = {
        x: (event.clientX - rect.left) / props.zoomLevel,
        y: (event.clientY - rect.top) / props.zoomLevel
      }
      props.onCanvasClick(position)
    }
  }
  
  return {
    tag: 'div',
    props: {
      className: 'diagram-canvas',
      onmousemove: handleCanvasMouseMove,
      onmouseup: handleCanvasMouseUp,
      style: props.createMode ? 'cursor: crosshair;' : ''
    },
    children: [
      // SVG canvas
      {
        tag: 'svg',
        props: {
          className: 'canvas-svg',
          width: '2000',
          height: '2000',
          onclick: handleCanvasClick,
          style: `transform: scale(${props.zoomLevel}); transform-origin: top left;`
        },
        children: [
          // Define arrow markers for relationships
          {
            tag: 'defs',
            children: [
              {
                tag: 'marker',
                props: {
                  id: 'arrow',
                  markerWidth: '10',
                  markerHeight: '10',
                  refX: '9',
                  refY: '3',
                  orient: 'auto',
                  markerUnits: 'strokeWidth'
                },
                children: {
                  tag: 'path',
                  props: {
                    d: 'M0,0 L0,6 L9,3 z',
                    fill: '#000'
                  }
                }
              },
              {
                tag: 'marker',
                props: {
                  id: 'triangle',
                  markerWidth: '10',
                  markerHeight: '10',
                  refX: '9',
                  refY: '3',
                  orient: 'auto'
                },
                children: {
                  tag: 'path',
                  props: {
                    d: 'M0,0 L0,6 L9,3 z',
                    fill: '#fff',
                    stroke: '#000'
                  }
                }
              }
            ]
          },
          
          // Render relationships first (lines behind elements)
          ...props.relationships.map(relationship => 
            renderRelationship(relationship, props.elements)
          ),
          
          // Render elements
          ...props.elements.map(element => 
            renderElement(element, {
              selected: props.selectedElement?.id === element.id,
              onMouseDown: (e) => handleElementMouseDown(element, e),
              onMouseEnter: (e) => handleElementMouseEnter(element, e),
              onMouseLeave: handleElementMouseLeave
            })
          )
        ]
      },
      
      // Model-Aware Tooltip
      hoveredElement.value && ElementTooltip({
        element: hoveredElement.value,
        position: tooltipPosition.value
      })
    ]
  }
}

function renderElement(element, handlers) {
  const { position, properties, element_type } = element
  const x = position.x || 0
  const y = position.y || 0
  
  switch (element_type) {
    case 'class':
      return renderClass(element, x, y, handlers)
    case 'actor':
      return renderActor(element, x, y, handlers)
    case 'use_case':
      return renderUseCase(element, x, y, handlers)
    case 'interface':
      return renderInterface(element, x, y, handlers)
    case 'lifeline':
      return renderLifeline(element, x, y, handlers)
    default:
      return renderGenericElement(element, x, y, handlers)
  }
}

function renderClass(element, x, y, handlers) {
  const props = element.properties
  const width = 160
  const headerHeight = 30
  const attrHeight = (props.attributes?.length || 0) * 20 + 10
  const opHeight = (props.operations?.length || 0) * 20 + 10
  const totalHeight = headerHeight + attrHeight + opHeight
  
  return {
    tag: 'g',
    props: {
      transform: `translate(${x}, ${y})`,
      onmousedown: handlers.onMouseDown,
      onmouseenter: handlers.onMouseEnter,
      onmouseleave: handlers.onMouseLeave,
      style: 'cursor: move;'
    },
    children: [
      // Class box
      {
        tag: 'rect',
        props: {
          width: width,
          height: totalHeight,
          className: handlers.selected ? 'uml-class selected' : 'uml-class'
        }
      },
      // Class name
      {
        tag: 'text',
        props: {
          x: width / 2,
          y: 20,
          'text-anchor': 'middle',
          'font-weight': 'bold'
        },
        children: props.name || 'Class'
      },
      // Separator
      {
        tag: 'line',
        props: {
          x1: 0,
          y1: headerHeight,
          x2: width,
          y2: headerHeight,
          stroke: '#000',
          'stroke-width': 1
        }
      },
      // Attributes section
      ...((props.attributes || []).map((attr, i) => ({
        tag: 'text',
        props: {
          x: 5,
          y: headerHeight + 15 + (i * 20),
          'font-size': '12px',
          'font-family': 'monospace'
        },
        children: `${attr.visibility} ${attr.name}: ${attr.type}`
      }))),
      // Separator
      {
        tag: 'line',
        props: {
          x1: 0,
          y1: headerHeight + attrHeight,
          x2: width,
          y2: headerHeight + attrHeight,
          stroke: '#000',
          'stroke-width': 1
        }
      },
      // Operations section
      ...((props.operations || []).map((op, i) => ({
        tag: 'text',
        props: {
          x: 5,
          y: headerHeight + attrHeight + 15 + (i * 20),
          'font-size': '12px',
          'font-family': 'monospace'
        },
        children: `${op.visibility} ${op.name}(): ${op.returnType}`
      })))
    ]
  }
}

function renderActor(element, x, y, handlers) {
  const props = element.properties
  
  return {
    tag: 'g',
    props: {
      transform: `translate(${x}, ${y})`,
      onmousedown: handlers.onMouseDown,
      onmouseenter: handlers.onMouseEnter,
      onmouseleave: handlers.onMouseLeave,
      style: 'cursor: move;'
    },
    children: [
      // Head
      {
        tag: 'circle',
        props: {
          cx: 20,
          cy: 10,
          r: 10,
          className: 'uml-actor'
        }
      },
      // Body
      {
        tag: 'line',
        props: {
          x1: 20,
          y1: 20,
          x2: 20,
          y2: 40,
          stroke: '#000',
          'stroke-width': 2
        }
      },
      // Arms
      {
        tag: 'line',
        props: {
          x1: 5,
          y1: 28,
          x2: 35,
          y2: 28,
          stroke: '#000',
          'stroke-width': 2
        }
      },
      // Legs
      {
        tag: 'line',
        props: {
          x1: 20,
          y1: 40,
          x2: 10,
          y2: 55,
          stroke: '#000',
          'stroke-width': 2
        }
      },
      {
        tag: 'line',
        props: {
          x1: 20,
          y1: 40,
          x2: 30,
          y2: 55,
          stroke: '#000',
          'stroke-width': 2
        }
      },
      // Name
      {
        tag: 'text',
        props: {
          x: 20,
          y: 70,
          'text-anchor': 'middle',
          'font-size': '12px'
        },
        children: props.name || 'Actor'
      }
    ]
  }
}

function renderUseCase(element, x, y, handlers) {
  const props = element.properties
  const width = 120
  const height = 60
  
  return {
    tag: 'g',
    props: {
      transform: `translate(${x}, ${y})`,
      onmousedown: handlers.onMouseDown,
      onmouseenter: handlers.onMouseEnter,
      onmouseleave: handlers.onMouseLeave,
      style: 'cursor: move;'
    },
    children: [
      {
        tag: 'ellipse',
        props: {
          cx: width / 2,
          cy: height / 2,
          rx: width / 2,
          ry: height / 2,
          className: handlers.selected ? 'uml-use-case selected' : 'uml-use-case'
        }
      },
      {
        tag: 'text',
        props: {
          x: width / 2,
          y: height / 2 + 5,
          'text-anchor': 'middle',
          'font-size': '12px'
        },
        children: props.name || 'Use Case'
      }
    ]
  }
}

function renderInterface(element, x, y, handlers) {
  // Similar to class but with <<interface>> stereotype
  return renderClass(element, x, y, handlers)
}

function renderLifeline(element, x, y, handlers) {
  const props = element.properties
  const width = 80
  const height = 300
  
  return {
    tag: 'g',
    props: {
      transform: `translate(${x}, ${y})`,
      onmousedown: handlers.onMouseDown,
      onmouseenter: handlers.onMouseEnter,
      onmouseleave: handlers.onMouseLeave,
      style: 'cursor: move;'
    },
    children: [
      // Object box
      {
        tag: 'rect',
        props: {
          x: 0,
          y: 0,
          width: width,
          height: 40,
          fill: '#fff',
          stroke: '#000',
          'stroke-width': 2
        }
      },
      {
        tag: 'text',
        props: {
          x: width / 2,
          y: 25,
          'text-anchor': 'middle',
          'font-size': '12px'
        },
        children: `${props.name}: ${props.type}`
      },
      // Lifeline
      {
        tag: 'line',
        props: {
          x1: width / 2,
          y1: 40,
          x2: width / 2,
          y2: height,
          stroke: '#000',
          'stroke-width': 1,
          'stroke-dasharray': '5,5'
        }
      }
    ]
  }
}

function renderGenericElement(element, x, y, handlers) {
  return {
    tag: 'g',
    props: {
      transform: `translate(${x}, ${y})`,
      onmousedown: handlers.onMouseDown,
      onmouseenter: handlers.onMouseEnter,
      onmouseleave: handlers.onMouseLeave,
      style: 'cursor: move;'
    },
    children: [
      {
        tag: 'rect',
        props: {
          width: 100,
          height: 50,
          fill: '#fff',
          stroke: '#000',
          'stroke-width': 2
        }
      },
      {
        tag: 'text',
        props: {
          x: 50,
          y: 30,
          'text-anchor': 'middle'
        },
        children: element.properties.name || 'Element'
      }
    ]
  }
}

function renderRelationship(relationship, elements) {
  const source = elements.find(e => e.id === relationship.source_element_id)
  const target = elements.find(e => e.id === relationship.target_element_id)
  
  if (!source || !target) return null
  
  const x1 = (source.position.x || 0) + 80
  const y1 = (source.position.y || 0) + 30
  const x2 = (target.position.x || 0) + 80
  const y2 = (target.position.y || 0) + 30
  
  return {
    tag: 'line',
    props: {
      x1: x1,
      y1: y1,
      x2: x2,
      y2: y2,
      stroke: '#000',
      'stroke-width': 2,
      'marker-end': getMarkerForRelationship(relationship.relationship_type)
    }
  }
}

function getMarkerForRelationship(type) {
  const markers = {
    association: 'url(#arrow)',
    generalization: 'url(#triangle)',
    realization: 'url(#triangle)',
    include: 'url(#arrow)',
    extend: 'url(#arrow)'
  }
  return markers[type] || 'url(#arrow)'
}
