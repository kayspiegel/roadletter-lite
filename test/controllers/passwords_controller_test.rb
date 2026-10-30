require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup { @admin = users(:admin) }

  test "new" do
    get new_password_path
    assert_response :success
  end

  test "create sends the reset email to the admin" do
    post passwords_path, params: { email_address: @admin.email_address }

    assert_enqueued_email_with PasswordsMailer, :reset, args: [ @admin ]
    assert_response :success
    assert_select "h1", "Check your inbox"
  end

  test "create for an unknown address sends nothing and looks exactly the same" do
    post passwords_path, params: { email_address: @admin.email_address }
    for_admin = page_without(@admin.email_address)

    post passwords_path, params: { email_address: "nobody@example.com" }
    for_unknown = page_without("nobody@example.com")

    assert_enqueued_emails 1
    assert_equal for_admin, for_unknown
  end

  test "too many reset requests are slowed down with a plain message" do
    10.times { post passwords_path, params: { email_address: "nobody@example.com" } }

    post passwords_path, params: { email_address: @admin.email_address }

    assert_response :too_many_requests
    assert_select ".flash__message", "Too many reset requests. Please wait a moment and try again."
    assert_enqueued_emails 0
  end

  test "too many new passwords are slowed down too" do
    # Invalid links count too: the limit runs before the token is looked up.
    10.times { put password_path("invalid token"), params: { password: "a-new-password", password_confirmation: "a-new-password" } }

    assert_no_changes -> { @admin.reload.password_digest } do
      put password_path(@admin.password_reset_token), params: { password: "a-new-password", password_confirmation: "a-new-password" }
    end

    assert_response :too_many_requests
    assert_select ".flash__message", "Too many reset requests. Please wait a moment and try again."
  end

  test "edit" do
    get edit_password_path(@admin.password_reset_token)
    assert_response :success
  end

  test "edit with an invalid or used link explains that it has expired" do
    get edit_password_path("invalid token")

    assert_response :gone
    assert_select "h1", "This link has expired"
  end

  test "update with an invalid or used link explains that it has expired" do
    put password_path("invalid token"), params: { password: "a-new-password", password_confirmation: "a-new-password" }

    assert_response :gone
    assert_select "h1", "This link has expired"
  end

  test "update saves the new password and asks to sign in with it" do
    assert_changes -> { @admin.reload.password_digest } do
      put password_path(@admin.password_reset_token), params: { password: "a-new-password", password_confirmation: "a-new-password" }
    end

    assert_redirected_to new_session_path
    follow_redirect!
    assert_select ".flash__message", "Your new password is saved. Sign in with it."
  end

  test "a reset link works only once" do
    token = @admin.password_reset_token
    put password_path(token), params: { password: "a-new-password", password_confirmation: "a-new-password" }

    get edit_password_path(token)

    assert_response :gone
  end

  test "update with passwords that don't match" do
    assert_no_changes -> { @admin.reload.password_digest } do
      put password_path(@admin.password_reset_token), params: { password: "a-new-password", password_confirmation: "another" }
    end

    assert_response :unprocessable_entity
    assert_select "#password-confirmation-error", "Type the same password in both fields."
    assert_select "#password_confirmation[aria-describedby=password-confirmation-error]"
  end

  test "update with a password that is too short" do
    assert_no_changes -> { @admin.reload.password_digest } do
      put password_path(@admin.password_reset_token), params: { password: "elevenchars", password_confirmation: "elevenchars" }
    end

    assert_response :unprocessable_entity
    assert_select "#password-error", "Choose a password with at least 12 characters."
    assert_select "#password[aria-describedby=password-error]"
  end

  test "update with an empty password" do
    assert_no_changes -> { @admin.reload.password_digest } do
      put password_path(@admin.password_reset_token), params: { password: "", password_confirmation: "" }
    end

    assert_response :unprocessable_entity
    assert_select "#password-error", "Enter a new password."
  end

  private
    # The page as a visitor sees it, with the typed address taken out.
    def page_without(email_address)
      css_select("main").to_html.gsub(email_address, "ADDRESS")
    end
end
