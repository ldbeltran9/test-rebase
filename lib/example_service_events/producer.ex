defmodule ExampleServiceEvents.Producer do
  use Kafee.Producer,
    adapter: Application.compile_env(:example_service, [__MODULE__, :adapter]),
    encoder: Kafee.JasonEncoderDecoder,
    topic: "example-event",
    partition_fun: :random

  def publish(:example_event, _example_event_data) do
    produce(%Kafee.Producer.Message{
      key: "example-event-key",
      value: "example-event-value"
    })
  end
end
