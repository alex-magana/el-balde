module Api
  module V1
    class BucketListsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_bucket_list, only: [:show, :update, :destroy]
      before_action :set_user, only: [:create]

      def index
        if index_params[:q]
          @bucket_lists = search_by_name(index_params[:q].downcase)
        else
          @bucket_lists = paginate
        end
        render_response(@bucket_lists)
      end

      def show
        render_response(@bucket_list)
      end

      def create
        @bucket_list = BucketList.new(bucket_list_params)
        if @bucket_list.save
          render_response(@bucket_list, :created,
                          api_v1_bucket_list_url(@bucket_list))
        else
          render_response(@bucket_list.errors, :unprocessable_entity)
        end
      end

      def update
        if @bucket_list.update(bucket_list_params)
          render_response(@bucket_list)
        else
          render_response(@bucket_list.errors, :unprocessable_entity)
        end
      end

      def destroy
        @bucket_list.destroy
        render_response(message: bucket_list_deletion_successful)
      end

      private

      def set_bucket_list
        @bucket_list = BucketList.find(params[:id])
      end

      def set_user
        params[:bucket_list][:user_id] = current_user.id
      end

      def search_by_name(name)
        BucketList.search_by_name(name).
          paginate(index_params[:page].to_i, index_params[:limit].to_i)
      end

      def paginate
        BucketList.where(user_id: current_user.id).
          paginate(index_params[:page].to_i, index_params[:limit].to_i)
      end

      def bucket_list_params
        params.require(:bucket_list).permit(:name, :user_id)
      end

      def index_params
        params.permit(:page, :limit, :q)
      end
    end
  end
end
