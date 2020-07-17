class Api::V1::CategoriesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: %i[removed_all enabled_all]
  before_action :authenticate_user!, except: %i[removed_all enabled_all]

  def removed_all
    @categories = Category.disabled_all

    render json: @categories
  end

  def enabled_all
    @categories = Category.enabled_all

    render json: @categories
  end
end
