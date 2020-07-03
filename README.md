# Yarmel

Simple Elixir Plug app to POC yaml bodies.

Start with `mix run --no-halt` or `iex -S mix` and post some yaml here:

```
curl -i -XPOST --data-binary @test.yaml http://localhost:4000/
```
