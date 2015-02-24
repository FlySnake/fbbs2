class Enviroment < ActiveRecord::Base
  has_many :build_numbers
  belongs_to :repository
  has_and_belongs_to_many :base_versions
end
