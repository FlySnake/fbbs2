class Vcs::Base
  attr_reader :path
  
  def initialize(path)
    @path = path
  end
  
  def branches
  end
  
  def branches_with_last_commit
  end
  
  def check_correctness
  end
  
end