// Welcome page for non-authenticated users
import React from 'react'
import { router } from '@inertiajs/react'
import Layout from '../../components/Layout/Layout.jsx'

export default function Welcome({ auth }) {
  const handleSignUp = (e) => {
    e.preventDefault()
    router.visit('/users/sign_up')
  }

  const handleSignIn = (e) => {
    e.preventDefault()
    router.visit('/users/sign_in')
  }

  return (
    <Layout auth={auth}>
      <div className="welcome-page">
        <div className="hero-section text-center">
          <h1>Welcome to UML Factory</h1>
          <p className="text-secondary mb-4">
            Create, manage, and collaborate on UML diagrams with ease. 
            Build better software with visual modeling tools.
          </p>
          
          <div className="hero-actions gap-4">
            <a 
              href="/users/sign_up" 
              className="btn btn-primary"
              onClick={handleSignUp}
            >
              Get Started
            </a>
            <a 
              href="/users/sign_in" 
              className="btn btn-secondary"
              onClick={handleSignIn}
            >
              Sign In
            </a>
          </div>
        </div>
        
        <div className="features-section mt-4">
          <h2 className="text-center mb-4">Features</h2>
          <div className="features-grid">
            <div className="card">
              <h3 className="card-header">📊 Multiple Diagram Types</h3>
              <p>
                Create class diagrams, use case diagrams, sequence diagrams, 
                and more with our intuitive editor.
              </p>
            </div>
            
            <div className="card">
              <h3 className="card-header">🔄 Real-time Collaboration</h3>
              <p>
                Work together with your team in real-time. See changes as 
                they happen and collaborate seamlessly.
              </p>
            </div>
            
            <div className="card">
              <h3 className="card-header">📤 Export & Share</h3>
              <p>
                Export your diagrams to various formats including PNG, SVG, 
                and PlantUML for easy sharing and documentation.
              </p>
            </div>
            
            <div className="card">
              <h3 className="card-header">🎯 UML 2.5 Compliant</h3>
              <p>
                Built with UML 2.5 standards in mind, ensuring your diagrams 
                are accurate and professional.
              </p>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  )
}