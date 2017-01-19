defmodule Kia11y do
  @moduledoc """
  Kia11y is an Elixir client for the AccessLint Service A11Y Checker.
  """

  @doc """
  Convenience method, this is just a shortcut for `Kia11y.Checker.check/2`.
  """
  def check(url, options \\ []) do
    Kia11y.Checker.check(url, options)
  end
end
