require 'net/https'
require 'uri'

class AddressesController < ApplicationController
  
  before_action :addresssearch_tokun
  
  def prefecture_index
    droplet_ep = 'https://addresssearch.herokuapp.com/api/v1/posts/prefecture'
    uri = URI.parse(droplet_ep)
    http = Net::HTTP.new(uri.host, uri.port)
    
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = "Bearer #{@token}"
    
    res = http.request(req)
    
    begin
      case res
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        result = JSON.parse(res.body)
        @prefectures = result["data"]
        # 表示用の変数に結果を格納
        respond_to do |format|
          format.js
        end
      end
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end
  
  def city_index
    @select_prefecture_name = params[:ken_name]
    select_prefecture = params[:ken_id]
    target_city_params = URI.encode_www_form({ken_id: select_prefecture})
    uri = URI.parse("https://addresssearch.herokuapp.com/api/v1/posts/ken_select?#{target_city_params}")
    http = Net::HTTP.new(uri.host, uri.port)
    
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    req = Net::HTTP::Get.new(uri.path + "?" + uri.query)
    req['Authorization'] = "Bearer #{@token}"
    
    res = http.request(req)
    
    begin
      case res
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        result = JSON.parse(res.body)
        @cities = result["data"].sort{|a, b| a["city_furi"] <=> b["city_furi"]}
        # 表示用の変数に結果を格納
        respond_to do |format|
          format.js
        end
      end
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
    
  end
  
  def town_index
    @select_prefecture_name = params[:ken_name]
    @select_city_name = params[:city_name]
    select_city = params[:city_id]
    target_town_params = URI.encode_www_form({city_id: select_city})
    uri = URI.parse("https://addresssearch.herokuapp.com/api/v1/posts/city_select?#{target_town_params}")
    http = Net::HTTP.new(uri.host, uri.port)
    
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    req = Net::HTTP::Get.new(uri.path + "?" + uri.query)
    req['Authorization'] = "Bearer #{@token}"
    
    res = http.request(req)
    
    begin
      case res
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        result = JSON.parse(res.body)
        @towns = result["data"].sort{|a, b| a["town_furi"] <=> b["town_furi"]}
        respond_to do |format|
          format.js
        end
      end
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end
  
  def block_index
    @select_prefecture_name = params[:ken_name]
    @select_city_name = params[:city_name]
    @select_town_name = params[:town_name]
    select_town = params[:town_id]
    target_block_params = URI.encode_www_form({town_id: select_town})
    uri = URI.parse("https://addresssearch.herokuapp.com/api/v1/posts/town_select?#{target_block_params}")
    http = Net::HTTP.new(uri.host, uri.port)
    
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    req = Net::HTTP::Get.new(uri.path + "?" + uri.query)
    req['Authorization'] = "Bearer #{@token}"
    
    res = http.request(req)
    
    begin
      case res
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        result = JSON.parse(res.body)
        if result["type"] == "block"
          @blocks = result["data"].sort{|a, b| a["block_furi"] <=> b["block_furi"]}
          @type = "block"
        elsif result["type"] == "kyoto_street"
          @blocks = result["data"]
          @type = "kyoto_street"
        elsif result["type"] == "office"
          @blocks = result["data"].sort{|a, b| a["office_furi"] <=> b["office_furi"]}
          @zipcode = result['address'][0]["zip"]
          @type = "office"
        else
          if result["data"].length > 1
            @type = "memo"
            @blocks = result["data"]
          else
            @zipcode = result['data'][0]["zip"]
          end
        end
        respond_to do |format|
          format.js
        end
        
      end
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end
  
  def selected_block
    @select_prefecture_name = params[:ken_name]
    @select_city_name = params[:city_name]
    if params[:type] == "office"
      @type = "office"
      @select_town_name = params[:office_address]
      @zipcode = params[:zip]
    elsif params[:type] == "block"
      @select_town_name = params[:town_name]
      @select_block_name = params[:block_name]
      @zipcode = params[:zip]
    elsif params[:type] == "memo"
      @type = "memo"
      @select_town_name = params[:town_name]
      @zipcode = params[:zip]
    else
      @select_town_name = params[:town_name]
      @select_block_name = params[:block_name]
    end
    respond_to do |format|
      format.js
    end
  end
  
  private
   def addresssearch_tokun
     @token = 'yPRgv43UY9aHiBcieWaVv774'
   end
end
