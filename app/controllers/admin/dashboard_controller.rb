module Admin
  class DashboardController < AdminController
    def index
      @stats = {
        users_count: User.count,
        projects_count: Project.count,
        diagrams_count: Diagram.count,
        active_projects: Project.active.count,
        use_case_diagrams: Diagram.use_case_diagrams.count,
        class_diagrams: Diagram.class_diagrams.count,
        sequence_diagrams: Diagram.sequence_diagrams.count
      }
      
      @recent_users = User.order(created_at: :desc).limit(10)
      @recent_diagrams = Diagram.includes(:user, :project).order(created_at: :desc).limit(10)
      
      render inertia: 'Admin/Dashboard', props: {
        stats: @stats,
        recent_users: @recent_users.as_json(only: [:id, :name, :email, :created_at]),
        recent_diagrams: @recent_diagrams.as_json(include: [:user, :project])
      }
    end
    
    def infrastructure
      @uml_store_config = {
        storage_backend: UMLStore.configuration.storage_backend,
        storage_path: UMLStore.configuration.storage_path,
        validate_on_store: UMLStore.configuration.validate_on_store
      }
      
      @database_stats = {
        database_size: ActiveRecord::Base.connection.execute(
          "SELECT pg_size_pretty(pg_database_size(current_database()))"
        ).first['pg_size_pretty'],
        tables_count: ActiveRecord::Base.connection.tables.count
      }
      
      render inertia: 'Admin/Infrastructure', props: {
        uml_store_config: @uml_store_config,
        database_stats: @database_stats
      }
    end
    
    def users
      @users = User.all.order(created_at: :desc)
      
      render inertia: 'Admin/Users', props: {
        users: @users.as_json(
          only: [:id, :name, :email, :role, :created_at],
          methods: [:projects_count, :diagrams_count]
        )
      }
    end
    
    def financial
      # Placeholder for financial data
      render inertia: 'Admin/Financial', props: {
        message: 'Financial tracking coming soon'
      }
    end
  end
end
