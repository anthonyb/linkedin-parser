require 'open-uri'

class ParseProfile
  attr_accessor :profile_object, :response_message, :html

  def initialize(url)
    @url = url
    @regex = /^https?:\/\/?www?\.linkedin\.com\/in\/([\/\w \.-]*)\/?/
    @success = false
    @profile_object = nil
    @response_message = ""
    @html = nil
    @name = nil
    @title = nil
    @skills = nil
    @linkedin_profile_id = nil
  end

  #------------------------------------

  def parse
    #Chain the logic to shortcircuit and send back false if anything fails
    unless is_valid_url?
      @response_message = "That isn't a LinkedIn URL!"
      return @success
    end

    unless is_new_profile?
      @response_message = "We already have that Profile on record!"
      return @success
    end

    unless collect_html
      @response_message = "Couldn't get HTML from LinkedIn!"
      return @success
    end

    unless get_name
      @response_message = "Couldn't get Name from Profile!"
      return @success
    end

    unless get_title
      @response_message = "Couldn't get Title from Profile!"
      return @success
    end

    unless get_skills
      @response_message = "Couldn't get Skills from Profile!"
      return @success
    end

    unless form_response_object
      @response_message = "Couldn't form response object!"
      return @success
    end

    @response_message = "Added Profile Successfully"
    @success = true
    return @success
  end

  #------------------------------------

  def is_valid_url?
    match = @regex.match(@url)
    if match
      @linkedin_profile_id = match[1]
      return true
    end
    return false
  end

  #------------------------------------

  def is_new_profile?
    if Profile.where(linkedin_profile_id: @linkedin_profile_id).first
      return false
    end
    return true
  end

  #------------------------------------

  def collect_html
    #Gotta toss some headers in there so they don't think we are scraping ;)
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36"
    host = "www.linkedin.com"
    accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    cookie = ENV["BROWSER_COOKIE"] #MUST ADD COOKIE HERE!!
    @html = Nokogiri::HTML(
      open(@url, "User-Agent" => user_agent, "Host" => host, "Accept" => accept, "Cookie" => cookie)
    )
    if @html
      return true
    end
    return false
  end

  #------------------------------------

  def get_name
    @name = @html.css('.fn').first.children.text
    if @name
      return true
    end
    return false
  end

  #------------------------------------

  def get_title
    @title = @html.css('.title').first.children.text
    if @title
      return true
    end
    return false
  end

  #------------------------------------

  def get_skills
    skill_array = []
    skill_html_set = @html.css('.endorse-item')
    skill_html_set.each do |skill|
      skill_array << skill['data-endorsed-item-name']
    end

    if skill_array.any?
      @skills = skill_array
    else
      @skills = []
    end
    #its possible there are no skills, so we should just return True anyway
    return true
  end

  #------------------------------------

  def form_response_object
    @profile_object = {
      linkedin_profile_id: @linkedin_profile_id,
      name: @name,
      title: @title,
      skills: @skills.join(', ')
    }
    return true
  end
end
