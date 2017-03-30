class Contact < ActiveRecord::Base
  belongs_to :user
  validates :first_name, :last_name, :street_number, :street_name, :zipcode, :city, :state, :country, presence: true

  geocoded_by :address
  

  def address
    # or whatever format you prefer
    [street_number, street_name, city, state, zipcode, country].join(' ')
  end  
end