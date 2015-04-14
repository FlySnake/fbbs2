class TestCaseResult
  attr_accessor :suite, :short_description, :long_description, :result, :time, :failure_message
  
  def initialize(suite, short_desrciption, result, time, failure_message="")
    @suite = suite
    @short_description = short_desrciption
    @long_description = ""
    @result = result
    @time = time
    @failure_message = failure_message
  end
 
end