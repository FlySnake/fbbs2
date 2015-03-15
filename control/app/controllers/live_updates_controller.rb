class LiveUpdatesController < ApplicationController
  include ActionController::Live
  include ActionView::Helpers::UrlHelper
  include BuildJobsHelper
  
  def build_jobs
    Rails.logger.info "Starting SSE for new client"
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 3000, event: "update_build_jobs")
    build_jobs_queue = Queue.new
    Timeout::timeout(3600) do # kick the client after 1 hour
      BuildJob.on_change(build_jobs_queue) do
        build_job = build_jobs_queue.pop
        sse.write(params_for_build_job(build_job))
      end
    end
  rescue ClientDisconnected, Timeout::Error => err
    Rails.logger.warn err.to_s
  ensure
    sse.close
    BuildJob.on_change_cleanup(build_jobs_queue)
    Rails.logger.info "Closed SSE stream"
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
