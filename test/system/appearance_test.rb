require "application_system_test_case"

class AppearanceTest < ApplicationSystemTestCase
  test "the sign-in page follows the system's dark mode before anyone signs in" do
    emulate_media [ { name: "prefers-color-scheme", value: "light" } ]
    visit new_session_path
    assert_equal "rgb(247, 244, 238)", body_background, "light paper"

    emulate_media [ { name: "prefers-color-scheme", value: "dark" } ]

    assert_equal "rgb(28, 26, 23)", body_background, "dark paper"
  end

  test "the dashboard fits a 390 px phone without scrolling sideways" do
    sign_in
    assert_selector "h1", text: "Hello, Kay."

    emulate_width 390
    visit admin_root_path

    assert_selector ".header__nav"
    assert_selector ".empty-state"
    assert_operator page.evaluate_script("document.documentElement.scrollWidth"), :<=, 390
  end

  private
    def body_background
      page.evaluate_script("getComputedStyle(document.body).backgroundColor")
    end
end
