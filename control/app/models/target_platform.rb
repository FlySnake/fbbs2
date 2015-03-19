class TargetPlatform < ActiveRecord::Base
  has_and_belongs_to_many :workers
  has_many :build_jobs
  
  scope :all_with_worker, -> {
    joins(:workers).group("target_platforms.id")
  }
  
  scope :all_ordered_by_mask, ->(mask) {
    input = all_with_worker
    return input if mask.nil? or mask.empty?
    result = []
    mask.each do |v|
      found = input.find {|item| item.title == v}
      result << found if found
    end
    others = input - result
    result += others
  }
  
  def self.options_for_select
    order('LOWER(title)').map { |e| [e.title, e.id] }
  end
  
end
