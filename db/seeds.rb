# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# Create admin user
admin = User.find_or_create_by!(email: 'admin@uml-factory.com') do |user|
  user.name = 'Admin User'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = 'admin'
end
puts "✓ Created admin user: #{admin.email}"

# Create regular user
user = User.find_or_create_by!(email: 'user@example.com') do |u|
  u.name = 'Demo User'
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.role = 'user'
end
puts "✓ Created demo user: #{user.email}"

# Create sample project
project = Project.find_or_create_by!(name: 'E-Commerce System', user: user) do |p|
  p.description = 'A sample e-commerce system with user management, product catalog, and order processing'
  p.status = 'active'
end
puts "✓ Created project: #{project.name}"

# Create use case diagram
use_case_diagram = Diagram.find_or_create_by!(
  name: 'User Management Use Cases',
  project: project,
  user: user
) do |d|
  d.diagram_type = 'use_case'
  d.metadata = { zoom: 1.0, pan: { x: 0, y: 0 } }
end
puts "✓ Created use case diagram: #{use_case_diagram.name}"

# Add actors to use case diagram
customer = DiagramElement.find_or_create_by!(
  diagram: use_case_diagram,
  element_type: 'actor'
) do |e|
  e.position = { x: 50, y: 100 }
  e.properties = { name: 'Customer', description: 'End user of the system' }
end

admin_actor = DiagramElement.find_or_create_by!(
  diagram: use_case_diagram,
  element_type: 'actor'
) do |e|
  e.position = { x: 50, y: 300 }
  e.properties = { name: 'Administrator', description: 'System administrator' }
end

# Add use cases
login_uc = DiagramElement.find_or_create_by!(
  diagram: use_case_diagram,
  element_type: 'use_case'
) do |e|
  e.position = { x: 250, y: 100 }
  e.properties = {
    name: 'Login',
    description: 'User authentication',
    preconditions: 'User has valid credentials',
    postconditions: 'User is authenticated'
  }
end

browse_uc = DiagramElement.find_or_create_by!(
  diagram: use_case_diagram,
  element_type: 'use_case'
) do |e|
  e.position = { x: 250, y: 200 }
  e.properties = {
    name: 'Browse Products',
    description: 'View product catalog'
  }
end

manage_uc = DiagramElement.find_or_create_by!(
  diagram: use_case_diagram,
  element_type: 'use_case'
) do |e|
  e.position = { x: 250, y: 300 }
  e.properties = {
    name: 'Manage Products',
    description: 'Add, edit, delete products'
  }
end

puts "✓ Created use case diagram elements"

# Create class diagram
class_diagram = Diagram.find_or_create_by!(
  name: 'Domain Model',
  project: project,
  user: user
) do |d|
  d.diagram_type = 'class'
  d.metadata = { zoom: 1.0, pan: { x: 0, y: 0 } }
end
puts "✓ Created class diagram: #{class_diagram.name}"

# Add classes
user_class = DiagramElement.find_or_create_by!(
  diagram: class_diagram,
  element_type: 'class'
) do |e|
  e.position = { x: 100, y: 100 }
  e.properties = {
    name: 'User',
    visibility: 'public',
    isAbstract: false,
    attributes: [
      { name: 'id', type: 'Integer', visibility: 'private' },
      { name: 'email', type: 'String', visibility: 'private' },
      { name: 'name', type: 'String', visibility: 'private' }
    ],
    operations: [
      { name: 'authenticate', visibility: 'public', parameters: ['password'], returnType: 'Boolean' },
      { name: 'updateProfile', visibility: 'public', parameters: ['data'], returnType: 'void' }
    ]
  }
end

product_class = DiagramElement.find_or_create_by!(
  diagram: class_diagram,
  element_type: 'class'
) do |e|
  e.position = { x: 350, y: 100 }
  e.properties = {
    name: 'Product',
    visibility: 'public',
    isAbstract: false,
    attributes: [
      { name: 'id', type: 'Integer', visibility: 'private' },
      { name: 'name', type: 'String', visibility: 'private' },
      { name: 'price', type: 'Decimal', visibility: 'private' },
      { name: 'stock', type: 'Integer', visibility: 'private' }
    ],
    operations: [
      { name: 'updateStock', visibility: 'public', parameters: ['quantity'], returnType: 'void' },
      { name: 'isAvailable', visibility: 'public', parameters: [], returnType: 'Boolean' }
    ]
  }
end

order_class = DiagramElement.find_or_create_by!(
  diagram: class_diagram,
  element_type: 'class'
) do |e|
  e.position = { x: 225, y: 300 }
  e.properties = {
    name: 'Order',
    visibility: 'public',
    isAbstract: false,
    attributes: [
      { name: 'id', type: 'Integer', visibility: 'private' },
      { name: 'orderDate', type: 'DateTime', visibility: 'private' },
      { name: 'status', type: 'String', visibility: 'private' },
      { name: 'total', type: 'Decimal', visibility: 'private' }
    ],
    operations: [
      { name: 'calculateTotal', visibility: 'public', parameters: [], returnType: 'Decimal' },
      { name: 'cancel', visibility: 'public', parameters: [], returnType: 'void' }
    ]
  }
end

puts "✓ Created class diagram elements"

# Create sequence diagram
sequence_diagram = Diagram.find_or_create_by!(
  name: 'Order Processing Sequence',
  project: project,
  user: user
) do |d|
  d.diagram_type = 'sequence'
  d.metadata = { zoom: 1.0, pan: { x: 0, y: 0 } }
end
puts "✓ Created sequence diagram: #{sequence_diagram.name}"

# Add lifelines
customer_lifeline = DiagramElement.find_or_create_by!(
  diagram: sequence_diagram,
  element_type: 'lifeline'
) do |e|
  e.position = { x: 100, y: 50 }
  e.properties = { name: 'customer', type: 'Customer' }
end

order_lifeline = DiagramElement.find_or_create_by!(
  diagram: sequence_diagram,
  element_type: 'lifeline'
) do |e|
  e.position = { x: 250, y: 50 }
  e.properties = { name: 'order', type: 'Order' }
end

product_lifeline = DiagramElement.find_or_create_by!(
  diagram: sequence_diagram,
  element_type: 'lifeline'
) do |e|
  e.position = { x: 400, y: 50 }
  e.properties = { name: 'product', type: 'Product' }
end

puts "✓ Created sequence diagram elements"

puts "\n✅ Database seeded successfully!"
puts "\nLogin credentials:"
puts "  Admin: admin@uml-factory.com / password123"
puts "  User:  user@example.com / password123"
