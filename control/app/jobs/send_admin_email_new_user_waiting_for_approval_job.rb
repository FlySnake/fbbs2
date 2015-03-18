class SendAdminEmailNewUserWaitingForApprovalJob < ActiveJob::Base
  queue_as :default

  def perform(user, admin)
    AdminMailer.new_user_waiting_for_approval(user, admin).deliver_later
  end
end
