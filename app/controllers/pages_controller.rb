class PagesController < ApplicationController
  include Languages
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @languages = Languages.search
    @category = Category.new
    @categories = Category.all
  end
end
