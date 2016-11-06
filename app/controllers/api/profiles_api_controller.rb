require 'parse_profile'
module Api
  class ProfilesApiController < ApplicationController
    def index
      if params[:name]
        if params[:name] != ""
          @profiles = Profile.where("name LIKE ?", "%#{params[:name]}%")
        else
          @profiles = Profile.none
        end
      elsif params[:skills]
        if params[:skills] != ""
          @profiles = Profile.where("skills LIKE ?", "%#{params[:skills]}%")
        else
          #Otherwise this will bring back everything
          @profiles = Profile.none
        end
      else
        @profiles = Profile.none
      end

      return render json: @profiles.to_json
    end

    #----------------------------------------

    def create
      parser = ParseProfile.new(params[:url])
      begin
        parse_response = parser.parse
      rescue
        #TODO: make specific rescue cases, this is bad form
        message = "An unknown error occurred"
      end

      parse_response ||= false

      if parse_response == true
        Profile.create!(parser.profile_object)
        message = parser.response_message
      end

      message ||= parser.response_message

      @response = {success: parse_response, message: message}
      return render json: @response.to_json
    end
  end
end
