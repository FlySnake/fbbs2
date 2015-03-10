class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  include Gravtastic
  gravtastic
  
  before_save :make_first_user_admin
  
  private
  
    def make_first_user_admin
      if all.count.empty?
        self.admin = true
      end
    end
  
end
