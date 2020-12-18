module Api
  module V1
    class SessionsController < ApplicationController
      def profile
        if @current_user
          render json: { authenticated: true, logged_in_user: @current_user }
        else
          render json: { authenticated: false }
        end
      end

      def new
        if @current_user
          render json: { logged_in_user: @current_user }
        else
          not_logged_in_user = Session.new
          render json: { not_logged_in_user: not_logged_in_user }
        end
      end

      def create
        not_logged_in_user = Session.new(session_params)
        if not_logged_in_user.valid? \
        && (user = User.find_by(email: not_logged_in_user.email)) \
        && user.authenticate(not_logged_in_user.password)
          log_in(user)
          remember(user) if params[:session][:remember_me] == true
          logged_in_user = user
          if (fowarding_url = session[:forwarding_url])
            path = fowarding_url.split(/\//, 4).last
            render json: { message: "ログインに成功しました", logged_in_user: logged_in_user, path: path }
            session.delete(:forwarding_url)
          else
            render json: { message: "ログインに成功しました", logged_in_user: logged_in_user }
          end
        else
          render json: { message: "ログインに失敗しました", errors: not_logged_in_user.errors }
        end
      end

      def destroy
        @current_user.update(remember_digest: nil)
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
        session.delete(:user_id)
        @current_user = nil
        render json: { message: "ログアウトに成功しました" }
      end

      private

        def session_params
          params.require(:session).permit(:email, :password, :remember_me)
        end

        def log_in(user)
          session[:user_id] = user.id
        end

        def remember(user)
          user.remember
          cookies.permanent.signed[:user_id] = user.id
          cookies.permanent[:remember_token] = user.remember_token
        end
    end
  end
end
