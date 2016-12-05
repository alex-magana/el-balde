module Api
  module V1
    class ItemsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_item, only: [:show, :update, :destroy]
      before_action :set_list, only: [:index, :create]

      def index
        @items = Item.catalog(@list, params[:page].to_i, params[:limit].to_i)
        render_response(@items)
      end

      def show
        render_response(@item)
      end

      def create
        @item = @list.items.new(item_params)
        if @item.save
          render_response(@item, :created, api_v1_list_item_url(@list, @item))
        else
          render_response(@item.errors, :unprocessable_entity)
        end
      end

      def update
        if @item.update(item_params)
          render_response(@item)
        else
          render_response(@item.errors, :unprocessable_entity)
        end
      end

      def destroy
        @item.destroy
        render_response(message: bucket_list_item_deletion_successful)
      end

      private

      def set_item
        @item = Item.find(params[:id])
      end

      def set_list
        @list = List.find(params[:list_id])
      end

      def item_params
        params.require(:item).permit(:name, :done, :list_id)
      end
    end
  end
end
