module TestsResultsHelper
  def result_text tcase
    if tcase.result == :ok
      res = "<font color='green'>ok</font>"
    else
      res = "<font color='red'>fail</font><pre>#{tcase.failure_message}</pre>"
    end
    res.html_safe
  end
end
