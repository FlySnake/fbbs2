begin
  email_settings = YAML::load(File.open("#{Rails.root.to_s}/config/email.yml"))
  email_settings_symbols_keys = email_settings[Rails.env].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} unless email_settings[Rails.env].nil?
  ActionMailer::Base.smtp_settings = email_settings_symbols_keys
  ActionMailer::Base.default :from => email_settings_symbols_keys[:sender]
  ActionMailer::Base.default_url_options = { host: email_settings_symbols_keys[:host_for_url], port: email_settings_symbols_keys[:port_for_url] }
rescue => err
  STDERR.puts "Error loading email configuration: #{err.to_s}. Create config/email.yml file from example (config/email.yml.example) to enable email in this application"
end