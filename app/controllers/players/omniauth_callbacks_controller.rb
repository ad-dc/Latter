class Players::OmniauthCallbacksController < Devise::OmniauthCallbacksController  
  def open_id
    # You need to implement the method below in your model
    @player = Player.find_for_open_id(env["omniauth.auth"], current_player)
    if @player.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "OpenID"
      sign_in_and_redirect @player, :event => :authentication
    else
      session["devise.open:id_data"] = env["openid.ext1"]
      redirect_to new_player_registration_url
    end
  end
end