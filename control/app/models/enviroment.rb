class Enviroment < ActiveRecord::Base
  has_many :build_numbers
  belongs_to :repository
  has_and_belongs_to_many :base_versions
  has_many :build_jobs
  belongs_to :issue_tracker
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :default_build_number, numericality: { only_integer: true }, presence: true
  validates :repository, :presence => true
  
  serialize :target_platforms_order
  
end
