class Repository < ActiveRecord::Base
  enum vcs_type: [:git]
  has_many :branches, :dependent => :destroy
  has_one :enviroment
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :path, length: {in: 1..4000}
  validates :vcs_type, inclusion: {in: Repository.vcs_types.keys}
  #TODO validated weblink_to_commit for :commit
  validate :path_correctness
  
  def branches(force_fetch=false)
    begin
      vcs = vcs_by_type vcs_type
      
      if force_fetch
        fetch_branches vcs
      end
      
    rescue => e
      self.errors.add(:branches, e.to_s)
    end
    Branch.all
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
    
    def fetch_branches(vcs)
      branches_names = vcs.branches
      unless branches_names.nil?
        Branch.destroy_all(['name not in (?)', branches_names]) # remove deleted in repo branches
        branches_to_create = branches_names - Branch.all.map {|b| b.name } # make a list of only new branches
        Branch.create(branches_to_create.map {|b| {name: b, repository: self} }) # insert them at once
      end
    end
    
    def path_correctness
      vcs = vcs_by_type vcs_type
      vcs.check_correctness
    rescue => err
      errors.add(:path, err.to_s)
    end
  
end
