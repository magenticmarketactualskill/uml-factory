// Element Palette component
export default function Palette(props) {
  const diagramType = props.diagramType
  const onItemClick = props.onItemClick
  const activeItem = props.activeItem
  
  const getPaletteItems = () => {
    switch (diagramType) {
      case 'use_case':
        return {
          'Actors': ['actor'],
          'Use Cases': ['use_case', 'system_boundary'],
          'Common': ['note']
        }
      case 'class':
        return {
          'Classes': ['class', 'interface', 'package'],
          'Common': ['note']
        }
      case 'sequence':
        return {
          'Participants': ['lifeline'],
          'Common': ['note']
        }
      default:
        return {}
    }
  }
  
  const getElementLabel = (elementType) => {
    const labels = {
      actor: 'Actor',
      use_case: 'Use Case',
      system_boundary: 'System Boundary',
      class: 'Class',
      interface: 'Interface',
      package: 'Package',
      lifeline: 'Lifeline',
      note: 'Note'
    }
    return labels[elementType] || elementType
  }
  
  const paletteItems = getPaletteItems()
  
  return {
    tag: 'div',
    props: { className: 'element-palette' },
    children: [
      {
        tag: 'h3',
        props: { className: 'palette-header' },
        children: 'Elements'
      },
      ...Object.entries(paletteItems).map(([section, items]) => ({
        tag: 'div',
        props: { className: 'palette-section' },
        children: [
          {
            tag: 'div',
            props: { className: 'palette-title' },
            children: section
          },
          ...items.map(item => ({
            tag: 'div',
            props: {
              className: activeItem === item ? 'palette-item active' : 'palette-item',
              onclick: () => onItemClick(item),
              style: 'cursor: pointer;'
            },
            children: getElementLabel(item)
          }))
        ]
      }))
    ]
  }
}
