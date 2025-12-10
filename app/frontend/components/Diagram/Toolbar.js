// Toolbar component for diagram editor
export default function Toolbar(props) {
  const { diagram, project, zoomLevel, validation, onZoomIn, onZoomOut, onSave, onExport, onValidate } = props
  
  return {
    tag: 'div',
    props: { className: 'editor-toolbar' },
    children: [
      {
        tag: 'div',
        props: { className: 'toolbar-section' },
        children: [
          {
            tag: 'a',
            props: {
              href: `/projects/${project.id}`,
              className: 'btn btn-secondary',
              onclick: (e) => {
                e.preventDefault()
                window.history.back()
              }
            },
            children: '← Back'
          },
          {
            tag: 'h2',
            props: { style: 'margin: 0 16px; font-size: 18px;' },
            children: diagram.name
          },
          {
            tag: 'span',
            props: { 
              className: 'badge',
              style: 'padding: 4px 8px; background: #f0f0f0; border-radius: 4px; font-size: 12px;'
            },
            children: diagram.diagram_type
          }
        ]
      },
      
      {
        tag: 'div',
        props: { className: 'toolbar-section' },
        children: [
          {
            tag: 'button',
            props: {
              className: 'btn btn-secondary',
              onclick: onZoomOut
            },
            children: 'Zoom Out'
          },
          {
            tag: 'span',
            props: { style: 'margin: 0 8px;' },
            children: `${Math.round(zoomLevel * 100)}%`
          },
          {
            tag: 'button',
            props: {
              className: 'btn btn-secondary',
              onclick: onZoomIn
            },
            children: 'Zoom In'
          }
        ]
      },
      
      {
        tag: 'div',
        props: { className: 'toolbar-section' },
        children: [
          {
            tag: 'button',
            props: {
              className: 'btn btn-secondary',
              onclick: onValidate
            },
            children: '✓ Validate'
          },
          validation && !validation.valid && {
            tag: 'span',
            props: { 
              style: 'color: var(--danger-color); margin-left: 8px; font-size: 12px;'
            },
            children: `${validation.errors.length} errors`
          },
          {
            tag: 'button',
            props: {
              className: 'btn btn-secondary',
              onclick: onExport
            },
            children: '↓ Export'
          },
          {
            tag: 'button',
            props: {
              className: 'btn btn-primary',
              onclick: onSave
            },
            children: 'Save'
          }
        ].filter(Boolean)
      }
    ]
  }
}
