class UserGroupsController < ApplicationController
  before_action :set_user_group, only: %i[show]

  def index
    @user = current_user
    @user_groups = policy_scope(UserGroup)
    @user_group = UserGroup.new
    # prepare simple_field usage
    @user_group.decks.build
    @user_group.collections.build
    @user_group.question_sets.build
    # generate option arrays for form fields
    @deck_select = select_options(@user, 'decks', 'deck_strings', 'deck_id')
    @collection_select = select_options(@user, 'collections', 'collection_strings', 'collection_id')
    @question_set_select = select_options(@user, 'question_sets', 'question_set_strings', 'question_set_id')
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
      params['user_group']['user_group_deck']['deck_id'].each { |id| UserGroupDeck.create!(user_group: @user_group, deck: Deck.find(id)) }
      params['user_group']['user_group_collection']['collection_id'].each { |id| UserGroupCollection.create!(user_group: @user_group, collection: Collection.find(id)) }
      params['user_group']['user_group_question_set']['question_set_id'].each { |id| UserGroupQuestionSet.create!(user_group: @user_group, question_set: QuestionSet.find(id)) }
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
    params.require(:user_group).permit(:name, deck_ids: [], collection_ids: [], question_set_ids: [])
  end

  def generate_options(object_list, id_string)
    # returns an array of object titles for select form fields
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

  def select_options(user, objects, method, id_string)
    # objects ~ decks, method ~ deck_strings, id_string ~ deck_id
    object_list = []
    user.send(objects).each { |object| object.send(method).each { |string| object_list << string } }
    generate_options(object_list, id_string)
  end
end
