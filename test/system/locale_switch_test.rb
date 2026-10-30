require "application_system_test_case"

class LocaleSwitchTest < ApplicationSystemTestCase
  ENGLISH = [ "Hello", "Issues", "Subscribers", "Settings", "New issue", "Nothing here yet", "Read the Amazon SES setup guide" ]

  test "the admin switches to German, and it stays German after signing in again" do
    sign_in
    click_button "Deutsch", match: :first

    assert_selector "h1", text: "Hallo, Kay."
    assert_german_admin_area

    sign_out
    assert_selector ".auth__note", text: "Dieser Roadletter hat ein Konto. Eine Registrierung gibt es nicht."
    assert_button "Anmelden"

    sign_in
    assert_selector "h1", text: "Hallo, Kay."
    assert_german_admin_area
  end

  test "the admin switches back to English" do
    users(:admin).update!(locale: "de")
    sign_in
    assert_selector "h1", text: "Hallo, Kay."

    click_button "English", match: :first

    assert_selector "h1", text: "Hello, Kay."
    assert_text "Issues"
    assert_no_text "Ausgaben"
  end

  private
    def assert_german_admin_area
      assert_text "Ausgaben"
      assert_text "Abonnent:innen"
      assert_text "Neue Ausgabe"
      ENGLISH.each { |text| assert_no_text text }
    end
end
