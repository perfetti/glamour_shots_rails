class GlamourController < ApplicationController
  def index
  end

  def check_name
    firstName = name_params.firstName
    page = params[:page].to_i
    sanitizedQuery = (firstName)
    API_KEY = 'AIzaSyBxtW8zQvuO7ozICe4M7_S_cbOjd-orjVs'
    url = "https://www.googleapis.com/customsearch/v1?key=#{ENV['API_KEY']}&cx=${searchEngineId}&searchType=image&q=${firstName}&filter=1"
    URI::Escape.encode(url)
  end

  private
  def name_params
    params.require(:firstName)
  end
end