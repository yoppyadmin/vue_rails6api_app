module Api
  module V1
    class UsersController < ApplicationController
      def index
      end

      def show
        user = User.find(params[:id])
        render json: user
      end

      def new
      end

      def create
      end

      def edit
      end

      def update
      end

      def destroy
      end
    end
  end
end
