// Properties Panel component
import { createReactiveState } from '@inertiajs/juris'

export default function PropertiesPanel(props) {
  const element = props.element
  const onUpdate = props.onUpdate
  
  if (!element) {
    return {
      tag: 'div',
      props: { className: 'properties-panel' },
      children: [
        {
          tag: 'h3',
          children: 'Properties'
        },
        {
          tag: 'p',
          props: { className: 'text-secondary' },
          children: 'Select an element to view its properties'
        }
      ]
    }
  }
  
  const localProperties = createReactiveState(element.properties)
  
  const handlePropertyChange = (key, value) => {
    const updated = { ...localProperties.value, [key]: value }
    localProperties.update(updated)
  }
  
  const handleSave = () => {
    onUpdate(element.id, localProperties.value)
  }
  
  return {
    tag: 'div',
    props: { className: 'properties-panel' },
    children: [
      {
        tag: 'h3',
        children: 'Properties'
      },
      {
        tag: 'div',
        props: { className: 'property-type' },
        children: [
          {
            tag: 'strong',
            children: 'Type: '
          },
          {
            tag: 'span',
            children: element.element_type
          }
        ]
      },
      
      // Common properties
      {
        tag: 'div',
        props: { className: 'form-group' },
        children: [
          {
            tag: 'label',
            props: { className: 'form-label' },
            children: 'Name'
          },
          {
            tag: 'input',
            props: {
              type: 'text',
              className: 'form-control',
              value: localProperties.value.name || '',
              oninput: (e) => handlePropertyChange('name', e.target.value)
            }
          }
        ]
      },
      
      // Type-specific properties
      ...getTypeSpecificFields(element.element_type, localProperties.value, handlePropertyChange),
      
      // Save button
      {
        tag: 'button',
        props: {
          className: 'btn btn-primary',
          onclick: handleSave,
          style: 'width: 100%; margin-top: 16px;'
        },
        children: 'Save Changes'
      }
    ]
  }
}

function getTypeSpecificFields(elementType, properties, onChange) {
  switch (elementType) {
    case 'class':
      return [
        {
          tag: 'div',
          props: { className: 'form-group' },
          children: [
            {
              tag: 'label',
              props: { className: 'form-label' },
              children: 'Visibility'
            },
            {
              tag: 'select',
              props: {
                className: 'form-control',
                value: properties.visibility || 'public',
                onchange: (e) => onChange('visibility', e.target.value)
              },
              children: [
                { tag: 'option', props: { value: 'public' }, children: 'Public' },
                { tag: 'option', props: { value: 'private' }, children: 'Private' },
                { tag: 'option', props: { value: 'protected' }, children: 'Protected' },
                { tag: 'option', props: { value: 'package' }, children: 'Package' }
              ]
            }
          ]
        },
        {
          tag: 'div',
          props: { className: 'form-group' },
          children: [
            {
              tag: 'label',
              children: [
                {
                  tag: 'input',
                  props: {
                    type: 'checkbox',
                    checked: properties.isAbstract || false,
                    onchange: (e) => onChange('isAbstract', e.target.checked)
                  }
                },
                ' Abstract Class'
              ]
            }
          ]
        }
      ]
    
    case 'actor':
    case 'use_case':
      return [
        {
          tag: 'div',
          props: { className: 'form-group' },
          children: [
            {
              tag: 'label',
              props: { className: 'form-label' },
              children: 'Description'
            },
            {
              tag: 'textarea',
              props: {
                className: 'form-control',
                rows: 3,
                value: properties.description || '',
                oninput: (e) => onChange('description', e.target.value)
              }
            }
          ]
        }
      ]
    
    case 'lifeline':
      return [
        {
          tag: 'div',
          props: { className: 'form-group' },
          children: [
            {
              tag: 'label',
              props: { className: 'form-label' },
              children: 'Type'
            },
            {
              tag: 'input',
              props: {
                type: 'text',
                className: 'form-control',
                value: properties.type || 'Object',
                oninput: (e) => onChange('type', e.target.value)
              }
            }
          ]
        }
      ]
    
    default:
      return []
  }
}
