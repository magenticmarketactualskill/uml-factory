// Layout component for UML Factory
import { useRouter } from '@inertiajs/juris'

export default function Layout(props) {
  const router = useRouter()
  const auth = props.auth || {}
  const user = auth.user
  
  return {
    tag: 'div',
    props: { className: 'app-layout' },
    children: [
      // Navbar
      {
        tag: 'nav',
        props: { className: 'navbar' },
        children: [
          {
            tag: 'div',
            props: { className: 'navbar-left' },
            children: [
              {
                tag: 'a',
                props: {
                  href: '/',
                  className: 'navbar-brand',
                  onclick: (e) => {
                    e.preventDefault()
                    router.visit('/')
                  }
                },
                children: '🏭 UML Factory'
              },
              user && {
                tag: 'ul',
                props: { className: 'navbar-nav' },
                children: [
                  {
                    tag: 'li',
                    children: {
                      tag: 'a',
                      props: {
                        href: '/projects',
                        className: 'nav-link',
                        onclick: (e) => {
                          e.preventDefault()
                          router.visit('/projects')
                        }
                      },
                      children: 'Projects'
                    }
                  },
                  user.role === 'admin' && {
                    tag: 'li',
                    children: {
                      tag: 'a',
                      props: {
                        href: '/admin/dashboard',
                        className: 'nav-link',
                        onclick: (e) => {
                          e.preventDefault()
                          router.visit('/admin/dashboard')
                        }
                      },
                      children: 'Admin'
                    }
                  }
                ].filter(Boolean)
              }
            ].filter(Boolean)
          },
          {
            tag: 'div',
            props: { className: 'navbar-right' },
            children: user ? [
              {
                tag: 'span',
                props: { className: 'nav-user' },
                children: user.name
              },
              {
                tag: 'a',
                props: {
                  href: '/users/sign_out',
                  className: 'btn btn-secondary',
                  onclick: (e) => {
                    e.preventDefault()
                    router.post('/users/sign_out')
                  }
                },
                children: 'Sign Out'
              }
            ] : [
              {
                tag: 'a',
                props: {
                  href: '/users/sign_in',
                  className: 'btn btn-primary',
                  onclick: (e) => {
                    e.preventDefault()
                    router.visit('/users/sign_in')
                  }
                },
                children: 'Sign In'
              }
            ]
          }
        ]
      },
      
      // Main content
      {
        tag: 'main',
        props: { className: props.containerClass || 'container' },
        children: props.children
      }
    ]
  }
}
