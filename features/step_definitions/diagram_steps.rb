Given('I am a registered user') do
  @user = FactoryBot.create(:user, email: 'test@example.com', password: 'password123')
end

Given('I am signed in') do
  visit '/users/sign_in'
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password123'
  click_button 'Sign in'
end

Given('I have a project named {string}') do |project_name|
  @project = FactoryBot.create(:project, name: project_name, user: @user)
end

Given('I have a class diagram named {string}') do |diagram_name|
  @diagram = FactoryBot.create(:diagram, :class_diagram, name: diagram_name, project: @project, user: @user)
end

When('I visit the project page') do
  visit project_path(@project)
end

When('I visit the diagram editor') do
  visit project_diagram_path(@project, @diagram)
end

When('I click {string}') do |button_text|
  click_link_or_button button_text
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I select {string} from {string}') do |value, field|
  select value, from: field
end

When('I click on {string} in the palette') do |element_type|
  find('.palette-item', text: element_type).click
end

When('I click on the canvas at position ({int}, {int})') do |x, y|
  find('.canvas-svg').click(x: x, y: y)
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should be on the diagram editor page') do
  expect(current_path).to match(%r{/projects/\d+/diagrams/\d+})
end

Then('I should see a new class element on the canvas') do
  expect(page).to have_css('.uml-class')
end

Then('the element should have default properties') do
  expect(page).to have_content('NewClass')
end
