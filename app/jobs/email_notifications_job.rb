class EmailNotificationsJob < ActiveJob::Base
  queue_as :high_priority

  def perform(user)
    UserMailer.registration_success(user).deliver_now
  end
end
