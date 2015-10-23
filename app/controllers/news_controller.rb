class NewsController < ApplicationController
  def index
    @news = News.all.page(params[:page]).per(1)
  end

  def show

  end
end
