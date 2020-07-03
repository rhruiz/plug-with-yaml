defmodule Yarmel do
  @moduledoc """
  Documentation for `Yarmel`.
  """

  use Application

  def start(_type, _args) do
    children = [Yarmel.Server]
    opts = [strategy: :one_for_one, name: Yarmel.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
