# -*- encoding : utf-8 -*-
module Refinery
  module Blog
    class CategoriesController < BlogController

      def show
        @category = Refinery::Blog::Category.find(params[:id])
        @posts = @category.posts.
          where('title like ? or body like ?', "%#{params[:title]}%", "%#{params[:title]}%").
          where('title not like ?', "%[**]%").
          live.
          includes(:comments, :categories).
          page(params[:page]).per_page(2000)
      end

    end
  end
end
