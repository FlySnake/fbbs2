class Repository < ActiveRecord::Base
  enum vcs_type: [:git]
  has_many :branches
  
  def branches(force_fetch=false)
    begin
      case vcs_type
      when 'git'
        vcs = Vcs::Git.new(path)
      else
        vcs = Vcs::Base.new(path)
      end
  
      if force_fetch
        fetch_branches vcs
      end
      
    rescue => e
      self.errors.add(:branches, e.to_s)
    end
    Branch.all
  end
  
  protected
  
  def fetch_branches(vcs)
    branches_names = vcs.branches
    unless branches_names.nil?
      Branch.destroy_all(['name not in (?)', branches_names]) # remove deleted in repo branches
      branches_to_create = branches_names - Branch.all.map {|b| b.name } # make a list of only new branches
      Branch.create(branches_to_create.map {|b| {name: b, repository: self} }) # insert them at once
    end
  end
  
end
