# Kia11y

[![Build Status](https://travis-ci.org/jaimeiniesta/kia11y.svg?branch=master)](https://travis-ci.org/jaimeiniesta/kia11y)
[![Hex.pm](https://img.shields.io/hexpm/v/kia11y.svg)](https://hex.pm/packages/kia11y)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/jaimeiniesta/kia11y.svg)](https://beta.hexfaktor.org/github/jaimeiniesta/kia11y)

Kia11y is an Elixir client for the [AccessLint Service](https://github.com/jaimeiniesta/accesslint-service), which is a web service for [accesslint-cli](https://github.com/accesslint/accesslint-cli.js), which is a wrapper for the awesome [axe-core](https://github.com/dequelabs/axe-core) Accessibility Engine.

In short, Kia11y aims to be the simplest way to integrate A11Y checking in Elixir projects.

[<img src="https://dl.dropboxusercontent.com/u/2268180/kiai/kiai-original.png" alt="Kiai calligraphy image taken from http://www.gohitsushodostudio.com/what-is-kiai/">](https://www.youtube.com/watch?v=bKDr-hVgwCI)

## Installation

This package can be [installed from Hex](https://hex.pm/docs/publish), as:

  1. Add `kia11y` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:kia11y, "~> 0.1.0"}]
    end
    ```

  2. Ensure `kia11y` is started before your application:

    ```elixir
    def application do
      [applications: [:kia11y]]
    end
    ```

## Usage

To check A11Y on a web page, just pass it the URL to check, like this:

```elixir
{ outcome, response } = Kia11y.check("http://validationhell.com")
```

If all goes well, `outcome` will be `:ok` but it could be any of the following:

* `ok` means the check was performed, you'll get also the `violations` found.
* `error` means the `url` param was invalid.
* `busy` means that there was a timeout due to server overload.
* `crash` means there was an internal server error.

A11Y violations can be accessed through `response["violations"]`, for example:

```elixir
iex> response["violations"]
[ %{
     "help"  => "Images must have alternate text", "impact" => "critical",
     "nodes" => [ "body > .navbar.navbar-fixed-top > .navbar-inner > .container-fluid > .brand > img",
                  "body > .container-fluid > .row-fluid > .span10 > .hero-unit > div > a:nth-of-type(1) > img" ],
     "url"   => "http://validationhell.com/"
   },

   %{
      "help"  => "Links must have discernible text", "impact" => "critical",
      "nodes" => [ "body > .container-fluid > .row-fluid > .span2 > .well.sidebar-nav > .nav.nav-list > a",
                   "body > .container-fluid > .row-fluid > .span2 > .well.sidebar-nav > a",
                   "#social > a",
                   "body > .container-fluid > .row-fluid > .span10 > .hero-unit > div > a:nth-of-type(1)" ],
      "url"   => "http://validationhell.com/" },

   %{
      "help"   => "<ul> and <ol> must only directly contain <li>, <script> or <template> elements",
      "impact" => "serious",
      "nodes"  => [ "body > .container-fluid > .row-fluid > .span2 > .well.sidebar-nav > .nav.nav-list" ],
      "url" => "http://validationhell.com/"
    }
]
```

## Using alternate servers

By default, Kia11y will use the demo server for AccessLint Service at https://accesslint-service-demo.herokuapp.com/ but you're encouraged to install your own instances of the server and use them instead. The demo server is just intended for, you guessed it, demo purposes and might be down or overwhelmed.

To use your own servers, pass an array with their URLs and a random one will be picked for each request (poor man's load balancer):

```elixir
Kia11y.check("http://validationhell.com", checker_urls: ["http://example.com/validator1", "http://example.com/validator2", ])
```

## Contributing

1. Fork it ( https://github.com/jaimeiniesta/kia11y/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
