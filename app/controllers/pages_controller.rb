class PagesController < ApplicationController

  def error_404
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end
end
