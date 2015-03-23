module NotifyUserMailerHelper
  include BuildJobsHelper
  
  def result_text_humanize(build_job)
    case build_job[:result]
    when BuildJob.results[:success]
      text = "Success"
      result = "<b><font color='green'>#{text}</font></b>"
    when BuildJob.results[:failure]
      text = "Failure"
      result = "<b><font color='red'>#{text}</font></b>"
    when BuildJob.results[:terminated] 
      text = "Terminated"
      result = "<b><font color='red'>#{text}</font></b>"
    else
      text = "Unknown status"
      result = "<b><font color='red'>#{text}</font></b>"
    end
    result.html_safe
  end
  
end
