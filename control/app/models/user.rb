class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  before_create :make_first_user_admin
  after_create :send_admin_mail
  
  scope :admins, -> {
    where(:admin => true)
  }
  
  def active_for_authentication? 
    super && approved? 
  end 
  
  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
  
  private
  
    def make_first_user_admin
      if User.all.empty?
        self.admin = true
      end
    end
    
    def send_admin_mail
      User.admins.each do |admin|
        AdminMailer.new_user_waiting_for_approval(self, admin).deliver
      end
    end
  
end
