defmodule CheckerTest do
  use ExUnit.Case
  doctest Kia11y.Checker

  import Kia11y.Checker
  import Mock

  test "checks an URL" do
    with_mock HTTPoison, [get: fn(_url, _headers, _options) -> mocked_validation end] do
      { outcome, response } = check "http://validationhell.com"

      assert outcome == :ok

      assert response["outcome"] == "ok"
      assert response["url"]     == "http://validationhell.com"

      violations = [ first_violation | _ ] = response["violations"]

      assert length(violations) == 3
      assert first_violation["url"]    == "http://validationhell.com/"
      assert first_violation["help"]   == "Images must have alternate text"
      assert first_violation["impact"] == "critical"
      assert first_violation["nodes"]  == [ "body > .navbar.navbar-fixed-top > .navbar-inner > .container-fluid > .brand > img",
                                            "body > .container-fluid > .row-fluid > a > .span10 > .hero-unit > div > img" ]
    end
  end

  test "returns an error if the URL is not valid" do
    with_mock HTTPoison, [get: fn(_url, _headers, _options) -> mocked_error end] do
      { outcome, response } = check "nonsense"

      assert outcome == :error
      assert response["url"]    == "nonsense"
      assert response["errors"] == ["Invalid url"]
    end
  end

  test "when the server is busy" do
    with_mock HTTPoison, [get: fn(_url, _headers, _options) -> mocked_busy end] do
      { outcome, response } = check "http://validationhell.com"

      assert outcome == :busy
      assert response["url"] == "http://validationhell.com"
    end
  end

  test "when the server crashes" do
    with_mock HTTPoison, [get: fn(_url, _headers, _options) -> mocked_crash end] do
      { outcome, response } = check "http://validationhell.com"

      assert outcome == :crash
      assert response["url"] == "http://validationhell.com"
    end
  end

  defp mocked_validation do
    { :ok, %{ status_code: 200, body: mocked_json } }
  end

  defp mocked_json do
    """
    {
        "url": "http://validationhell.com",
        "outcome": "ok",
        "violations": [
            {
                "url": "http://validationhell.com/",
                "nodes": [
                    "body > .navbar.navbar-fixed-top > .navbar-inner > .container-fluid > .brand > img",
                    "body > .container-fluid > .row-fluid > a > .span10 > .hero-unit > div > img"
                ],
                "impact": "critical",
                "help": "Images must have alternate text"
            },
            {
                "url": "http://validationhell.com/",
                "nodes": [
                    "body > .container-fluid > .row-fluid > .span2 > .well.sidebar-nav > .nav.nav-list > a",
                    "body > .container-fluid > .row-fluid > .span2 > .well.sidebar-nav > a",
                    "body > .container-fluid > .row-fluid > .span2 > a",
                    "body > .container-fluid > a",
                    "body > .container-fluid > footer > a"
                ],
                "impact": "critical",
                "help": "Links must have discernible text"
            },
            {
                "url": "http://validationhell.com/",
                "nodes": [
                    "body > .container-fluid > .row-fluid > .span2 > .well.sidebar-nav > .nav.nav-list"
                ],
                "impact": "serious",
                "help": "<ul> and <ol> must only directly contain <li>, <script> or <template> elements"
            }
        ]
    }
    """
  end

  defp mocked_error do
    { :ok, %{ status_code: 400, body: mocked_json_for_error } }
  end

  defp mocked_json_for_error do
    """
    {
      "url": "nonsense",
      "outcome": "error",
      "errors": ["Invalid url"]
    }
    """
  end

  defp mocked_busy do
    { :ok, %{ status_code: 503, body: mocked_json_for_busy } }
  end

  defp mocked_json_for_busy do
    """
    {
      "url": "http://validationhell.com",
      "outcome": "busy"
    }
    """
  end

  defp mocked_crash do
    { :ok, %{ status_code: 500, body: mocked_json_for_crash } }
  end

  defp mocked_json_for_crash do
    """
    {
      "url": "http://validationhell.com",
      "outcome": "crash"
    }
    """
  end
end
