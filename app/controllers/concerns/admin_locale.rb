# The admin area speaks the admin's language, signed in or not: there is only
# one admin, so the sign-in and password reset pages know it too. English until
# the admin exists. The browser's language is never read.
module AdminLocale
  extend ActiveSupport::Concern

  included do
    around_action :switch_to_admin_locale
  end

  private
    def switch_to_admin_locale(&action)
      I18n.with_locale(admin_locale, &action)
    end

    def admin_locale
      (Current.user || User.admin)&.locale || I18n.default_locale
    end
end
