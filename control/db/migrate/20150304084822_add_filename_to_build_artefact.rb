class AddFilenameToBuildArtefact < ActiveRecord::Migration
  def change
    add_column :build_artefacts, :filename, :string
  end
end
