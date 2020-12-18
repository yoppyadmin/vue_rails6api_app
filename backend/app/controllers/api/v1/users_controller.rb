module Api
  module V1
    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # ログイン必須を促す'before_action'
      before_action :correct_user,   only: [:edit, :update] # ログインしているユーザーとリクエストを送信してくるユーザーが一致するかどうかを確認する'before_action'
      before_action :admin_user,     only: :destroy # ユーザーを削除するアクションはadmin属性がtrueのユーザーに限定する'before_action'

      def index
        users = User.all.order(created_at: :DESC)
        render json: { users: users, user: @current_user }
      end

      def show
        user = User.find(params[:id])
        render json: { user: user }
      end

      def new
        if @current_user
          render json: { user: @current_user }
        else
          user = User.new
          render json: { user: user }
        end
      end

      def create
        user = User.new(user_params)
        user.avatar = File.open(Rails.root.join("public/default.png"))
        if user.save
          # account = user.build_account(account_number: user.id)
          # account.save
          # session[:user_id] = user.id
          render json: { message: "ユーザー作成に成功しました", user: user }
        else
          render json: { message: "ユーザー作成に失敗しました", errors: user.errors }
        end
      end

      def edit
        render json: { user: @current_user }
      end

      def update
        if @current_user.update(user_params)
          render json: { message: "ユーザー情報の編集に成功しました", user: @current_user }
        else
          render json: { message: "ユーザー情報の編集に失敗しました", user: @current_user, errors: @current_user.errors }
        end
      end

      def destroy
        user = User.find(params[:id])
        delete_user_id = user.id
        user.destroy
        users = User.all.order(created_at: :DESC)
        render json: { message: "ユーザー#{delete_user_id}を削除しました", users: users }
      end

      private

        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
        end

        # ログインしているユーザーがいない場合、ステータスコード401を返す
        def logged_in_user
          return if @current_user

          session[:forwarding_url] = request.fullpath if request.get? # 送信されたリクエストがGETリクエストの場合、パスを保存
          render json: { status: 401, message: "Unauthorized" }
        end

        # ログインしているユーザーとリクエストを送信するユーザーが一致しない場合、ステータスコード401を返す
        def correct_user
          user = User.find(params[:id])
          render json: { status: 401, message: "Unauthorized" } unless user == @current_user
        end

        # ログインしているユーザーがadminユーザーでない場合、ステータスコード401を返す
        def admin_user
          return if @current_user.admin?

          render json: { status: 401, message: "unauthorized" }
        end
    end
  end
end
