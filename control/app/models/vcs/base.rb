class Vcs::Base
  attr_reader :path
  
  def initialize(path)
    @path = path
  end
  
  def branches
  end
end