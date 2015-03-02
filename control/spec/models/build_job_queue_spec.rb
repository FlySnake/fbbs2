require 'rails_helper'

RSpec.describe BuildJobQueue, type: :model do
  it "has a valid factory" do
    expect(build(:build_job_queue)).to be_valid
  end
  
  describe "queueing jobs" do
    before :each do
      @build_job = build(:build_job)
    end
    
    it "queues job" do
      BuildJobQueue.enqueue(@build_job)
      expect(BuildJobQueue.first.id).to eq @build_job.id
    end
    
    it "dequeues job" do
      BuildJobQueue.dequeue(@build_job)
      expect(BuildJobQueue.all).to eq []
    end
    
  end
  
end
