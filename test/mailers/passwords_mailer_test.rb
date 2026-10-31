require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  test "reset contains a link to choose a new password, in HTML and plain text" do
    admin = users(:admin)

    email = PasswordsMailer.reset(admin)

    assert_equal [ admin.email_address ], email.to
    assert_equal "Choose a new password for Roadletter Lite", email.subject
    assert_match %r{http://example.com/passwords/[^/\s"]+/edit}, email.html_part.body.to_s
    assert_match %r{http://example.com/passwords/[^/\s"]+/edit}, email.text_part.body.to_s
    assert_includes email.text_part.body.to_s, "If you didn’t ask for a new password, ignore this email."
  end

  test "reset is in the admin's language" do
    admin = users(:admin)
    admin.update!(locale: "de")

    email = PasswordsMailer.reset(admin)

    assert_equal "Neues Passwort für Roadletter Lite wählen", email.subject
    assert_includes email.html_part.body.to_s, "Neues Passwort wählen"
  end
end
