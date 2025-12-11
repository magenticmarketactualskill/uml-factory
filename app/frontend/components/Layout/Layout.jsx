// Layout component for UML Factory
import React from 'react'
import { router } from '@inertiajs/react'

export default function Layout({ auth = {}, children, containerClass = 'container' }) {
  const user = auth.user

  const handleNavigation = (url) => (e) => {
    e.preventDefault()
    router.visit(url)
  }

  const handleSignOut = (e) => {
    e.preventDefault()
    router.post('/users/sign_out')
  }

  return (
    <div className="app-layout">
      {/* Navbar */}
      <nav className="navbar">
        <div className="navbar-left">
          <a 
            href="/" 
            className="navbar-brand"
            onClick={handleNavigation('/')}
          >
            🏭 UML Factory
          </a>
          {user && (
            <ul className="navbar-nav">
              <li>
                <a 
                  href="/projects" 
                  className="nav-link"
                  onClick={handleNavigation('/projects')}
                >
                  Projects
                </a>
              </li>
              {user.role === 'admin' && (
                <li>
                  <a 
                    href="/admin/dashboard" 
                    className="nav-link"
                    onClick={handleNavigation('/admin/dashboard')}
                  >
                    Admin
                  </a>
                </li>
              )}
            </ul>
          )}
        </div>
        <div className="navbar-right">
          {user ? (
            <>
              <span className="nav-user">{user.name}</span>
              <a 
                href="/users/sign_out" 
                className="btn btn-secondary"
                onClick={handleSignOut}
              >
                Sign Out
              </a>
            </>
          ) : (
            <a 
              href="/users/sign_in" 
              className="btn btn-primary"
              onClick={handleNavigation('/users/sign_in')}
            >
              Sign In
            </a>
          )}
        </div>
      </nav>
      
      {/* Main content */}
      <main className={containerClass}>
        {children}
      </main>
    </div>
  )
}