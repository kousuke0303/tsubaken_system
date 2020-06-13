# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line; basic_action end
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
  
  private
  
  def basic_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      @profile = UserSocialProfile.where(provider: @omniauth['provider'], uid: @omniauth['uid']).first
      if @profile
        @profile.set_values(@omniauth)
        sign_in :user, @profile.user
      else
        @profile = UserSocialProfile.new(provider: @omniauth['provider'], uid: @omniauth['uid'])
        email = @omniauth['info']['email'] ? @omniauth['info']['email'] : Faker::Internet.email
        @profile.user = current_user || User.create!(email: email, name: @omniauth['info']['name'], password: Devise.friendly_token[0, 20])
        @profile.set_values(@omniauth)
        sign_in :user, @profile.user
        redirect_to top_user_path(@profile.user.id) and return
      end
    end
    redirect_to root_path
  end
end
