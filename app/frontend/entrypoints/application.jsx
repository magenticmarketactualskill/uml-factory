// Main application entry point for Inertia React
import { createInertiaApp } from '@inertiajs/react'
import { createRoot } from 'react-dom/client'
import '../styles/application.css'

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob('../pages/**/*.jsx', { eager: true })
    const page = pages[`../pages/${name}.jsx`]
    
    if (!page) {
      console.error(`Page not found: ${name}`)
      return null
    }
    
    return page.default
  },
  setup({ el, App, props }) {
    const root = createRoot(el)
    root.render(<App {...props} />)
  },
})
