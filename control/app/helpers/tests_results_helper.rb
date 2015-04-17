module TestsResultsHelper
  def result_text tcase
    if tcase.result == :ok
      res = "<font color='green'>ok</font>"
    else
      res = "<font color='red'>fail</font><pre>#{tcase.failure_message}</pre>"
    end
    res.html_safe
  end
  
  def total_tests tests_results
    total = 0
    tests_results.each do |t|
      total += t.cases.count
    end
    total
  end
  
  def failed_tests tests_results
    total = 0
    tests_results.each do |t|
      total += t.cases.select {|f| f.result != :ok}.count
    end
    total
  end
  
  def total_time tests_results
    total = 0
    tests_results.each do |t|
      time_in_cases = 0
      t.cases.each do |tm|
        time_in_cases += tm.time.to_i
      end
      total += time_in_cases
    end
    total
  end
  
  def failed_tests_with_style number_of_failed_tests
    if number_of_failed_tests == 0
      number_of_failed_tests
    else
      "<b><font color='red'>#{number_of_failed_tests}</font></b>".html_safe
    end
  end
  
end
