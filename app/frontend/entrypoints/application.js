// Main application entry point for Inertia-Juris
import { createInertiaApp } from '@inertiajs/juris'
import '../styles/application.css'

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob('../pages/**/*.js', { eager: true })
    const page = pages[`../pages/${name}.js`]
    
    if (!page) {
      console.error(`Page not found: ${name}`)
      return null
    }
    
    return page
  },
  setup({ el, App, props }) {
    // App is automatically mounted by Inertia-Juris
    console.log('UML Factory initialized with Inertia-Juris')
  },
})
