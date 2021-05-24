defmodule ConvClaim.TurnClient do
  def send_text_message(client, to, body, headers \\ []) do
    Tesla.post(
      client,
      "/v1/messages",
      %{
        "to" => to,
        "type" => "text",
        "text" => %{
          "body" => body
        }
      },
      headers: headers
    )
  end

  # build dynamic client based on runtime arguments
  def client() do
    config = Application.get_env(:conv_claim, __MODULE__)
    turn_token = Keyword.get(config, :turn_token)
    turn_host = Keyword.get(config, :turn_host)

    middleware = [
      {Tesla.Middleware.BaseUrl, turn_host},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> turn_token}]}
    ]

    Tesla.client(middleware)
  end
end
