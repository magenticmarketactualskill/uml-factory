FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "User #{n}" }
    password { "password123" }
    password_confirmation { "password123" }
    role { "user" }

    trait :admin do
      role { "admin" }
    end
  end

  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { "A test project" }
    status { "active" }
    association :user

    trait :archived do
      status { "archived" }
    end
  end

  factory :diagram do
    sequence(:name) { |n| "Diagram #{n}" }
    diagram_type { "class" }
    metadata { { zoom: 1.0, pan: { x: 0, y: 0 } } }
    association :project
    association :user

    trait :use_case do
      diagram_type { "use_case" }
    end

    trait :class_diagram do
      diagram_type { "class" }
    end

    trait :sequence do
      diagram_type { "sequence" }
    end
  end

  factory :diagram_element do
    element_type { "class" }
    position { { x: 100, y: 100 } }
    properties { { name: "TestClass", visibility: "public", attributes: [], operations: [] } }
    association :diagram

    trait :actor do
      element_type { "actor" }
      properties { { name: "User", description: "System user" } }
    end

    trait :use_case do
      element_type { "use_case" }
      properties { { name: "Login", description: "User login process" } }
    end

    trait :lifeline do
      element_type { "lifeline" }
      properties { { name: "object1", type: "Object" } }
    end
  end

  factory :diagram_relationship do
    relationship_type { "association" }
    properties { {} }
    association :diagram
    association :source_element, factory: :diagram_element
    association :target_element, factory: :diagram_element

    trait :generalization do
      relationship_type { "generalization" }
    end

    trait :include do
      relationship_type { "include" }
    end

    trait :message do
      relationship_type { "synchronous_message" }
      properties { { message: "doSomething()" } }
    end
  end
end
