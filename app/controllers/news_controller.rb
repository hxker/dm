class NewsController < ApplicationController
  def index
    @news = News.all.page(params[:page]).per(1)
  end

  def show
    @new = News.find(params[:id])
    @news = News.limit(3).all
  end
end
