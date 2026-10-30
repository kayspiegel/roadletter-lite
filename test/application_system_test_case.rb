require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 900 ]

  setup { ActionController::Base.cache_store.clear }

  # Emulation lives on the browser, which outlasts a single test.
  teardown do
    page.driver.browser.execute_cdp("Emulation.clearDeviceMetricsOverride")
    emulate_media []
  end

  private
    def sign_in(email_address: users(:admin).email_address, password: "password")
      visit new_session_path
      fill_in "email_address", with: email_address
      fill_in "password", with: password
      find("button[type=submit]").click
    end

    def sign_out
      find(".account-menu__trigger").click
      within(".account-menu__panel") { find("button.account-menu__item").click }
    end

    def emulate_media(features)
      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features:)
    end

    def emulate_width(width)
      page.driver.browser.execute_cdp("Emulation.setDeviceMetricsOverride", width:, height: 844, deviceScaleFactor: 1, mobile: true)
    end
end
