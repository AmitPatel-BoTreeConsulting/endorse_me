class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    @user = User.new(params[:user])
    @user.uid = session['omniauth.uid']
    @user.provider = session['omniauth.provider']
    @user.password = Devise.friendly_token[0, 20]
    @user.encrypted_password = Devise.friendly_token[0, 20]
    if @user.save
      sign_in_and_redirect @user, event: :authentication
    else
      render action: 'new'
    end
  end

  def update
    super
  end

end
