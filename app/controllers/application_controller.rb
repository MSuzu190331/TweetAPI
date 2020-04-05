class ApplicationController < ActionController::API
  include AbstractController::Translation

  # 各アクション実行前に実行
  before_action :authenticate_user_from_token!

  respond_to :json

  ##
  # User Authentication

  # トークンによる認証
  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authenticate_error
    end
  end

  private

  def authenticate_with_auth_token auth_token
    unless auth_token.include?(':')
      authenticate_error
      return
    end

    user_id = auth_token.split(':').first
    user = User.where(id: user_id).first

    if user && Devise.secure_compare(user.access_token, auth_token)
      # User can access
      sign_in user, store: false
    else
      authenticate_error
    end
  end

    # 401エラーを返す
    def authenticate_error
      render json: { error: t('devise.failure.unauthenticated') }, status: 401
    end
end
