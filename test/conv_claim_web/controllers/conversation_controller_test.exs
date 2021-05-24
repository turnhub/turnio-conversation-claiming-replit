defmodule ConvClaimWeb.ConversationControllerTest do
  use ConvClaimWeb.ConnCase

  setup %{conn: conn} do
    bypass = Bypass.open()

    # Update config to use Bypass server instead of upstream Turn server
    Application.put_env(:conv_claim, ConvClaim.TurnClient,
      turn_token: "testing-token",
      turn_host: "http://127.0.0.1:#{bypass.port}"
    )

    # Generate the claim that normall Turn would send through
    claim = Ecto.UUID.generate()
    {:ok, bypass: bypass, claim: claim, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "create conversation", %{bypass: bypass, claim: claim, conn: conn} do
    Bypass.expect_once(bypass, "POST", "/v1/messages", fn conn ->
      [turn_claim] = Plug.Conn.get_req_header(conn, "x-turn-claim-release")

      {:ok, response, conn} = Plug.Conn.read_body(conn)
      {:ok, payload} = Jason.decode(response)

      assert payload["to"] == "27123456789"
      assert payload["text"]["body"] == "You said: \"hello world\""
      assert turn_claim == claim

      Plug.Conn.resp(
        conn,
        201,
        Jason.encode!(%{
          messages: [%{id: Ecto.UUID.generate()}]
        })
      )
    end)

    response =
      conn
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-turn-claim", claim)
      |> post(
        Routes.conversation_path(conn, :create),
        Jason.encode!(%{
          "to" => "27123456789",
          "type" => "text",
          "text" => %{
            "body" => "hello world"
          }
        })
      )
      |> response(201)

    assert response == "ok"
  end
end
