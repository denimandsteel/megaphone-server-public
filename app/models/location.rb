class Location < ActiveRecord::Base
  belongs_to :vendor

  # validates :name, presence: true
  # validates :city, presence: true
  # validates :neighbourhood, presence: true
  # validates :cross_street, presence: true
  # validates :hours, presence: true 
end
