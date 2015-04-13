class TestsResultsController < ApplicationController
  def index
    @tests_results = TestsResult.where(build_job_id: params[:build_job_id])
  end

  def show
    @tests_result = TestsResult.find(params[:id])
  end
end
