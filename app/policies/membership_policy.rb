class MembershipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        # user has read access or user is owner
        scope.where('memberships.read_access = ? OR memberships.user_id = ?', true, user.id).distinct
      end
    end
  end

  def create?
    user_owns_record? || user_is_admin? || user_owns_record? || user_is_owner?
  end

  def update?
    user_owns_record? || user_is_admin? || user_can_update?
  end

  private

  def user_owns_record?
    # for the new case
    record.user == user
  end

  def user_is_owner?
    # for the create case
    record.owner_id == user.id
  end

  def user_is_admin?
    # check if user is an admin
    user.admin?
  end

  def user_can_read?
    # check if user can view the user_group
    record.where(user_id: user.id, read_access: true).present?
  end

  def user_can_update?
    # check if user can make updates to the collection
    record.where(user_id: user.id, read_access: true, update_access: true).present?
  end
end
