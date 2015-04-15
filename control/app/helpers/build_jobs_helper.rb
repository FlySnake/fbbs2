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
  
  def artefacts_links(build_job, filename_text=false)
    html = ""
    if build_job.build_artefacts.empty?
      build_job.reload
    end
    build_job.build_artefacts.each do |a|
      next if not a.visible?
      path = artefact_url(build_job.enviroment, a)
      if filename_text
        text = a.filename
      else
        text = artefact_link_text_short(a)
      end
      html << link_to(text, path)
      html << "<br/>"
    end
    html.html_safe
  rescue => err
    html = err.to_s
  ensure
    sanitize html, tags: ['a']
  end
  
  def calculate_duration(build_job)
    if build_job.busy?
      end_time = Time.now
    else
      end_time = build_job.finished_at.nil? ? build_job.updated_at : build_job.finished_at
    end
   
    start_time = build_job.started_at
    return "" if start_time.nil? 
    distance_of_time_in_words start_time, end_time, include_seconds: true
  end
  
  def revision_text(build_job)
    text = ""
    text = link_to_commit(build_job) + " | " + 
           build_job.commit.author + " | " + 
           build_job.commit.datetime.localtime.to_s + " | " + 
           comment_with_link_to_issue(build_job).html_safe
  rescue
  ensure
    sanitize text, tags: ['a']
  end
  
  def new_commits?(build_job)
    build_job.branch.new_commits? build_job.target_platform, build_job.base_version
  end
  
  private
  
    def artefact_url(enviroment, artefact)
      enviroment_build_artefact_url(:enviroment_title => enviroment.title, :filename => artefact.filename)
    end
    
    def artefact_link_text_short(artefact)
      File.extname(artefact.filename).delete('.')
    end
      
    def link_to_commit(build_job)
      text = ""
      text = build_job.commit.identifier
      link = build_job.enviroment.repository.full_weblink_to_commit(build_job.commit.identifier)
      raise if link.empty? or link.nil?
      link_to(text, link, :target => "_blank")
    rescue
      text
    end
    
    def comment_with_link_to_issue(build_job)
      text = ""
      text = build_job.commit.message
      issue = build_job.commit.extract_issue(build_job.enviroment.issue_tracker.regex)
      raise if issue.empty? or issue.nil?
      link = build_job.enviroment.issue_tracker.full_weblink(issue)
      issue_link = content_tag :mark, link_to(issue, link, :target => "_blank")
      text.sub issue, issue_link
    rescue
      text
    end
  
end
