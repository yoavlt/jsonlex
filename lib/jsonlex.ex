defmodule Jsonlex do

  require Logger

  @moduledoc """
  Jsonl is `jsonl` format logger. This provide simple storage approach.

  Jsonl can write json data concurrently that prevent applications slow down. We can analize unstructure data using like `Pandas` etc. Jsonl use `Jason` for json encoder. It allows this module blazing fast writing jsonl files.

  Fortunately, Elixir can handle huge amount files using multicore processes and have massive tools easily.

      iex> Jsonlex.start_link :jsonl, filename: "/tmp/some_filename.jsonl"
      iex> Jsonlex.puts :jsonl, %{"ts" => DateTime.utc_now |> DateTime.to_unix, "hoge" => "fuga"}

  Jsonlex allow datetime format.

      iex> Jsonlex.start_link :jsonl, format: "/tmp/some_storage/%Y-%m-%d-%H.jsonl"

  Close file.

      iex> Jsonlex.close :jsonl
  """

  use GenServer

  @doc """
  Create Jsonlex logger process it allows to set datetime format filename.

  ## Examples

      iex> Jsonlex.start_link :jsonl, filename: "/tmp/some_filename.jsonl"

  Jsonlex allow datetime format.

      iex> Jsonlex.start_link :jsonl, format: "/tmp/some_storage/%Y-%m-%d-%H.jsonl"

  """
  def start_link(name, opts \\ []) do
    GenServer.start_link __MODULE__, opts, name: name
  end

  @doc """
  Write json to file
  """
  def puts(pid, body) do
    GenServer.cast(pid, {:puts, body})
  end

  @doc """
  Close file
  """
  def close(pid) do
    GenServer.cast(pid, :close)
  end

  @impl true
  def init(opts) do
    filename = opts[:filename]
    format   = opts[:format]
    {:ok, %{file: nil, filename: filename, format: format, path: nil}}
  end

  @impl true
  def handle_cast({:puts, body}, state) do
    {path, file} = get_file(state)

    file
    |> IO.puts(Jason.encode!(body))

    {:noreply, %{state | path: path, file: file}}
  end

  @impl true
  def handle_cast(:close, state = %{file: nil}), do: {:noreply, state}
  def handle_cast(:close, state = %{file: file}) do
    File.close(file)
    {:noreply, %{state | file: nil}}
  end

  @impl true
  def terminate(_reason, %{file: file}) do
    File.close(file)
    :ok
  end


  defp get_file(s = %{path: path, file: file}) do
    case get_filename(s) do
      ^path -> {path, file}
      name  ->
        File.close(path)
        {name, File.open!(name, [:delayed_write, :append])}
    end
  end

  defp get_filename(%{filename: filename, format: nil}), do: filename
  defp get_filename(%{filename: nil, format: format}) do
    Timex.format!(DateTime.utc_now, format, :strftime)
  end

end
