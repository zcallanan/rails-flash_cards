class DeckPolicy < ApplicationPolicy
  class Scope < Scope
    attr_accessor :deck

    def initialize(record)
      @deck = record
    end

    def resolve
      if user.admin?
        scope.all
      elsif user
        scope.where(@deck.owner.id == user.id)
      end
    end
  end
end
