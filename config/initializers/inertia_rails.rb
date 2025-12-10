# Inertia Rails configuration
InertiaRails.configure do |config|
  # Set the version to force full page reloads when assets change
  # This can be a string, a proc, or a lambda
  config.version = ViteRuby.digest rescue '1.0'
  
  # Deep merge shared data with page props
  config.deep_merge_shared_data = false
  
  # Enable default rendering (render inertia by default)
  config.default_render = false
  
  # SSR configuration (optional, for server-side rendering)
  # config.ssr_enabled = Rails.env.production?
  # config.ssr_url = 'http://localhost:13714'
end
