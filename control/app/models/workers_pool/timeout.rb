class WorkersPool::Timeout
  def check!
    build_jobs = BuildJob.where("status = ? AND updated_at <= ?", BuildJob.statuses[:busy], Time.now - 2.minutes)
    count = build_jobs.size
    if count > 0
      build_jobs.each do |j|
        worker = WorkersPool::Pool.instance.find(j.worker)
        unless worker.nil?
          worker.stop!
        end
        j.update_attributes(:status => BuildJob.statuses[:ready], :result => BuildJob.results[:failure])
      end
      Rails.logger.info("#{count.to_s} jobs killed by timeout")
    end
  end
end