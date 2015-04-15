class TestsResult < ActiveRecord::Base
  belongs_to :tests_executor
  belongs_to :build_job
  
  def self.process_artefact(filepath, build_job, tests_executor)
    if filepath.end_with? tests_executor.artefact_name
      Rails.logger.info "Processing tests artefact '#{filepath}'"
      begin
        tmp_dir = "#{Dir.tmpdir}/#{Pathname.new(filepath).basename}_#{Time.now.to_s}"
        unzip_file filepath, tmp_dir
        Dir.foreach(tmp_dir) do |filename|
          if filename != "." and filename != ".."
            File.open("#{tmp_dir}/#{filename}", "r") do |file|
              create(:title => title_from_filename(filename), :data => file.read, :tests_executor => tests_executor, :build_job => build_job)
            end
          end
        end
      rescue => err
        Rails.logger.error "Error processing tests result artefact: #{err.to_s}"
      ensure
        FileUtils.rm_rf(tmp_dir)
      end
    else
      Rails.logger.error "Tests result cannot be in a file '#{filepath}', valid tests results file is '#{tests_executor.artefact_name}'"
    end
  end
  
  def cases
    return [] if self.id.nil?
    doc = Nokogiri::XML(self.data)
    #f = File.open("/home/o.antonyan/Desktop/tests_common.xml", "r")
    #doc = Nokogiri::XML(File.open("/home/o.antonyan/Desktop/tests_common.xml", "r"))
    testcases = []
    doc.xpath('//testcase').each do |t|
      suite = t.parent['name']
      short_description = t['name']
      if t.xpath('failure').any?
        status = :fail
        failure_message = ""
        t.xpath('failure').each do |f|
          failure_message += f['message']
        end
      else
        status = :ok
        failure_message = ""
      end
      time = t['time']
      testcases << TestCaseResult.new(suite, short_description, status, time, failure_message)
    end
    testcases
  end
  
  private
    
    def self.unzip_file(file, destination)
      Zip::File.open(file) do |zip_file|
        zip_file.each do |f|
          f_path = File.join(destination, f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        end
      end
    end
    
    def self.title_from_filename filename
      filename.gsub(".xml", "").gsub("tests_", "").capitalize
    end
  
end
