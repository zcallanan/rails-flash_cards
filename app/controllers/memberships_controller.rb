class MembershipsController < ApplicationController
  before_action set_user_group %i[create update]
  before_action set_membership %i[update]

  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user
    @membership.user_group = @user_group
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
