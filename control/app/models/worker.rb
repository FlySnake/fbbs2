class Worker < ActiveRecord::Base
  has_many :target_platforms, :dependent => :destroy
  
  validates :title, length: {in: 1..100}
  validates :address, length: {in: 2..100}
end
