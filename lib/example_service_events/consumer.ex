defmodule ExampleServiceEvents.Consumer do
  use Kafee.Consumer,
    adapter: Application.compile_env(:example_service, [__MODULE__, :adapter]),
    decoder: Kafee.JasonEncoderDecoder,
    topic: "example-event",
    consumer_group_id: "example-service"

  require Logger

  @impl Kafee.Consumer
  def handle_message(%Kafee.Consumer.Message{} = _message) do
    :ok
  end
end
