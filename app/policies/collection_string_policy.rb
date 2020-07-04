class CollectionStringPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        scope.includes(collections: :collection_permissions).where('collection_permissions.user_id = ? AND collection_permissions.read_access = ? AND collection_permissions.language = ? OR collections.user_id = ?', user.id, true, scope.language, user.id).references(collections: :collection_permissions).distinct
      end
    end
  end

  def create?
    user_owns_record? || user_is_admin? || user_can_update?
  end

  def update?
    user_owns_record? || user_is_admin? || user_can_update?
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
    # check if user can view the deck_string
    record.collection.collection_permissions.where(user_id: user.id, collection_id: record.id, read_access: true).present?
  end

  def user_can_update?
    # check if user can make updates to the deck_string
    record.collection.collection_permissions.where(user_id: user.id, collection_id: record.id, update_access: true).present?
  end
end
