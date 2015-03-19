class WorkersPool::Timeout
  def check!
    build_jobs = BuildJob.where("status = ? AND updated_at <= ?", BuildJob.statuses[:busy], Time.now - 5.minutes)
    count = build_jobs.size
    if count > 0
      build_jobs.each do |j|
        j.kill_by_timeout
      end
      Rails.logger.info("#{count.to_s} jobs killed by timeout")
    end
  end
end