require 'rest-client'

class GlamourController < ApplicationController
  before_action :set_redis, only: :check_name

  def index
  end

  def check_name
    firstName = name_params
    page = params[:page].to_i || 0
    sanitizedQuery = (firstName)
    url = "https://www.googleapis.com/customsearch/v1"
    params = {
      key: ENV['API_KEY'],
      cx: ENV['SEARCH_ENGINE_ID'],
      searchType: 'image',
      q: firstName,
      filter: 1
    }
    params.merge!({start: page*11}) if(page > 0)

    begin
      if stored_items = @redis.get(params)
        @items = JSON.parse(stored_items)
        puts 'redis'
      else
        puts 'fetching'
        response = RestClient.get(url, params: params)
        data = JSON.parse(response)
        @items = data['items']
        @redis.set(params, @items.to_json)
      end

      if(@items && @items.length > 0)
        render template: 'glamour/check_name.js.erb', format: :js
      else
        render template: 'glamour/check_name_failed.js.erb', status: :unprocessable_entity, format: :js
      end
    rescue
      render template: 'glamour/check_name_failed.js.erb', status: :unprocessable_entity, format: :js
    end
  end

  private
  def name_params
    params.require(:firstName)
  end

  def set_redis
    @redis = Redis.new(:url => ENV['REDIS_URL'])
  end
end