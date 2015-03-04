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
  
  def artefact_link(enviroment, artefact)
    build_artefact_path(:enviroment_title => enviroment.title, :filename => artefact.filename)
  end
  
  def artefact_link_text_short(artefact)
    File.extname(artefact.filename).delete('.')
  end
  
  def calculate_duration(build_job)
    if build_job.status == :busy
      end_time = Time.now
    else
      end_time = build_job.finished_at.nil? ? build_job.updated_at : build_job.finished_at
    end
   
    start_time = build_job.started_at
    diff = TimeDifference.between(start_time, end_time).in_general
    result = ""
    if diff[:days] != 0
      result << " #{diff[:days]}" + "d"
    end
    if diff[:hours] != 0
      result << " #{diff[:hours]}" + "h"
    end
    if diff[:minutes] != 0
      result << " #{diff[:minutes]}" + "m"
    end
    result << " #{diff[:seconds]}" + "s"
    result
  end
  
end
