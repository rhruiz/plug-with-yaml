defmodule Yarmel.Server do
  use Plug.Router

  alias Plug.Adapters.Cowboy

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json, Yarmel.YamlParser],
    json_decoder: Jason,
    yaml_decoder: {YamlElixir, :read_from_string!, []}
  )

  plug(:match)
  plug(:dispatch)

  @doc "child spec to let us be supervised"
  def child_spec(opts) do
    Cowboy.child_spec(
      scheme: :http,
      plug: __MODULE__,
      options: Keyword.merge(opts, port: 4000)
    )
  end

  post "/" do
    send_resp(conn, 201, inspect(conn.body_params))
  end

  match _ do
    send_resp(conn, 503, "not yet")
  end
end
