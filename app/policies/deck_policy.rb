class DeckPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        scope.joins(:deck_permissions).where({ deck_permissions: { user_id: user.id, read_access: true } })
      elsif user
        scope.where(user_id: user.id)
      end
    end
  end

  def index?
    user_owns_record? || user_is_admin?
  end

  def show?
    user_owns_record? || user_is_admin?
  end

  def create?
    user_owns_record? || user_is_admin?
  end

  def update?
    user_owns_record? || user_is_admin?
  end

  def destroy?
    user_owns_record? || user_is_admin?
  end

  private

  def user_owns_record?
    record.user == user # user here is the current_user
  end

  def user_is_admin?
    # check if current_user (user) is an admin
    user.admin?
  end
end
