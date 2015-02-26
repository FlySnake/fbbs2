class CreateBuildArtefacts < ActiveRecord::Migration
  def change
    create_table :build_artefacts do |t|
      t.string :file
      t.references :build_job, index: true

      t.timestamps null: false
    end
    add_foreign_key :build_artefacts, :build_jobs
  end
end
