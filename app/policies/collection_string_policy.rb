class CollectionStringPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        scope.includes(collections: { decks: :deck_permissions }).where('deck_permissions.user_id = ? AND deck_permissions.read_access = ? AND deck_permissions.language = ? OR collections.user_id = ?', user.id, true, scope.language, user.id).references(collections: { decks: :deck_permissions }).distinct
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
    record.collection.deck.deck_permissions.where(user_id: user.id, deck_id: record.collection.deck.id, read_access: true).present?
  end

  def user_can_update?
    # check if user can make updates to the deck_string
    record.collection.deck.deck_permissions.where(user_id: user.id, deck_id: record.collection.deck.id, update_access: true).present?
  end
end
