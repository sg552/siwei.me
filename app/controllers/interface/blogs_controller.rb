class Interface::BlogsController < ActionController::Base
  def all
    render :json => {
      blogs: 'hihihi'
    }
  end

  def show
    render :text => 'hi'
  end
end
