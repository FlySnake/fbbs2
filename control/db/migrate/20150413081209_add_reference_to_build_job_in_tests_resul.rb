class AddReferenceToBuildJobInTestsResul < ActiveRecord::Migration
  def change
    add_reference :tests_results, :build_job, index: true
  end
end
