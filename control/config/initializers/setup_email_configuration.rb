begin
  email_settings = YAML::load(File.open("#{Rails.root.to_s}/config/email.yml"))
  email_settings_env = email_settings[Rails.env].deep_symbolize_keys
  ActionMailer::Base.smtp_settings = email_settings_env
  ActionMailer::Base.default :from => email_settings_env[:sender]
  ActionMailer::Base.default_url_options = { host: email_settings_env[:host_for_url], port: email_settings_env[:port_for_url] }
rescue => err
  STDERR.puts "Error loading email configuration: #{err.to_s}. Create config/email.yml file from example (config/email.yml.example) to enable email in this application"
end