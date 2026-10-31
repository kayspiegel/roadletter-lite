class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user

    I18n.with_locale(user.locale) do
      mail subject: t(".subject"), to: user.email_address
    end
  end
end
