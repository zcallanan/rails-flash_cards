class UserGroupsController < ApplicationController
  before_action :set_user_group, only: %i[show]

  def index
    @user = current_user
    @user_groups = policy_scope(UserGroup)

    @user_group = UserGroup.new
    @user_group.decks.build
    @deck_strings = []
    @collection_strings = []
    @question_set_strings = []
    @user.decks.each { |deck| deck.deck_strings.each { |string| @deck_strings << string } }
    @user.collections.each { |collection| collection.collection_strings.each { |string| @collection_strings << string } }
    @user.question_sets.each { |question_set| question_set.question_set_strings.each { |string| @question_set_strings << string } }
    @deck_select = generate_options(@deck_strings, 'deck_id')
    @collection_select = generate_options(@collection_strings, 'collection_id')
    @question_set_select = generate_options(@question_set_strings, 'question_set_id')
  end

  def show; end

  def create
    @user_group = UserGroup.new(user_group_params)
    @user_group.user = current_user

    if @user_group.save
      Membership.create!(
        user: current_user,
        user_group: @user_group,
        user_label: "Group Owner",
        confirmed: true,
        read_access: true,
        update_access: true
      )
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

  def generate_options(object_list, id_string)
    num_id = 0
    array = []
    chars = ''
    string_obj = nil
    object_list.each_with_index do |string, index|
      if num_id.zero?
        chars = string.title
        num_id = string.send(id_string)
        string_obj = string
      elsif num_id == string.send(id_string)
        chars += " | #{string.title}"
      elsif num_id != string.send(id_string)
        array << [chars, string_obj.send(id_string)]
        string_obj = string
        chars = string.title
        num_id = string.send(id_string)
      end
      array << [chars, string.send(id_string)] if index == object_list.length - 1
    end
    array
  end
end