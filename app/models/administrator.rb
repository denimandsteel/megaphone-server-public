class Administrator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:full_name]

  belongs_to :created_by, :class_name => "Administrator"
  
  def email_changed?
    false
  end

  def email_required?
    false
  end
  
end
