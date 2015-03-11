module ModelHelpers
  def without_sql_logging
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    yield
    ActiveRecord::Base.logger = old_logger
  end
 
  def attr_accessor_with_onchange_callback(*args, &block)
    raise 'Callback block is required' unless block
    args.each do |arg|
      attr_name = arg.to_s
      define_method(attr_name) do
         self.instance_variable_get("@#{attr_name}")
      end
      define_method("#{attr_name}=") do |argument|
        old_value = self.instance_variable_get("@#{attr_name}")
        if argument != old_value
          self.instance_variable_set("@#{attr_name}", argument)
          self.instance_exec(attr_name, argument, old_value, &block)
        end
      end   
    end
  end

end