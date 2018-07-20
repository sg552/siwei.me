class Interface::BlogsController < ActionController::Base
  def all
    render :json => {
      blogs: Refinery::Blog::Post.where('title not like ?', "%[**]%").order('created_at desc').map{|blog|
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

  def add_comment
    render :json => {
      result: 'ok',
      content: params[:content]
    }
  end
end
