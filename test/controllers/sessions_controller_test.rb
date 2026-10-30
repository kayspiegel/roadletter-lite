require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @admin = users(:admin) }

  test "new explains that there is one account" do
    get new_session_path

    assert_response :success
    assert_select ".auth__note", "This Roadletter has one account. There is no sign-up."
  end

  test "create with valid credentials signs in and opens the dashboard" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }

    assert_redirected_to admin_root_url
    assert cookies[:session_id]
  end

  test "a wrong password and an unknown address get the same message" do
    post session_path, params: { email_address: @admin.email_address, password: "wrong" }
    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
    follow_redirect!
    wrong_password = css_select(".flash").to_html

    post session_path, params: { email_address: "nobody@example.com", password: "wrong" }
    follow_redirect!

    assert_equal "Check your email and password and try again.", css_select(".flash__message").text
    assert_equal wrong_password, css_select(".flash").to_html
  end

  test "too many attempts are slowed down with a plain message" do
    10.times { post session_path, params: { email_address: @admin.email_address, password: "wrong" } }

    post session_path, params: { email_address: @admin.email_address, password: "password" }

    assert_response :too_many_requests
    assert_nil cookies[:session_id]
    assert_select ".flash__message", "Too many sign-in attempts. Please wait a moment and try again."
  end

  test "destroy signs out" do
    sign_in_as @admin

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end
end
