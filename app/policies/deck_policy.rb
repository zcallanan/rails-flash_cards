class DeckPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        scope.joins(:deck_permissions).where('deck_permissions.user_id = ? AND deck_permissions.read_access = ? AND decks.user_id != ? OR decks.global_deck_read = ? OR decks.user_id = ?', user.id, true, user.id, true, user.id).distinct
      end
    end
  end

  def show?
    user_owns_record? || user_is_admin? || user_can_read? || record_is_global?
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

  def record_is_global?
    record.global_deck_read == true
  end

  def user_owns_record?
    record.user == user
  end

  def user_is_admin?
    # check if user is an admin
    user.admin?
  end

  def user_can_read?
    # check if user can view the deck
    record.deck_permissions.where(user_id: user.id, deck_id: record.id, read_access: true).present?
  end

  def user_can_update?
    # check if user can make updates to the deck
    record.deck_permissions.where(user_id: user.id, deck_id: record.id, update_access: true).present?
  end
end
