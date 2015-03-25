class Branch < ActiveRecord::Base
  belongs_to :repository
  has_many :build_jobs
 
  scope :all_filtered, ->(filter) {
    all = all_active.order(:name => :asc)
    regex = Regexp.new filter
    all.select{|e| e.name =~ regex}
  }
  
  scope :all_active, -> {
    where(:deleted_at => nil)
  }
  
  def destroy
    run_callbacks :destroy do
      update_attribute(:deleted_at, Time.now) or return false
      @destroyed = true
      freeze
    end
  end
  
  def destroy!
    raise ActiveRecord::RecordNotDestroyed unless destroy
  end
  
  def self.options_for_select(filter="")
    all_filtered(filter).map { |e| [e.name, e.id] }
  end
  
  def new_commits?(target_platform=nil, base_version=nil)
    build_job_with_existing_commit.nil? ? true : false
  end
  
  def build_job_with_existing_commit(target_platform=nil, base_version=nil) # Needs optimization/refactoring
    found = self.build_jobs.find do |b|
      unless b.commit.nil?
        self.last_commit_identifier.start_with? b.commit.identifier \
          and b.success? \
          and (target_platform.nil? ? true : b.target_platform == target_platform) \
          and (base_version.nil? ? true : b.base_version == base_version)
      end
    end
    found
  end
    
end
