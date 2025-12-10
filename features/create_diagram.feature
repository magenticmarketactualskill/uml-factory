Feature: Create UML Diagram
  As a user
  I want to create UML diagrams
  So that I can model my system

  Background:
    Given I am a registered user
    And I am signed in
    And I have a project named "My Project"

  Scenario: Create a class diagram
    When I visit the project page
    And I click "New Diagram"
    And I fill in "Name" with "Domain Model"
    And I select "Class" from "Diagram Type"
    And I click "Create Diagram"
    Then I should see "Diagram was successfully created"
    And I should be on the diagram editor page
    And I should see "Domain Model"

  Scenario: Create a use case diagram
    When I visit the project page
    And I click "New Diagram"
    And I fill in "Name" with "User Stories"
    And I select "Use Case" from "Diagram Type"
    And I click "Create Diagram"
    Then I should see "Diagram was successfully created"
    And I should be on the diagram editor page
    And I should see "User Stories"

  Scenario: Add elements to a class diagram
    Given I have a class diagram named "Domain Model"
    When I visit the diagram editor
    And I click on "Class" in the palette
    And I click on the canvas at position (200, 150)
    Then I should see a new class element on the canvas
    And the element should have default properties
