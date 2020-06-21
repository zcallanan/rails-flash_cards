class MembershipsController < ApplicationController
  before_action :set_user_group, only: %i[create update]
  before_action :set_membership, only: %i[update]

  def create
    @membership = Membership.new(membership_params)
    @users = User.all
    @membership.owner_id = current_user.id
    @membership.user_group = @user_group
    @users.each do |user|
      if user.email == @membership.email_contact # if the user exists, then bind them to the permission
        @membership.user = user
      else
        # TODO: mailer
        ## if user doesn't exist, send an email, then save their user to this permission once registered
      end
    end
    authorize @membership
    if @membership.save!
      redirect_to user_group_path(@user_group)
    else
      redirect_to user_groups_path
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
end
