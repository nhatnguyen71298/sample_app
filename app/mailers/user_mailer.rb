class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("warning.subject_activated")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("email_reset_password.active")
  end
end
