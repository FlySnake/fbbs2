class Branch < ActiveRecord::Base
  belongs_to :repository
  has_many :build_jobs
  
  scope :all_filtered, ->(filter) {
    all = all_active.order(:name => :asc)
    regex = Regexp.new filter
    all.select{|e| e.name =~ regex}
  }
  
  scope :all_active, -> {
    where(:deleted => false)
  }
  
  def self.options_for_select(filter="")
    all_filtered(filter).map { |e| [e.name, e.id] }
  end
  
end
