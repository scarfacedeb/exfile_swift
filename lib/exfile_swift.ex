defmodule ExfileSwift do
  use Exfile.Backend

  alias Exfile.LocalFile

  @ex_swift_opts ~w[auth_url username password region]a

  def init(opts) do
    {ex_swift_opts, opts} = Keyword.split(opts, @ex_swift_opts)
    container = Keyword.fetch!(opts, :container)

    {:ok, backend} = super(opts)

    swift = ExSwift.Config.new(ex_swift_opts)

    put_in(backend.meta, %{
      swift: swift,
      container: container
    })
  end

  def open(%{meta: m} = backend, id) do
    case ExSwift.get_object(m.swift, m.container, path(backend, id)) do
      {:ok, response} ->
        io = File.open!(response.body, [:ram, :binary])
        {:ok, %LocalFile{io: io}}

      {:error, error} ->
        {:error, error}
    end
  end

  def exists?(%{meta: m} = backend, id) do
    case ExSwift.head_object(m.swift, m.container, path(backend, id)) do
      {:ok, _} ->
        true

      _ ->
        false
    end
  end

  def size(%{meta: m} = backend, id) do
    case ExSwift.head_object(m.swift, m.container, path(backend, id)) do
      {:ok, response} ->
        length = response |> ExSwift.Request.get_header("content-length") |> String.to_integer()
        {:ok, length}

      {:error, error} ->
        {:error, error}
    end
  end

  def delete(%{meta: m} = backend, file_id) do
    case ExSwift.delete_object(m.swift, m.container, path(backend, file_id)) do
      {:ok, _} -> :ok
      {:error, error} -> {:error, error}
    end
  end

  def upload(backend, %Exfile.File{} = other_file) do
    case Exfile.File.open(other_file) do
      {:ok, local_file} ->
        upload(backend, local_file)

      {:error, error} ->
        {:error, error}
    end
  end

  def upload(backend, %LocalFile{} = local_file) do
    id = backend.hasher.hash(local_file)

    case LocalFile.open(local_file) do
      {:ok, io} ->
        do_upload(backend, id, io)

      {:error, error} ->
        {:error, error}
    end
  end

  defp do_upload(%{meta: m} = backend, id, io) do
    with iodata when is_binary(iodata) <- IO.binread(io, :all) do
      case ExSwift.put_object(m.swift, m.container, id, iodata) do
        {:ok, _} -> {:ok, get(backend, id)}
        {:error, error} -> {:error, error}
      end
    end
  end

  def path(%{directory: directory}, id) do
    [directory, id]
    |> Enum.reject(&is_empty?/1)
    |> Enum.join("/")
  end

  defp is_empty?(elem) do
    string = to_string(elem)
    Regex.match?(~r/^\s*$/, string)
  end
end
