class QuestionSetPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        # user has read access
        scope.joins(:question_set_permissions).where({ question_set_permissions: { user_id: user.id, read_access: true }})
      elsif user
        # owner of that deck
        scope.where(user_id: user.id)
      end
    end
  end
end
