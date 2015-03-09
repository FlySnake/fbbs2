require 'git'

class Vcs::Git < Vcs::Base
  def initialize(path, remote_name='origin')
    raise "repository path '#{path}' does not exists" unless File.exists? path
    @git = Git.open(path)
    @remote_name = remote_name
    super(path)
  end
  
  def branches
    remotes = Git.ls_remote remote_url
    remotes['branches'].map {|k,v| k }
  end
  
  def remote_url
    remote = @git.remotes.find {|r| r.name == @remote_name}
    remote.url unless remote.nil?
  end
  
  attr_reader :remote_name
  
  def check_correctness
    raise "no remotes in repository" if remote_url.nil?
  end
  
end