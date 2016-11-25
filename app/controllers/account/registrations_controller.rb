class Account::RegistrationsController < Devise::RegistrationsController
  before_filter :authorize_church

  protected

  def authorize_church
    redirect_to new_session_path(resource_name) unless current_church.can_sign_up?
  end

  def after_sign_up_path_for(resource)
    new_account_person_path
  end
end
