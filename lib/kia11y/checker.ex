defmodule Kia11y.Checker do
  @moduledoc """
  Provides methods to validate A11Y on the AccessLint Service A11Y Checker.
  """

  @doc """
  Validates the given URL on the AccessLint Service A11Y Checker.

  Options:

  * Will use by default the AccessLint Service demo at https://accesslint-service-demo.herokuapp.com/,
    this can and should be customized to use your own instances, with the `checker_urls` option.
    This is expected to be an array of strings, Kia11y will pick a random one for each check.

  ## Examples

    iex> { :ok, %{ "violations" => violations } } = Kia11y.check("http://validationhell.com")
    iex> length(violations)
    3
    iex> first = List.first(violations)
    iex> first["url"]
    "http://validationhell.com/"
    iex> first["impact"]
    "critical"
    iex> first["help"]
    "Images must have alternate text"
    iex> first["nodes"]
    ["body > .navbar.navbar-fixed-top > .navbar-inner > .container-fluid > .brand > img",
     "body > .container-fluid > .row-fluid > a > .span10 > .hero-unit > div > img"]

  """
  def check(url, options \\ []) do
    options = Keyword.merge(default_options, options)

    accesslint_service_request_querystring(url, options)
    |> HTTPoison.get([], [recv_timeout: 15_000])
    |> handle_response
  end

  defp accesslint_service_request_querystring(url, options) do
    checker_url = Enum.random(options[:checker_urls])

    query = URI.encode_query(%{ url: url })

    "#{checker_url}check?#{query}"
  end

  defp handle_response({ :ok, %{ status_code: 200, body: body }}) do
    { :ok, Poison.Parser.parse!(body) }
  end

  defp handle_response({ :ok, %{ status_code: 400, body: body }}) do
    { :error, Poison.Parser.parse!(body) }
  end

  defp handle_response({ :ok, %{ status_code: 503, body: body }}) do
    { :busy, Poison.Parser.parse!(body) }
  end

  defp handle_response({ :ok, %{ status_code: 500, body: body }}) do
    { :crash, Poison.Parser.parse!(body) }
  end

  defp handle_response({ :error, %{ reason: reason } }) do
    { :error, reason }
  end

  defp default_options do
    [
      checker_urls: [ "https://accesslint-service-demo.herokuapp.com/" ]
    ]
  end
end
