# Load the Rails application.
require File.expand_path('../application', __FILE__)

def without_sql_logging
  old_logger = ActiveRecord::Base.logger
  ActiveRecord::Base.logger = nil
  yield
  ActiveRecord::Base.logger = old_logger
end

# Initialize the Rails application.
Rails.application.initialize!
