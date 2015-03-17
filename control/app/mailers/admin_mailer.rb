class AdminMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def new_user_waiting_for_approval(user, admin)
    @user = user
    mail(to: admin.email, subject: 'User is waiting for approval.')
  end
end
