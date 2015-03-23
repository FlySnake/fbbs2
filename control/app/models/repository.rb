class Repository < ActiveRecord::Base
  enum vcs_type: [:git]
  has_many :branches, :dependent => :destroy
  has_one :enviroment
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :path, length: {in: 1..4000}
  validates :vcs_type, inclusion: {in: Repository.vcs_types.keys}
  validates :weblink_to_commit, format: { with: /:commit/, message: "must contain ':commit' for substitution" }, allow_blank: true
  validate :path_correctness
  
  def branches(force_fetch=false)
    begin
      vcs = vcs_by_type vcs_type
      
      if force_fetch
        fetch_branches_with_last_commit vcs
      end
      
    rescue => e
      self.errors.add(:branches, e.to_s)
    end
    Branch.all_active
  end
  
  def remote_url
    vcs = vcs_by_type vcs_type
    vcs.remote_url
  end
  
  def remote_name
    vcs = vcs_by_type vcs_type
    vcs.remote_name
  end
  
  def full_weblink_to_commit(commit)
    unless self.weblink_to_commit.nil?
      self.weblink_to_commit.sub(":commit", commit)
    else
      nil
    end
  end
  
  def self.fetch_branches_all_in_backgroud
    Repository.each do |r|
      FetchBranchesJob.perform_later r
    end
  end
  
  protected
  
    def vcs_by_type(type)
      case type
      when 'git'
        vcs = Vcs::Git.new(path)
      else
        vcs = Vcs::Base.new(path)
      end
      vcs
    end
    
    def fetch_branches_with_last_commit(vcs)
      Rails.logger.info "Fetching remote branches"
      branches_with_commits = vcs.branches_with_last_commit
      unless branches_with_commits.nil?
        Branch.destroy_all(['name not in (?)', branches_with_commits.map{|f,s| f}]) # remove deleted in repo branches
        branches_to_create = branches_with_commits - Branch.all_active.map {|b| [b.name, b.last_commit_identifier] } # make a list of only new branches
        branches_to_create.each do |name, commit|
          found = Branch.find_by(:name => name)
          if found
            found.last_commit_identifier = commit
            found.save
          else
            Branch.create(name: name, last_commit_identifier: commit, repository: self)
          end
        end
      end
    end
    
    def path_correctness
      vcs = vcs_by_type vcs_type
      vcs.check_correctness
    rescue => err
      errors.add(:path, err.to_s)
    end
  
end
