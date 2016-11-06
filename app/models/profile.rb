class Profile < ActiveRecord::Base
  validates_presence_of :name, :title, :linkedin_profile_id
  validates_uniqueness_of :linkedin_profile_id

  #trim down the payload a bit
  def as_json(options={})
    super(:only => [:name,:title,:skills])
  end
end
