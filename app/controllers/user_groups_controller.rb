class UserGroupsController < ApplicationController
  before_action :set_user_group, only: %i[show]

  def index
    @user = current_user
    @user_groups = policy_scope(UserGroup)

    @user_group = UserGroup.new
    @user_group.decks.build
    @deck_strings = []
    @user.decks.each do |deck|
      deck.deck_strings.each do |string|
        @deck_strings << string
      end
    end

    # TODO: Generalize this as a method
    deck_id = 0
    @array = []
    chars = ''
    string_obj = nil
    @deck_strings.each_with_index do |string, index|
      if deck_id.zero?
        chars = string.title
        deck_id = string.deck_id
        string_obj = string
      elsif deck_id == string.deck_id
        chars += " | #{string.title}"
      elsif deck_id != string.deck_id
        @array << [chars, string_obj.deck_id]
        string_obj = string
        chars = string.title
        deck_id = string.deck_id
      end
      @array << [chars, string.deck_id] if index == @deck_strings.length - 1
    end

  end

  def show; end

  def create
    @user_group = UserGroup.new(user_group_params)
    @user_group.user = current_user

    if @user_group.save
      # TODO: Create owner's permission for user group
      params['user_group']['user_group_deck']['deck_id'].each do |deck_id|
        UserGroupDeck.create!(user_group: @user_group, deck: Deck.find(deck_id))
      end
      redirect_to user_group_path(@user_group)
    # else
    #   render :index
    end

    authorize @user_group
  end

  private

  def set_user_group
    @user_group = UserGroup.find(params[:id])
    authorize @user_group
  end

  def user_group_params
    params.require(:user_group).permit(:name, deck_ids: [])
  end
end
