class TestsResult < ActiveRecord::Base
  belongs_to :tests_executor
  belongs_to :build_job
  
  def self.process_artefact(file)
    if file.basename.end_with? ".zip"
      Rails.logger.info "Processinf tests artefact #{file.basename}"
      
      self.title = "the name of xml file - i.e. module"
      self.data = "raw xml data"
    else
      Rails.logger.error "Tests result cannot be in a file named #{file.basename}"
    end
  end
  
  def cases
    parse_data
  end
  
  protected
  
    def parse_data
      return [] if self.id.nil?
      doc = Nokogiri::XML(self.data)
      hash = Hash.from_xml doc.to_s
    end
  
end
