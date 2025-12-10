# User model extensions for statistics
class User < ApplicationRecord
  def projects_count
    projects.count
  end

  def diagrams_count
    diagrams.count
  end
end
