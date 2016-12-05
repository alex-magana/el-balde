module Api
  module V1
    class ListsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_list, only: [:show, :update, :destroy]
      before_action :set_user, only: [:create]

      def index
        @lists = if index_params.key?(:q)
                   search_by_name(index_params[:q].downcase)
                 else
                   catalog
                 end
        render_response(@lists)
      end

      def show
        render_response(@list)
      end

      def create
        @list = List.new(list_params)
        if @list.save
          render_response(@list, :created, api_v1_list_url(@list))
        else
          render_response(@list.errors, :unprocessable_entity)
        end
      end

      def update
        if @list.update(list_params)
          render_response(@list)
        else
          render_response(@list.errors, :unprocessable_entity)
        end
      end

      def destroy
        @list.destroy
        render_response(message: bucket_list_deletion_successful)
      end

      private

      def set_list
        @list = List.find(params[:id])
      end

      def set_user
        params[:list][:user_id] = current_user.id
      end

      def search_by_name(name)
        List.search_by_name(name).
          paginate(index_params[:page].to_i, index_params[:limit].to_i)
      end

      def catalog
        List.catalog(
          current_user, index_params[:page].to_i, index_params[:limit].to_i
        )
      end

      def list_params
        params.require(:list).permit(:name, :user_id)
      end

      def index_params
        params.permit(:page, :limit, :q)
      end
    end
  end
end
