defmodule ConvClaimWeb.ConversationController do
  use ConvClaimWeb, :controller
  alias ConvClaim.TurnClient
  action_fallback ConvClaimWeb.FallbackController

  def create(conn, %{"to" => to, "type" => "text", "text" => %{"body" => body}}) do
    reply_text = "You said: #{inspect(body)}"
    client = TurnClient.client()

    with [claim] <- Plug.Conn.get_req_header(conn, "x-turn-claim"),
         {:ok, _resp} <-
           TurnClient.send_text_message(client, to, reply_text, [{"x-turn-claim-release", claim}]) do
      conn
      |> put_status(:created)
      |> Plug.Conn.send_resp(201, "ok")
    end
  end
end
