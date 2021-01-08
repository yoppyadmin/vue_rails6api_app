module Api
  module V1
    class PostsController < ApplicationController
      before_action :logged_in_user, only: [:new, :create, :destroy]

      def index
        set_posts_joins_quantities
        if @current_user
          set_current_user_posts_id
          current_user_voted_posts_id = @current_user.votes.eager_load(:post).map { |vote| vote.post.id }
          render json: {
            auth_user: @current_user,
            posts: @posts_joins_quantities,
            current_user_posts_id: @current_user_posts_id,
            current_user_voted_posts_id: current_user_voted_posts_id
          }
        else
          render json: { posts: @posts_joins_quantities }
        end
      end

      def show
        post_joins_quantity = Post.joins(:user, :quantity).select('
          posts.*,
          users.avatar,
          quantities.quantity_list_1,
          quantities.quantity_list_2,
          quantities.quantity_list_3,
          quantities.quantity_list_4
        ').find(params[:id])
        if @current_user
          set_current_user_posts_id
          current_user_voted_posts_id = @current_user.votes.eager_load(:post).map { |vote| vote.post.id }
          render json: {
            auth_user: @current_user,
            post: post_joins_quantity,
            current_user_posts_id: @current_user_posts_id,
            current_user_voted_posts_id: current_user_voted_posts_id
          }
        else
          render json: { post: post_joins_quantity }
        end
      end

      def new
        post = @current_user.posts.build
        render json: { post: post, auth_user: @current_user }
      end

      def create
        post = @current_user.posts.build(post_params)
        if post.save
          set_posts_joins_quantities
          post.build_quantity
          post.save
          render json: { message: "新規投稿作成に成功しました", posts: @posts_joins_quantities }
        else
          render json: { message: "新規投稿作成に失敗しました", errors: post.errors }
        end
      end

      def destroy
        post = Post.find(params[:id])
        post.destroy
        set_render_json_for_destroy_post(post, params)
      end

      private

        def set_posts_joins_quantities
          @posts_joins_quantities = Post.joins(:user, :quantity).select('
            posts.*,
            users.avatar,
            quantities.quantity_list_1,
            quantities.quantity_list_2,
            quantities.quantity_list_3,
            quantities.quantity_list_4
          ').order(created_at: :DESC)
        end

        def set_current_user_posts_id
          @current_user_posts_id = @current_user.posts.map { |post| post.id }
        end

        def set_render_json_for_destroy_post(post, params)
          set_current_user_posts_id
          case params[:vue_router_path]
          when "/"
            set_posts_joins_quantities
            render json: {
              message: "投稿を削除しました",
              posts_joins_quantities: @posts_joins_quantities,
              current_user_posts_id: @current_user_posts_id
            }
          when "/users/#{params[:vue_router_params_id]}"
            user_posts_join_quantities = Post.joins(:user, :quantity).select('
              posts.*,
              users.avatar,
              quantities.quantity_list_1,
              quantities.quantity_list_2,
              quantities.quantity_list_3,
              quantities.quantity_list_4
            ').order(created_at: :DESC).where(user_id: post.user.id)
            render json: {
              message: "投稿を削除しました",
              user_posts_join_quantities: user_posts_join_quantities,
              current_user_posts_id: @current_user_posts_id
            }
          when "/posts/#{params[:id]}"
            render json: { message: "投稿を削除しました" }
          end
        end

        def post_params
          params.require(:post).permit(:content, :list_1, :list_2, :list_3, :list_4)
        end

        def logged_in_user
          return if @current_user

          render json: { status: 401, message: "Unauthorized" }
        end
    end
  end
end
