module BuildJobsHelper
  def build_job_tr_class(build_job)
    case build_job[:status]
    when BuildJob.statuses[:fresh]
      "info"
    when BuildJob.statuses[:busy]
      "warning"
    when BuildJob.statuses[:ready]
      case build_job[:result]
      when BuildJob.results[:success]
        "success"
      when BuildJob.results[:failure]
        "danger"
      else
        "danger"
      end
    else
      "danger"
    end
  end
  
end
