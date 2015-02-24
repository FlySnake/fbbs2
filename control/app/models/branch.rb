class Branch < ActiveRecord::Base
  belongs_to :repository
  
  scope :all_filtered, ->(filter) {
    #TODO implement filter (regexp or something like that)
    Branch.order(:name => :asc).all
  }
  
end
