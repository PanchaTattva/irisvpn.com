class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find_by(email: current_user.email)
  end

  def download_ovpn_file
    path = "/easy-rsa/vpn_users/"
    user = current_user.email.split('@')[0]
    filename ="#{path}#{user}.ovpn"

    send_file(filename, :filename => "#{user}.ovpn")
  end

  def subscribe
  end
end

