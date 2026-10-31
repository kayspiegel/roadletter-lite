require "test_helper"

class Admin::LocalesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:admin) }

  test "switching to German stores the language on the admin" do
    patch admin_locale_path, params: { locale: "de" }

    assert_redirected_to admin_root_path
    assert_equal "de", users(:admin).reload.locale

    follow_redirect!
    assert_select "html[lang=de]"
    assert_select "h1", "Hallo, Kay."
  end

  test "an unknown language is ignored" do
    patch admin_locale_path, params: { locale: "fr" }

    assert_equal "en", users(:admin).reload.locale
  end

  test "asks to sign in first" do
    sign_out

    patch admin_locale_path, params: { locale: "de" }

    assert_redirected_to new_session_path
    assert_equal "en", users(:admin).reload.locale
  end
end
