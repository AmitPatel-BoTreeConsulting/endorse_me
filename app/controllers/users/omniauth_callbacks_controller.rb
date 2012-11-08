class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    auth = env['omniauth.auth']
    Rails.logger.info("auth is #{auth.to_yaml}")
    @user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.new

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => 'Twitter') if is_navigational_format?
    else
      session['omniauth.provider'] = auth['provider']
      session['omniauth.uid'] = auth['uid']
      redirect_to new_user_registration_url
    end
  end

  def linkedin
    auth = request.env["omniauth.auth"]
    session['linkedin.token'] = auth.credentials.token
    session['linkedin.secret'] = auth.credentials.secret
    redirect_to linkedin_recommendations_import_url
  end
end