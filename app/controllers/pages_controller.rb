class PagesController < ApplicationController
  def home
    redirect_to contacts_path if logged_in?
  end
end
