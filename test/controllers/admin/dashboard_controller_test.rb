require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "asks to sign in first" do
    get admin_root_path
    assert_redirected_to new_session_path
  end

  test "welcomes the admin and points to Amazon SES" do
    sign_in_as users(:admin)

    get admin_root_path

    assert_response :success
    assert_select "h1", "Hello, Kay."
    assert_select ".page__lead", "Roadletter Lite is installed. Next up: connecting Amazon SES."
    assert_select "a[href=?]", "https://github.com/kayspiegel/roadletter-lite/blob/main/docs/ses-gdpr.md", "Read the Amazon SES setup guide"
  end

  test "the root leads to the dashboard" do
    get root_path
    assert_redirected_to "/admin"
  end
end
