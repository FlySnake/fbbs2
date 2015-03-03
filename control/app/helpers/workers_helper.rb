module WorkersHelper
  def tr_class_by_status(status)
    case status
    when :ready
      "success"
    when :offline
      "danger"
    when :busy
      "warning"  
    else
      "info"
    end
  end
end
