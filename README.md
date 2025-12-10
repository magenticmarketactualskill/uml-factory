# UML Factory

A modern Ruby on Rails 8 application for creating and managing UML diagrams with an intuitive, Model-Aware editor.

## Features

- **Rails 8** - Latest Rails framework with modern conventions
- **Inertia Rails 3** - Server-driven single-page application framework
- **JurisJS Frontend** - Lightweight reactive JavaScript framework via inertia-juris integration
- **UML Store Integration** - Persistent UML 2.5 model storage with RDF/Linked Data
- **Model-Aware Editor** - Intelligent hover tooltips revealing UML element details
- **Multiple Diagram Types**:
  - Use Case Diagrams
  - Class Diagrams
  - Sequence Diagrams
- **Real-time Validation** - SHACL-based UML model validation
- **Export Capabilities** - Export to JSON, PlantUML formats
- **Authorization** - Pundit-based authorization system
- **Admin Dashboard** - Infrastructure, users, and financial management
- **Comprehensive Testing** - RSpec and Cucumber test suites

## Architecture

### Backend (Rails 8)

- **Models**: User, Project, Diagram, DiagramElement, DiagramRelationship
- **Controllers**: RESTful controllers with Inertia rendering
- **Policies**: Pundit authorization for projects and diagrams
- **UML Store**: Integration with uml-store gem for UML 2.5 persistence

### Frontend (JurisJS)

- **Pages**: Home, Projects, Diagrams/Editor, Admin
- **Components**:
  - Layout: Navigation and authentication
  - Canvas: SVG-based diagram rendering with drag-and-drop
  - Palette: Element selection for diagram types
  - Toolbar: Zoom, validate, export controls
  - PropertiesPanel: Element property editing
  - ElementTooltip: Model-Aware hover behavior
- **Styles**: GitHub Primer-inspired design system

## Prerequisites

- Ruby 3.3.0
- PostgreSQL 12+
- Node.js 18+
- Redis (for Action Cable)

## Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd uml-factory
```

2. **Install dependencies**

```bash
# Install Ruby gems
bundle install

# Install JavaScript packages
npm install
```

3. **Setup database**

```bash
# Create and migrate database
rails db:create
rails db:migrate

# Seed initial data (optional)
rails db:seed
```

4. **Configure environment**

```bash
# Copy example environment file
cp .env.example .env

# Edit .env with your configuration
# - Database credentials
# - Secret keys
# - UML Store configuration
```

5. **Start the development server**

```bash
# Start Rails server
rails server

# In another terminal, start Vite dev server
bin/vite dev
```

6. **Access the application**

Open your browser and navigate to `http://localhost:3000`

## Usage

### Creating a Project

1. Sign up or sign in
2. Click "New Project"
3. Enter project name and description
4. Click "Create Project"

### Creating a Diagram

1. Navigate to a project
2. Click "New Diagram"
3. Select diagram type (Use Case, Class, or Sequence)
4. Enter diagram name
5. Click "Create Diagram"

### Using the Editor

**Element Palette**
- Click an element type from the left palette
- Click on the canvas to place the element

**Model-Aware Tooltips**
- Hover over any element to see its UML details
- For classes: view attributes and operations
- For use cases: view preconditions and postconditions

**Properties Panel**
- Select an element to view/edit its properties
- Modify name, visibility, attributes, operations
- Click "Save Changes" to persist

**Toolbar Actions**
- **Zoom In/Out**: Adjust canvas zoom level
- **Validate**: Check UML model conformance
- **Export**: Download as JSON or PlantUML
- **Save**: Persist diagram changes

### Admin Dashboard

Administrators can access:
- **Dashboard**: System statistics and recent activity
- **Infrastructure**: UML Store and database configuration
- **Users**: User management and statistics
- **Financial**: Financial tracking (placeholder)

## Testing

### RSpec (Unit & Integration Tests)

```bash
# Run all specs
bundle exec rspec

# Run specific spec file
bundle exec rspec spec/models/diagram_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Cucumber (BDD Features)

```bash
# Run all features
bundle exec cucumber

# Run specific feature
bundle exec cucumber features/diagrams.feature
```

## Deployment

### Production Setup

1. **Precompile assets**

```bash
RAILS_ENV=production rails assets:precompile
```

2. **Setup production database**

```bash
RAILS_ENV=production rails db:migrate
```

3. **Configure environment variables**

- `DATABASE_URL`
- `SECRET_KEY_BASE`
- `RAILS_ENV=production`
- `RAILS_LOG_TO_STDOUT=true`

4. **Start production server**

```bash
RAILS_ENV=production rails server
```

### Docker Deployment (Optional)

```bash
# Build image
docker build -t uml-factory .

# Run container
docker run -p 3000:3000 \
  -e DATABASE_URL=<postgres-url> \
  -e SECRET_KEY_BASE=<secret> \
  uml-factory
```

## API

### REST Endpoints

```
GET    /projects                    # List projects
POST   /projects                    # Create project
GET    /projects/:id                # Show project
PATCH  /projects/:id                # Update project
DELETE /projects/:id                # Delete project

GET    /projects/:project_id/diagrams              # List diagrams
POST   /projects/:project_id/diagrams              # Create diagram
GET    /projects/:project_id/diagrams/:id          # Show/edit diagram
PATCH  /projects/:project_id/diagrams/:id          # Update diagram
DELETE /projects/:project_id/diagrams/:id          # Delete diagram
GET    /projects/:project_id/diagrams/:id/export   # Export diagram
POST   /projects/:project_id/diagrams/:id/validate # Validate diagram

POST   /projects/:project_id/diagrams/:diagram_id/diagram_elements
PATCH  /projects/:project_id/diagrams/:diagram_id/diagram_elements/:id
DELETE /projects/:project_id/diagrams/:diagram_id/diagram_elements/:id

POST   /projects/:project_id/diagrams/:diagram_id/diagram_relationships
PATCH  /projects/:project_id/diagrams/:diagram_id/diagram_relationships/:id
DELETE /projects/:project_id/diagrams/:diagram_id/diagram_relationships/:id
```

## Technology Stack

- **Backend**: Ruby on Rails 8.0
- **Frontend**: JurisJS (via inertia-juris)
- **Database**: PostgreSQL
- **Cache**: Redis
- **Asset Pipeline**: Vite
- **Authentication**: Devise
- **Authorization**: Pundit
- **UML Storage**: uml-store gem (RDF/Linked Data)
- **Testing**: RSpec, Cucumber, FactoryBot
- **UI Components**: Primer View Components

## Project Structure

```
uml-factory/
├── app/
│   ├── controllers/          # Rails controllers
│   ├── models/               # ActiveRecord models
│   ├── policies/             # Pundit authorization policies
│   ├── views/                # ERB layouts
│   └── frontend/             # JurisJS frontend
│       ├── entrypoints/      # Vite entry points
│       ├── pages/            # Inertia pages
│       ├── components/       # Reusable components
│       ├── services/         # API services
│       ├── hooks/            # Custom hooks
│       └── styles/           # CSS stylesheets
├── config/                   # Rails configuration
├── db/                       # Database migrations and seeds
├── spec/                     # RSpec tests
├── features/                 # Cucumber features
├── lib/                      # Library code
└── public/                   # Static assets
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or contributions, please open an issue on GitHub.

## Acknowledgments

- **uml-store** - UML 2.5 model storage and validation
- **iac-factory-gui** - Inspiration for UI patterns
- **inertia-juris** - Inertia.js adapter for JurisJS
- **JurisJS** - Lightweight reactive JavaScript framework
- **Rails** - Web application framework
- **Primer** - GitHub's design system

---

Built with ❤️ using Rails 8, Inertia Rails 3, and JurisJS
