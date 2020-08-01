class AdminsController < ApplicationController
    before_action :authenticate_admin!

    def index
        @admin = current_admin
    end

    def show 
        @users = User.all
    end
  end