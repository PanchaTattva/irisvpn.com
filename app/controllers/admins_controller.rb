class AdminsController < ApplicationController
    before_action :authenticate_admin!

    def index
        @admin = current_admin
    end

    def show 
        @users = User.all
    end

    def user_activate
        users = User.where(id: params[:id], account_status: "inactive").exists?(conditions = :none)

        if users
            User.update(params[:id], account_status: "active")
            name = User.where(id: params[:id]).pluck(:email)
            name = name[0].split('@')[0]
            generate_ovpn_user = `/bin/sh /easy-rsa/new_client.sh #{name}`
            puts generate_ovpn_user
        else
            User.update(params[:id], account_status: "inactive")
        end

        redirect_to admins_show_path
    end
end
