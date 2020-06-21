class CollectionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        # user has read access or is the owner
        scope.joins(collection_permissions: { user: :deck_permissions }).where('collection_permissions.user_id = ? AND deck_permissions.user_id = ? AND deck_permissions.read_access = ? OR collections.user_id = ?', user.id, user.id, true, user.id).distinct
      end
    end
  end

  def show?
    user_owns_record? || user_is_admin? || user_can_read?
  end

  def create?
    user_owns_record? || user_is_admin? || user_can_update?
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
    # check if user can view the collection
    record.collection_permissions.where(user_id: user.id, collection_id: record.id, read_access: true).present?
  end

  def user_can_update?
    # check if user can make updates to the collection
    record.collection_permissions.where(user_id: user.id, collection_id: record.id, update_access: true).present?
  end
end
