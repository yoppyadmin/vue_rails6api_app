module Api
  module V1
    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # ログイン必須を促す'before_action'
      before_action :correct_user,   only: [:edit, :update] # ログインしているユーザーとリクエストを送信してくるユーザーが一致するかどうかを確認する'before_action'
      before_action :admin_user,     only: :destroy # ユーザーを削除するアクションはadmin属性がtrueのユーザーに限定する'before_action'

      def index
        users = User.all.order(created_at: :DESC)
        render json: { users: users, auth_user: @current_user }
      end

      def show
        user = User.find(params[:id])
        user_posts_join_quantities_created_at_desc = Post.joins(:user, :quantity).select('
          posts.*,
          users.avatar,
          quantities.quantity_list_1,
          quantities.quantity_list_2,
          quantities.quantity_list_3,
          quantities.quantity_list_4
        ').order(created_at: :DESC).where(user_id: user.id)
        if @current_user
          current_user_posts = @current_user.posts
          current_user_posts_id = current_user_posts.map { |post| post.id }
          current_user_votes = @current_user.votes
          current_user_voted_posts_id = current_user_votes.eager_load(:post).map { |vote| vote.post.id }
          render json: {
            user: user,
            posts: user_posts_join_quantities_created_at_desc,
            auth_user: @current_user,
            current_user_posts_id: current_user_posts_id,
            current_user_voted_posts_id: current_user_voted_posts_id
          }
        else
          render json: { user: user, posts: user_posts_join_quantities_created_at_desc }
        end
      end

      def new
        if @current_user
          render json: { auth_user: @current_user }
        else
          user = User.new
          render json: { user: user }
        end
      end

      def create
        user = User.new(user_params)
        user.avatar = File.open(Rails.root.join("public/default.jpeg"))
        if user.save
          account = user.build_account(account_number: user.id)
          account.save
          log_in(user)
          render json: { message: "ユーザー作成に成功しました", user: user }
        else
          render json: { message: "ユーザー作成に失敗しました", errors: user.errors }
        end
      end

      def edit
        render json: { auth_user: @current_user }
      end

      def update
        if @current_user.update(user_params)
          render json: { message: "ユーザー情報の編集に成功しました", auth_user: @current_user }
        else
          render json: { message: "ユーザー情報の編集に失敗しました", auth_user: @current_user, errors: @current_user.errors }
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

        def log_in(user)
          session[:user_id] = user.id
        end

        # ログインしているユーザーがいない場合、ステータスコード401を返す
        def logged_in_user
          return if @current_user

          # 送信されたリクエストがGETリクエストの場合、パスを保存 → '/users' or '/users/:id/edit'
          session[:forwarding_url] = request.fullpath if request.get?
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
