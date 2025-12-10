class DiagramPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(:project).where(projects: { user_id: user.id })
      end
    end
  end

  def show?
    user.admin? || record.project.user_id == user.id
  end

  def create?
    user.present?
  end

  def update?
    user.admin? || record.project.user_id == user.id
  end

  def destroy?
    user.admin? || record.project.user_id == user.id
  end

  def export?
    show?
  end

  def validate?
    show?
  end
end
