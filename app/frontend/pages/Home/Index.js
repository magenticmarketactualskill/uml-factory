// Home page for authenticated users
import { useRouter } from '@inertiajs/juris'
import Layout from '../../components/Layout/Layout'

export default function Index(props) {
  const router = useRouter()
  const projects = props.projects?.value || []
  const recentDiagrams = props.recent_diagrams?.value || []
  
  return Layout({
    auth: props.auth?.value,
    children: {
      tag: 'div',
      props: { className: 'home-page' },
      children: [
        {
          tag: 'div',
          props: { className: 'page-header' },
          children: [
            { tag: 'h1', children: 'Welcome to UML Factory' },
            {
              tag: 'p',
              props: { className: 'text-secondary' },
              children: 'Create and manage your UML diagrams with ease'
            }
          ]
        },
        
        // Quick Actions
        {
          tag: 'div',
          props: { className: 'quick-actions mt-4' },
          children: [
            {
              tag: 'a',
              props: {
                href: '/projects/new',
                className: 'btn btn-primary',
                onclick: (e) => {
                  e.preventDefault()
                  router.visit('/projects/new')
                }
              },
              children: '+ New Project'
            }
          ]
        },
        
        // Recent Projects
        {
          tag: 'div',
          props: { className: 'section mt-4' },
          children: [
            { tag: 'h2', children: 'Recent Projects' },
            projects.length > 0 ? {
              tag: 'div',
              props: { className: 'projects-grid' },
              children: projects.map(project => ({
                tag: 'div',
                props: { className: 'card' },
                children: [
                  {
                    tag: 'h3',
                    props: { className: 'card-header' },
                    children: project.name
                  },
                  {
                    tag: 'p',
                    children: project.description || 'No description'
                  },
                  {
                    tag: 'div',
                    props: { className: 'card-footer' },
                    children: [
                      {
                        tag: 'span',
                        children: `${project.diagram_count} diagrams`
                      },
                      {
                        tag: 'a',
                        props: {
                          href: `/projects/${project.id}`,
                          className: 'btn btn-secondary',
                          onclick: (e) => {
                            e.preventDefault()
                            router.visit(`/projects/${project.id}`)
                          }
                        },
                        children: 'View'
                      }
                    ]
                  }
                ]
              }))
            } : {
              tag: 'p',
              props: { className: 'text-secondary' },
              children: 'No projects yet. Create your first project to get started!'
            }
          ]
        },
        
        // Recent Diagrams
        recentDiagrams.length > 0 && {
          tag: 'div',
          props: { className: 'section mt-4' },
          children: [
            { tag: 'h2', children: 'Recent Diagrams' },
            {
              tag: 'div',
              props: { className: 'diagrams-list' },
              children: recentDiagrams.map(diagram => ({
                tag: 'div',
                props: { className: 'card' },
                children: [
                  {
                    tag: 'h4',
                    children: diagram.name
                  },
                  {
                    tag: 'p',
                    props: { className: 'text-secondary' },
                    children: `${diagram.diagram_type} diagram in ${diagram.project.name}`
                  },
                  {
                    tag: 'a',
                    props: {
                      href: `/projects/${diagram.project_id}/diagrams/${diagram.id}`,
                      className: 'btn btn-primary',
                      onclick: (e) => {
                        e.preventDefault()
                        router.visit(`/projects/${diagram.project_id}/diagrams/${diagram.id}`)
                      }
                    },
                    children: 'Open'
                  }
                ]
              }))
            }
          ]
        }
      ].filter(Boolean)
    }
  })
}
