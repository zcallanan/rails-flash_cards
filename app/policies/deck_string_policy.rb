class DeckStringPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        # user has read access
        scope.joins(decks: :deck_permissions).where({ deck_permissions: { user_id: user.id, read_access: true } })
      elsif user
        # owner of that deck
        scope.joins(:decks).where(decks: { user_id: user.id })
      end
    end
  end

  def update?
    user_owns_record? || user_is_admin? || user_can_update?
  end

  private

  def user_owns_record?
    record.deck.user == user
  end

  def user_is_admin?
    # check if user is an admin
    user.admin?
  end

  def user_can_read?
    # check if user can view the deck_string
    record.deck.deck_permissions.where(user_id: user.id, deck_id: record.id, read_access: true).present?
  end

  def user_can_update?
    # check if user can make updates to the deck_string
    record.deck.deck_permissions.where(user_id: user.id, deck_id: record.id, update_access: true).present?
  end
end
