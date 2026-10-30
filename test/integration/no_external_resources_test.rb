require "test_helper"

# Every font, stylesheet, script and image comes from Roadletter Lite itself.
# Links to other sites are fine; anything the browser loads on its own is not.
class NoExternalResourcesTest < ActionDispatch::IntegrationTest
  test "the sign-in and password reset pages load nothing from other hosts" do
    [ new_session_path, new_password_path ].each do |path|
      get path
      assert_only_own_resources path
    end
  end

  test "the dashboard loads nothing from other hosts" do
    sign_in_as users(:admin)

    get admin_root_path

    assert_only_own_resources admin_root_path
  end

  private
    def assert_only_own_resources(path)
      resources = page_resources
      stylesheets = resources.select { |url| url.end_with?(".css") }
      assert_not_empty stylesheets, "#{path} links no stylesheets"

      stylesheets.each do |stylesheet|
        get stylesheet
        resources += response.body.scan(/url\(\s*["']?([^"')]+)/).flatten + response.body.scan(/@import\s+["']([^"']+)/).flatten
      end

      foreign = resources.reject { |url| own?(url) }
      assert_empty foreign, "#{path} loads from other hosts"
      assert_no_match %r{https?://|//}, response_csp(path), "#{path} allows other hosts in its CSP"
    end

    def page_resources
      document = Nokogiri::HTML(response.body)
      importmap = JSON.parse(document.at_css("script[type=importmap]")&.text || "{}").fetch("imports", {}).values

      document.css("link[href]").reject { |link| %w[ canonical alternate ].include?(link["rel"]) }.map { |link| link["href"] } +
        document.css("script[src], img[src], iframe[src], source[src], video[src], audio[src]").map { |element| element["src"] } +
        importmap
    end

    def own?(url)
      url.start_with?("data:") || (url.start_with?("/") && !url.start_with?("//")) || !url.match?(%r{\A[a-z][a-z0-9+.-]*:|\A//}i)
    end

    def response_csp(path)
      get path
      response.headers["Content-Security-Policy"].to_s
    end
end
