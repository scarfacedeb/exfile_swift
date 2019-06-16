defmodule ExfileSwift.Sharder.Hex do
  @moduledoc """
  Default sharder based on modulo remainder of the last 3 hex digits of the file id.
  """

  @behaviour ExfileSwift.Sharder

  @impl true
  def shard_id(id, shard_size) do
    hex =
      id
      |> String.to_charlist()
      |> Enum.take(-3)
      |> List.to_integer(16)

    Integer.mod(hex, shard_size)
  end
end
