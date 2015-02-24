class Branch < ActiveRecord::Base
  belongs_to :repository
  has_many :build_jobs
  
  scope :all_filtered, ->(filter) {
    all = Branch.order(:name => :asc).all
    regex = Regexp.new filter
    all.select{|e| e.name =~ regex}
  }
  
end
