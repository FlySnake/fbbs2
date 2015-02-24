class BaseVersion < ActiveRecord::Base
  has_and_belongs_to_many :enviroments
end
