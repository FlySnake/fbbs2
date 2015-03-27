class Enviroment < ActiveRecord::Base
  has_many :build_numbers
  belongs_to :repository
  has_and_belongs_to_many :base_versions
  has_many :build_jobs
  belongs_to :issue_tracker
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :default_build_number, numericality: { only_integer: true }, presence: true
  validates :repository, :presence => true
  validates :delete_build_jobs_older_than, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  serialize :target_platforms_order
  
  def self.rotate_build_jobs
    Rails.logger.info "Rotating build jobs"
    Enviroment.all.each do |e|
      unless e.delete_build_jobs_older_than.to_i == 0
        build_jobs_to_delete = BuildJob.where("enviroment_id = ? and finished_at <= ?", e.id, Time.now - e.delete_build_jobs_older_than.days)
        ids = build_jobs_to_delete.map{|b| b.id}
        if ids.count > 0
          Rails.logger.warn "Number of BuildJobs to be deleted (older than #{e.delete_build_jobs_older_than.days.to_s}): #{ids.count}, their ids: #{ids.join(', ')}"
          RotateBuildJobsJob.perform_later ids
        else
          Rails.logger.info "Nothing to rotate in enviroment '#{e.title}'"
        end
      end
    end
  end
  
end
