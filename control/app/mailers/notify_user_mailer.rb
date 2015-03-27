class NotifyUserMailer < ApplicationMailer
  helper NotifyUserMailerHelper
  
  def build_job_finished(build_job, user)
    @build_job = build_job
    mail(to: user.email, subject: "Build job finished - #{@build_job.result.humanize}, branch - #{@build_job.branch.name}")
  end
end
