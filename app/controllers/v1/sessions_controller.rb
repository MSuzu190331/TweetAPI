module V1
  class SessionsController < ApplicationController
    # このコントローラーのアクションはauthenticate_user_from_token!(トークン認証)をスキップする。
    skip_before_action :authenticate_user_from_token!, except: [:destroy]

    # ユーザーログイン POST /v1/login
    def create
      @user = User.find_for_database_authentication(email: params[:email])
      return invalid_email unless @user

      if @user.valid_password?(params[:password])
        sign_in :user, @user
        render json: @user, serializer: SessionSerializer, root: nil
      else
        invalid_password
      end
    end

    # ユーザーログアウト Delete /v1/logout
    def destroy
      user = User.find(params[:user_id])
        if sign_out(user)
            render :json => {success: true}
        else
            render :json => {success: false}
        end
    end


    private

    def invalid_email
      warden.custom_failure!
      render json: { error: t('invalid_email') }
    end

    def invalid_password
      warden.custom_failure!
      render json: { error: t('invalid_password') }
    end
  end
end