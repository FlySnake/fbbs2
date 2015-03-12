class LiveUpdatesController < ApplicationController
  include ActionController::Live
  include ActionView::Helpers::UrlHelper
  include BuildJobsHelper
  
  def build_jobs
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 30000, event: "update_build_jobs")
    Timeout::timeout(3600) do # kick the client after 1 hour
      loop do
        sse.write(params_for_build_job(BuildJob.pop_notification))
      end
    end
  rescue ClientDisconnected, Timeout::Error => err
    Rails.logger.warn err.to_s
  ensure
    sse.close
  end
  
  private
    
    def params_for_build_job(build_job)
      { build_job_id:       build_job.id, 
        duration:           calculate_duration(build_job),
        full_version:       (build_job.full_version.nil? ? "" : build_job.full_version.title),
        artefacts:          artefacts_links(build_job),
        revision:           revision_text(build_job),
        status:             build_job.status
      }
    end
    
end
