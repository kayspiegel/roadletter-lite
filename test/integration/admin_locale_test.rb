require "test_helper"

class AdminLocaleTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  test "the sign-in page follows the admin's language, not the browser's" do
    users(:admin).update!(locale: "de")

    get new_session_path, headers: { "Accept-Language" => "en-US,en;q=0.9" }

    assert_select "html[lang=de]"
    assert_select "title", "Anmelden · Roadletter Lite"
    assert_select ".auth__note", "Dieser Roadletter hat ein Konto. Eine Registrierung gibt es nicht."
  end

  test "an English admin gets English, even when the browser asks for German" do
    get new_session_path, headers: { "Accept-Language" => "de-DE,de;q=0.9" }

    assert_select "html[lang=en]"
    assert_select "title", "Sign in · Roadletter Lite"
  end

  test "the password reset pages and the reset email follow the admin's language" do
    users(:admin).update!(locale: "de")

    get new_password_path, headers: { "Accept-Language" => "en" }
    assert_select "h1", "Passwort zurücksetzen"

    perform_enqueued_jobs do
      post passwords_path, params: { email_address: users(:admin).email_address }, headers: { "Accept-Language" => "en" }
    end
    assert_select "h1", "Schau in dein Postfach"

    email = ActionMailer::Base.deliveries.last
    assert_equal "Neues Passwort für Roadletter Lite wählen", email.subject
    assert_includes email.text_part.body.to_s, "Der Link gilt 15 Minuten und nur einmal."
  end

  test "English before the admin exists" do
    Session.delete_all
    User.delete_all

    get new_session_path, headers: { "Accept-Language" => "de" }

    assert_select "html[lang=en]"
    assert_select "title", "Sign in · Roadletter Lite"
  end
end
