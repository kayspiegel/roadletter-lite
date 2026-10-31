require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "the admin signs in and lands on the dashboard" do
    sign_in

    assert_selector "h1", text: "Hello, Kay."
    assert_text "Next up: connecting Amazon SES."
    assert_link "Read the Amazon SES setup guide"
  end

  test "the admin signs out and has to sign in again" do
    sign_in
    assert_selector "h1", text: "Hello, Kay."

    sign_out

    assert_current_path new_session_path
    visit admin_root_path
    assert_current_path new_session_path
    assert_button "Sign in"
  end

  test "a wrong password keeps the admin on the sign-in page" do
    sign_in password: "wrong"

    assert_current_path new_session_path
    assert_text "Check your email and password and try again."
  end

  test "the admin resets a forgotten password" do
    visit new_session_path
    click_link "Forgot password?"
    fill_in "email_address", with: users(:admin).email_address
    click_button "Email me a reset link"

    # The form submits without Turbo, so wait for the new page before querying
    # it: a node from the old one can vanish mid-query with an unknown error.
    assert_current_path passwords_path
    assert_selector "h1", text: "Check your inbox"
    assert_text "If #{users(:admin).email_address} is the address of this Roadletter"
  end
end
