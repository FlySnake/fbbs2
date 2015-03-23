class Branch < ActiveRecord::Base
  belongs_to :repository
  has_many :build_jobs
  
  before_destroy { self.update_attribute(:deleted_at, Time.now); false}

  
  scope :all_filtered, ->(filter) {
    all = all_active.order(:name => :asc)
    regex = Regexp.new filter
    all.select{|e| e.name =~ regex}
  }
  
  scope :all_active, -> {
    where(:deleted_at => nil)
  }
  
  def self.options_for_select(filter="")
    all_filtered(filter).map { |e| [e.name, e.id] }
  end
  
  def new_commits?
    found = self.build_jobs.find do |b|
      unless b.commit.nil?
        self.last_commit_identifier.start_with? b.commit.identifier and b.success?
      end
    end
    found.nil? ? true : false
  end
    
end
