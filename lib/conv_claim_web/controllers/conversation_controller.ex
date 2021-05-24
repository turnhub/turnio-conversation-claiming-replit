defmodule ConvClaimWeb.ConversationController do
  use ConvClaimWeb, :controller
  alias ConvClaim.TurnClient
  action_fallback(ConvClaimWeb.FallbackController)

  def create(conn, %{
        "messages" => [%{"from" => to, "type" => "text", "text" => %{"body" => body}}]
      }) do
    reply_text = "You said: #{inspect(body)}"
    client = TurnClient.client()

    with [claim] <-
           Plug.Conn.get_req_header(conn, "x-turn-claim"),
         {:ok, %Tesla.Env{status: status}} when status in [200, 201] <-
           TurnClient.send_text_message(client, to, reply_text, [{"x-turn-claim-release", claim}]) do
      conn
      |> put_status(:created)
      |> Plug.Conn.send_resp(201, "ok")
    else
      {:ok, %Tesla.Env{status: status}} ->
        conn
        |> put_status(status)
        |> Plug.Conn.send_resp(status, "Turn response code")

      {:error, %Tesla.Env{status: status}} ->
        conn
        |> put_status(status)
        |> Plug.Conn.send_resp(status, "Turn response code")

      {:error, reason} ->
        conn
        |> put_status(503)
        |> Plug.Conn.send_resp(503, "Turn error: #{inspect(reason)}")
    end
  end
end
