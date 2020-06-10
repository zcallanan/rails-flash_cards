class DeckPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        scope.joins(deck_permissions: [:deck]).where(
          user.id = deck.owner.id
        ).or(scope.joins(deck_permissions: [:deck]).where(
          deck_permissions.user_id = user.id,
          deck_permissions.deck_id = deck.id,
          deck_permissions.read_access = true
        ))
      end
    end
  end
end
