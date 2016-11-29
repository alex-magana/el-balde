module Api
  module V1
    class BucketListItemsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_bucket_list_item, only: [:show, :update, :destroy]
      before_action :set_bucket_list, only: [:index, :create]

      def index
        @bucket_list_items = BucketListItem.where(
          bucket_list_id: @bucket_list.id
        ).paginate(params[:page].to_i, params[:limit].to_i)
        render_response(@bucket_list_items)
      end

      def show
        render_response(@bucket_list_item)
      end

      def create
        @bucket_list_item = @bucket_list.bucket_list_items.new(
          bucket_list_item_params
        )
        if @bucket_list_item.save
          render_response(@bucket_list_item, :created,
                          api_v1_bucket_list_bucket_list_item_url(
                            @bucket_list, @bucket_list_item
                          ))
        else
          render_response(@bucket_list_item.errors, :unprocessable_entity)
        end
      end

      def update
        if @bucket_list_item.update(bucket_list_item_params)
          render_response(@bucket_list_item)
        else
          render_response(@bucket_list_item.errors, :unprocessable_entity)
        end
      end

      def destroy
        @bucket_list_item.destroy
        render_response(message: bucket_list_item_deletion_successful)
      end

      private

      def set_bucket_list_item
        @bucket_list_item = BucketListItem.find(params[:id])
      end

      def set_bucket_list
        @bucket_list = BucketList.find(params[:bucket_list_id])
      end

      def bucket_list_item_params
        params.require(:bucket_list_item).permit(:name, :done, :bucket_list_id)
      end
    end
  end
end
