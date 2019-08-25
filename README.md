# Jsonlex

Jsonlex is `jsonl` file format logger. This provide simple storage approach.

Jsonlex can write json data concurrently that prevent applications slow down. We can analyze unstructure data using like `Pandas` etc. This module uses `Jason` for json encoder. It allows this module blazing fast writing jsonl files.

And fortunately, elixir can handle huge amount files utilizing multicore processes and have massive tools easily.

```elixir
  iex> Jsonlex.start_link :jsonl, filename: "/tmp/some_filename.jsonl"
  iex> Jsonlex.puts :jsonl, %{"ts" => DateTime.now("Etc/UTC") |> DateTime.to_unix, "hoge" => "fuga"}
```

Jsonlex allow datetime format.

```elixir
  iex> Jsonlex.start_link :jsonl, format: "/tmp/some_storage/%Y-%m-%d-%H.jsonl"
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `jsonlex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jsonlex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/jsonlex](https://hexdocs.pm/jsonlex).
