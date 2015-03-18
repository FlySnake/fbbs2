class SendNotifyUserEmailBuildJobFinishedJob < ActiveJob::Base
  queue_as :default

  def perform(build_job, user)
    NotifyUserMailer.build_job_finished(build_job, user).deliver_later
  end
end
