defmodule ExfileSwift.Sharder do
  @moduledoc """
  A behaviour defining a module to calculate shard id from file id.
  """

  @doc "Calculate shard id"
  @callback shard_id(id :: String.t(), shard_size :: pos_integer()) :: String.t()
end
