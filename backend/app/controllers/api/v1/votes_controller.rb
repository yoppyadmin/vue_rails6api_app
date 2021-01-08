module Api
  module V1
    class VotesController < ApplicationController
      before_action :logged_in_user, only: [:create]

      def create
        post = Post.find(params[:vote][:post_id])
        check_already_voted(post)
        vote = @current_user.votes.build(vote_params)
        if vote.save
          increment_post_list_number(post, params[:list_number])
          set_posts_joins_quantities
          set_render_json_for_create_vote(post, params)
        else
          render json: { message: "投票に失敗しました", errors: vote.errors }
        end
      end

      private

        def check_already_voted(post)
          return unless @current_user.votes.eager_load(:post).map { |vote| vote.post }.include?(post)

          render json: { message: "既に投票しています" }
        end

        def increment_post_list_number(post, list_number)
          list_number_quantity = "quantity_#{list_number}" # "quantity_list_1"
          list_number_quantity_to_sym = list_number_quantity.to_sym # "quantity_list_1" -> :quantity_list_1
          post.quantity.increment(list_number_quantity_to_sym)
          post.quantity.save
        end

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

        def set_render_json_for_create_vote(post, params)
          post_joins_quantity = @posts_joins_quantities.find(post.id)
          current_user_voted_posts_id = @current_user.votes.eager_load(:post).map { |vote| vote.post.id }
          case params[:vue_router_path]
          when "/"
            render json: {
              message: "投票に成功しました",
              post: post_joins_quantity,
              index_posts: @posts_joins_quantities,
              current_user_voted_posts_id: current_user_voted_posts_id
            }
          when "/users/#{params[:vue_router_params_id].to_i}"
            user_posts_joins_quantities = @posts_joins_quantities.where(user_id: params[:vue_router_params_id].to_i)
            render json: {
              message: "投票に成功しました",
              post: post_joins_quantity,
              user_posts: user_posts_joins_quantities,
              current_user_voted_posts_id: current_user_voted_posts_id
            }
          when "/posts/#{params[:vote][:post_id]}"
            render json: {
              message: "投票に成功しました",
              post: post_joins_quantity,
              current_user_voted_posts_id: current_user_voted_posts_id
            }
          end
        end

        def vote_params
          params.require(:vote).permit(:user_id, :post_id)
        end

        def logged_in_user
          return if @current_user

          render json: { status: 401, message: "Unauthorized" }
        end
    end
  end
end
