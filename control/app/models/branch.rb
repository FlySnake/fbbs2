class Branch < ActiveRecord::Base
  belongs_to :repository
  has_many :build_jobs
  
  after_initialize :set_new_commits
  
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
  
  def new_commits?
    @new_commits
  end
  
  private
  
    def set_new_commits
      found = self.build_jobs.find { |b|
        unless b.commit.nil?
          self.last_commit_identifier.start_with? b.commit.identifier and b.result == BuildJob.results[:success]
        end
      }
      if found.nil?
        @new_commits = true
      else
        @new_commits = false
      end
    end
    
end
