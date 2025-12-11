// Home page for authenticated users
import React from 'react'
import { router } from '@inertiajs/react'
import Layout from '../../components/Layout/Layout.jsx'

export default function Index({ auth, projects = [], recent_diagrams = [] }) {
  const handleNewProject = (e) => {
    e.preventDefault()
    router.visit('/projects/new')
  }

  const handleViewProject = (projectId) => (e) => {
    e.preventDefault()
    router.visit(`/projects/${projectId}`)
  }

  const handleOpenDiagram = (projectId, diagramId) => (e) => {
    e.preventDefault()
    router.visit(`/projects/${projectId}/diagrams/${diagramId}`)
  }

  return (
    <Layout auth={auth}>
      <div className="home-page">
        <div className="page-header">
          <h1>Welcome to UML Factory</h1>
          <p className="text-secondary">
            Create and manage your UML diagrams with ease
          </p>
        </div>
        
        {/* Quick Actions */}
        <div className="quick-actions mt-4">
          <a 
            href="/projects/new" 
            className="btn btn-primary"
            onClick={handleNewProject}
          >
            + New Project
          </a>
        </div>
        
        {/* Recent Projects */}
        <div className="section mt-4">
          <h2>Recent Projects</h2>
          {projects.length > 0 ? (
            <div className="projects-grid">
              {projects.map(project => (
                <div key={project.id} className="card">
                  <h3 className="card-header">{project.name}</h3>
                  <p>{project.description || 'No description'}</p>
                  <div className="card-footer">
                    <span>{project.diagram_count} diagrams</span>
                    <a 
                      href={`/projects/${project.id}`}
                      className="btn btn-secondary"
                      onClick={handleViewProject(project.id)}
                    >
                      View
                    </a>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-secondary">
              No projects yet. Create your first project to get started!
            </p>
          )}
        </div>
        
        {/* Recent Diagrams */}
        {recent_diagrams.length > 0 && (
          <div className="section mt-4">
            <h2>Recent Diagrams</h2>
            <div className="diagrams-list">
              {recent_diagrams.map(diagram => (
                <div key={diagram.id} className="card">
                  <h4>{diagram.name}</h4>
                  <p className="text-secondary">
                    {diagram.diagram_type} diagram in {diagram.project.name}
                  </p>
                  <a 
                    href={`/projects/${diagram.project_id}/diagrams/${diagram.id}`}
                    className="btn btn-primary"
                    onClick={handleOpenDiagram(diagram.project_id, diagram.id)}
                  >
                    Open
                  </a>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </Layout>
  )
}