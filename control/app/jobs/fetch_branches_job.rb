class FetchBranchesJob < ActiveJob::Base
  queue_as :default

  def perform(repository)
    repository.branches true
    if repository.errors.any?
      Rails.logger.error "Error fetching remote branches in background job: #{repository.errors.messages[:branches].join(", ")}"
    end
  end
end
