class Interface::BlogsController < ActionController::Base
  def all
    render :json => {
      blogs: Refinery::Blog::Post.order('created_at desc').map{|blog|
        {
          id: blog.id,
          title: blog.title,
          created_at: blog.created_at
        }
      }
    }
  end

  def show
    render :json => {
      result: Refinery::Blog::Post.find(params[:id])
    }
  end
end
