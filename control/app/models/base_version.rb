class BaseVersion < ActiveRecord::Base
  has_and_belongs_to_many :enviroments
  
  validates :name, length: { in: 1..100 }
end
