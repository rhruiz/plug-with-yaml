defmodule Yarmel.ParserTest do
  use ExUnit.Case, async: true

  import Plug.Conn
  import Plug.Test

  alias Yarmel.YamlParser

  @supported_mime_types ~w[text/yaml text/x-yaml application/yaml application/x-yaml]

  describe "parse" do
    for mime <- @supported_mime_types do
      test "converts #{mime} bodies to params" do
        opts =
          Plug.Parsers.init(parsers: [YamlParser], pass: ["text/*"], yaml_decoder: YamlElixir)

        content = """
        some:
            - keys
            - are
            - here
        """

        assert %{"some" => ["keys", "are", "here"]} =
                 :post
                 |> conn("/", content)
                 |> put_req_header("content-type", unquote(mime))
                 |> Plug.Parsers.call(opts)
                 |> Map.get(:body_params)
      end
    end

    test "ignores text/plain bodies" do
      opts = Plug.Parsers.init(parsers: [YamlParser], pass: ["text/*"], yaml_decoder: YamlElixir)

      content = """
      some:
        - keys
        - are
        - here
      """

      assert %Plug.Conn.Unfetched{} =
               :post
               |> conn("/", content)
               |> put_req_header("content-type", "text/plain")
               |> Plug.Parsers.call(opts)
               |> Map.get(:body_params)
    end
  end
end
