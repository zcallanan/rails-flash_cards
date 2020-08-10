class Api::V1::MembershipsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_user_group, only: %i[create update]
  before_action :set_membership, only: %i[update]

  def create
    # determine owner of the user group
    @owner = @user_group.user
    # params are user_label, email contact, access level - at this point we don't know if entry is a saved user
    @membership = Membership.new(membership_params)
    # assign user group to the membership
    @membership.user_group = @user_group
    # Check if user exists
    contact_user = User.find_by(email: @membership.email_contact)

    unless contact_user.nil?
      # if contact user is not nil then assign the user to the membership
      @membership.user = contact_user
    # else
      # TODO: mailer
          # # if user doesn't exist, send an email, then save their user to this permission once registered
    end

    authorize @membership
    if @membership.save!
      # get all members of a user group
      memberships = Membership.all.where(user_group: @user_group)
      @members = []
      # TODO: This could be simplifed to @members << @owner instead of the loop
      memberships.each do |member|
        @members << member if member == @owner
      end
      # TODO: Simplify to comparison of member to @owner?
      memberships.each { |member| @members << member unless member.user_id == @owner.id }
      render json: {
        partialToAttach:
          render_to_string(
            partial: 'membership_table',
            formats: [:json, :haml],
            layout: false,
            locals: { member: @membership }
          )
      }
      return
    else
      render_error
    end
  end

  def update
    authorize @membership
    if @membership.update!(membership_params)
      redirect_to user_group_path(@user_group)
    else
      redirect_to user_groups_path
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:user_label, :email_contact, :read_access, :update_access)
  end

  def set_user_group
    @user_group = UserGroup.find(params[:user_group_id])
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def render_error
    render json: { errors: @membership.errors.full_messages },
      status: :unprocessable_entity
  end
end
