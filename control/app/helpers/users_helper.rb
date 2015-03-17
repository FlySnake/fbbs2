module UsersHelper
  def approved_text(user)
    if user.approved
      simple_format("Yes", :class => "text-success")
    else
      simple_format("No. " + link_to("Approve now", approve_user_path(user), :method => :patch), :class => "text-danger")
    end
  end
  
  def admin_text(user)
    if user.admin?
      simple_format("Yes")
    else
      simple_format("No")
    end
  end 
end
