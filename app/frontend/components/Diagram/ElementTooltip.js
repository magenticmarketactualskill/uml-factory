// Element Tooltip component - Model-Aware hover behavior
export default function ElementTooltip(props) {
  const element = props.element
  const position = props.position
  
  if (!element) return null
  
  const getTooltipContent = () => {
    switch (element.element_type) {
      case 'class':
        return renderClassTooltip(element.properties)
      case 'actor':
        return renderActorTooltip(element.properties)
      case 'use_case':
        return renderUseCaseTooltip(element.properties)
      case 'interface':
        return renderInterfaceTooltip(element.properties)
      case 'lifeline':
        return renderLifelineTooltip(element.properties)
      default:
        return renderGenericTooltip(element.properties)
    }
  }
  
  return {
    tag: 'div',
    props: {
      className: 'element-tooltip',
      style: `position: fixed; left: ${position.x}px; top: ${position.y}px; z-index: 1000;`
    },
    children: getTooltipContent()
  }
}

function renderClassTooltip(props) {
  return {
    tag: 'div',
    props: { className: 'tooltip-content' },
    children: [
      { 
        tag: 'h4', 
        children: `Class: ${props.name || 'Unnamed'}` 
      },
      {
        tag: 'p',
        children: `Visibility: ${props.visibility || 'public'}`
      },
      props.isAbstract && {
        tag: 'p',
        children: 'Abstract: Yes'
      },
      (props.attributes && props.attributes.length > 0) && {
        tag: 'div',
        props: { className: 'attributes' },
        children: [
          { tag: 'strong', children: 'Attributes:' },
          {
            tag: 'ul',
            children: props.attributes.map(attr => ({
              tag: 'li',
              children: `${attr.visibility || '+'} ${attr.name}: ${attr.type}`
            }))
          }
        ]
      },
      (props.operations && props.operations.length > 0) && {
        tag: 'div',
        props: { className: 'operations' },
        children: [
          { tag: 'strong', children: 'Operations:' },
          {
            tag: 'ul',
            children: props.operations.map(op => ({
              tag: 'li',
              children: `${op.visibility || '+'} ${op.name}(${op.parameters?.join(', ') || ''}): ${op.returnType || 'void'}`
            }))
          }
        ]
      }
    ].filter(Boolean)
  }
}

function renderActorTooltip(props) {
  return {
    tag: 'div',
    props: { className: 'tooltip-content' },
    children: [
      { 
        tag: 'h4', 
        children: `Actor: ${props.name || 'Unnamed'}` 
      },
      props.description && {
        tag: 'p',
        children: props.description
      }
    ].filter(Boolean)
  }
}

function renderUseCaseTooltip(props) {
  return {
    tag: 'div',
    props: { className: 'tooltip-content' },
    children: [
      { 
        tag: 'h4', 
        children: `Use Case: ${props.name || 'Unnamed'}` 
      },
      props.description && {
        tag: 'p',
        children: props.description
      },
      props.preconditions && {
        tag: 'div',
        children: [
          { tag: 'strong', children: 'Preconditions:' },
          { tag: 'p', children: props.preconditions }
        ]
      },
      props.postconditions && {
        tag: 'div',
        children: [
          { tag: 'strong', children: 'Postconditions:' },
          { tag: 'p', children: props.postconditions }
        ]
      }
    ].filter(Boolean)
  }
}

function renderInterfaceTooltip(props) {
  return {
    tag: 'div',
    props: { className: 'tooltip-content' },
    children: [
      { 
        tag: 'h4', 
        children: `Interface: ${props.name || 'Unnamed'}` 
      },
      (props.operations && props.operations.length > 0) && {
        tag: 'div',
        props: { className: 'operations' },
        children: [
          { tag: 'strong', children: 'Operations:' },
          {
            tag: 'ul',
            children: props.operations.map(op => ({
              tag: 'li',
              children: `${op.name}(${op.parameters?.join(', ') || ''}): ${op.returnType || 'void'}`
            }))
          }
        ]
      }
    ].filter(Boolean)
  }
}

function renderLifelineTooltip(props) {
  return {
    tag: 'div',
    props: { className: 'tooltip-content' },
    children: [
      { 
        tag: 'h4', 
        children: `Lifeline: ${props.name || 'Unnamed'}` 
      },
      {
        tag: 'p',
        children: `Type: ${props.type || 'Object'}`
      }
    ]
  }
}

function renderGenericTooltip(props) {
  return {
    tag: 'div',
    props: { className: 'tooltip-content' },
    children: [
      { 
        tag: 'h4', 
        children: props.name || 'Unnamed Element' 
      }
    ]
  }
}
