class UserGroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        # user has read access
        scope.joins(:memberships).where({ memberships: { user_id: user.id, read_access: true } })
      elsif user
        # owner of that user_group
        scope.where(user_id: user.id)
      end
    end
  end

  def show?
    user_owns_record? || user_is_admin? || user_can_read?
  end

  def create?
    user_owns_record? || user_is_admin?
  end

  def update?
    user_owns_record? || user_is_admin? || user_can_update?
  end

  def destroy?
    user_owns_record? || user_is_admin?
  end

  private

  def user_owns_record?
    record.user == user
  end

  def user_is_admin?
    # check if user is an admin
    user.admin?
  end

  def user_can_read?
    # check if user can view the user_group
    record.memberships.where(user_id: user.id, user_group_id: record.id, read_access: true).present?
  end

  def user_can_update?
    # check if user can make updates to the collection
    record.memberships.where(user_id: user.id, user_group_id: record.id, update_access: true).present?
  end
end
